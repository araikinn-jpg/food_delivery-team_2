# Food Delivery Business Analytics Project
## Project Overview

This project aims to identify the core strengths and performance drivers of a food-delivery business.
We explored multiple analytical questions and built several models to understand:
- customer behavior
- operational efficiency
- order patterns and trends
- high-value cuisines and restaurants
- cancellation and delivery dynamics
The goal is to provide data-driven insights that can support strategic decision-making.

## Project Structure
notebooks/
├── 01_phase1_documentation.sql
├── 02_task3_machine_learning.ipynb
├── 03_task4_visualizations.ipynb

## Tools & Technologies Used
**SQLite** — database for storing and querying operational data
**Python** — main language for analysis and modeling
    -  Pandas (data manipulation)
    -  NumPy (numerical operations)
    -  Scikit-Learn (machine learning models)
    -  Matplotlib & Seaborn (visualizations)
**draw.io** — diagramming / workflow charts

## Dependencies
To run this project, install the following Python libraries:
```
pip install pandas numpy matplotlib seaborn scikit-learn
```
Or manually, the libraries used are:
```
sqlite3
pandas
numpy
matplotlib
seaborn
scikit-learn
```

## Key Analytical Questions:
1. Which cuisine types generate the highest average order value?
2. How often and how recently do customers place orders?
3. Which delivery partners are fastest and which are slowest?
4. During which hours or days are cancellations most common?
5.  How does tip percentage vary across different order amounts?


## Models & Methods
| Model                                      | Purpose                                                     |
| ------------------------------------------ | ----------------------------------------------------------- |
| **Linear Regression**                      | Establish baseline performance and interpret feature impact |
| **Polynomial Regression (2nd–4th degree)** | Capture non-linear trends in business operations            |
| **Random Forest**                          | Improve predictive accuracy and handle complex interactions |



## Results Summary
Found peak cancellation hours between 17:00–22:00

## How to Run the Project

Clone the repository:
```
git clone https://github.com/yourusername/repo-name.git
```
Install dependencies:
```
pip install -r requirements.txt
```
Open the notebook:
```
jupyter notebook notebooks/analysis.ipynb
```
(Optional) Run SQL queries on the SQLite database:
```
import sqlite3
conn = sqlite3.connect("food_delivery.db")
```


## Diagrams
All process maps and architecture diagrams can be found in the diagrams/ folder.
Designed using draw.io and python

## Contributors names and contact info
- Tsyr Rau Chen, () 
- Arailym Duisengali, (araikinn@bu.edu)
- Sheikh Noohery, (noohery@bu.edu)
- Lo Ying Wu, ()
- Kuan Rong Yang, (yangkr@bu.edu)

