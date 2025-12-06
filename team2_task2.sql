--1 ANALYTICAL QUESTION 
--How does dish preparation time influence the total delivery duration?
WITH delivery_stats AS (
    SELECT
        o. order_id,
        o. restaurant_id,
        r. avg_prep_time_minutes AS prep_time,
        d. pickup_time,
        d. dropoff_time,
    -- SQLite uses strftime to compute time differences in minutes 
    (strftime('%s', d.dropoff_time) - strftime('es', d.pickup_time)) / 60.0
        AS delivery_duration_minutes
    FROM orders o
    JOIN deliveries d ON o.order_id = d.order_id
    JOIN restaurants r ON o. restaurant_id = r. restaurant_id
    WHERE d.pickup_time IS NOT NULL 
        AND d. dropoff_time IS NOT NULL
)
SELECT
    prep_time,
    AVG (delivery_duration_minutes) AS avg_delivery_duration
FROM delivery_stats
GROUP BY prep_time
ORDER BY prep_time;

--5 STANDARD ANALYTICAL QUERIES
--Question 1: Which cuisine types generate the highest average order value?
SELECT
    cuisine_type AS "Cuisine Type",
    AVG(order_total) AS "Average Order Value"
FROM (
    -- Calculate total value for each delivered order
    SELECT
        o.order_id,
        r.cuisine_type,
        SUM (oi.item_price_at_order * oi.quantity) AS order_total
    FROM orders o
    JOIN restaurants r ON r.restaurant_id = o. restaurant_id
    JOIN order_items oi ON o.order_id = oi. order_id
    WHERE o.status = 'delivered'
    GROUP BY o.order_id, r.cuisine_type
) AS order_totals
GROUP BY cuisine_type
ORDER BY "Average Order Value" DESC;

--Question 2: How often and how recently do customers place orders? 
WITH customer_orders AS (
    SELECT customer_id,
        COUNT (order_id) AS total_orders, --Total number of orders placed by each customer
        MAX (order_datetime) AS last_order, -- Most recent order date per customer
        MIN (order_datetime) AS first_order, -- First order date per customer
        JULIANDAY (MAX (order_datetime)) - JULIANDAY(MIN(order_datetime)) AS active_days
    FROM orders
    GROUP BY customer_id
)
SELECT customer_id,
    total_orders, 
    last_order,
    ROUND (active_days / total_orders, 2) AS avg_days_between_orders -- Average days between orders per customer
FROM customer_orders;

--Question 3: Which delivery partners are fastest and which are slowest?
SELECT dp.dp_id,
    dp. name,
    --calculate average distance: kilometers per hour
    ROUND (AVG(d. distance_km / ( (JULIANDAY(d.dropoff_time) -
    JULIANDAY(d. pickup_time)) * 24)), 3) AS avg_speed_km_per_hr,
    dp. vehicle_type
FROM deliveries d
JOIN delivery_partners dp ON d.dp_id = dp.dp_id
GROUP BY d.dp_id
--to sort the result view using ASC or DESC
ORDER BY avg_speed_km_per_hr DESC;

--Question 4: During which hours or days are cancellations most common? 
SELECT
    STRFTIME('%H', order_datetime) AS hour,
    COUNT(*) AS cancel_count
FROM orders
WHERE status = 'canceled'
GROUP BY hour
ORDER BY cancel_count DESC;

--Question 5: How does tip percentage vary across different order amounts?
WITH order_values AS (
    SELECT o. order_id,
        SUM (oi. quantity * oi.item_price_at_order) AS order_value, --Total order amount
        d. tip_amount                                               --Tip given for the order, can be NULL
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id --Join to get all items in the order
    LEFT JOIN deliveries d ON o.order_id = d.order_id --Left join to include tip info if delivery exists
    GROUP BY o.order_id, d.tip_amount --Group by order and tip amount to aggregate total order value
)
SELECT CASE
        WHEN order_value < 20 THEN '< $20' -- Price category
        WHEN order_value BETWEEN 20 AND 50 THEN '$20-$50'
        ELSE '> $50'
    END AS order_range,
    AVG( COALESCE (tip_amount, 0) / order_value * 100) AS avg_tip_percent --Avg tip % per category
FROM order_values
GROUP BY order_range --Group by defined order range buckets
ORDER BY order_range; --Sort results by order range categories

--2 WINDOW FUNCTION QUERIES
--Question 6: What is the sequence number of each customer’s orders over time?
SELECT o.customer_id,
    c. name,
    o. order_id,
    o.order_datetime,
    --window function to generate sequence number for customer orders
    ROW_NUMBER() OVER(
        PARTITION BY o.customer_id --for each customer
        ORDER BY o.order_datetime
    ) AS order_sequence
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.customer_id, order_sequence;

--Question 7: What is the cumulative spend of each customer across all their orders?
--this is the running cumulative spend per order
WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_datetime,
        SUM (oi.quantity * oi.item_price_at_order) + o.delivery_fee AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'delivered'
    GROUP BY o.order_id, o.customer_id, o.order_datetime
)
SELECT
    customer_id,
    order_id,
    order_datetime,
    order_total,
    SUM (order_total) OVER (
        PARTITION BY customer_id
        ORDER BY order_datetime
    ) AS cumulative_spend
FROM order_totals
ORDER BY customer_id, order_datetime;