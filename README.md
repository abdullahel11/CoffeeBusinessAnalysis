# Coffee Business Data Analysis Project

## Project Overview
This project analyses coffee sales, profit, and revenue data using SQL and Tableau for a Coffee business. It provides a comprehensive overview of coffee type performance, customer preferences, and product trends over three years. The analysis includes insights on revenue, profit margins, and sales trends across different dimensions.

## Tools Used
- **SQL**: Used for database creation, data queries, and analysis.
- **Tableau**: Used for creating interactive visualizations and dashboards to represent the findings.
- **Figma**: Used for wireframing and planning the dashboard layout and design.

## Dataset
The dataset used for this project consists of two main sections:
#### Orders: 
Contains transactional data, including details about customer purchases, coffee types, roast types, sizes, and sales information

  Key fields:
- **coffee_type_name:** The type of coffee purchased (e.g., Arabica, Robusta, Excelsa).
- **size:** Weight of the coffee purchased (e.g., 250g, 1kg).
- **roast_type_name:** The roast type of the coffee (e.g., Light, Medium, Dark).
- **sales:** Total revenue generated from the sale (stored as a string with a currency symbol).
- **quantity:** The number of units purchased per transaction.
- **customer_id:** Unique identifier for each customer.
- **product_id:** Identifier linking the product to the Products table.
- 
#### Products

Provides product-specific details, such as profit per unit and other product attributes
   Key fields:
- **product_id:** Unique identifier for each product (linked to the Orders table).
- **profit:** Profit generated per unit of a specific product sale.

- **Orders Dataset [OrdersFinal.csv](./OrdersFinal.csv)**: 
  
- **Product Dataset [ProductsFinal.csv](./ProductsFinal.csv)**: 

These datasets were used to investigate key business questions and generate actionable insights.

## Key Business Questions



####  1. What has been the overall profit and revenue of the company since launch?
####  2. What is the estimated profit and revenue for Q4 of 2022, based on historical trends and performance?
####  3. Which coffee types and roast types have beeen the most profitable and generated the highest revenue up until Q3 2022?
####  4. Which coffee sizes and roast types are the most popular among customers?
####  5. What has been the profit margin for each coffee type since launching in 2019?
####  6. Who are the most valuable customers based on revenue, profit, and quantity purchased?

## SQL and Tableau Analysis
This section documents the process of creating the database and importing the data. The orders and products tables were imported directly from Excel files into the database. During the import process, issues arose with the sales and order_date columns, as all fields were initially imported as TEXT. To resolve these issues:

The sales column was converted to a numerical format using the following code:
```sql
CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2))
```
The order_date column was reformatted and extracted into a usable date format using:
```sql
YEAR(STR_TO_DATE(o.order_date, '%d-%b-%Y'))
```
After resolving these datatype issues, the data was ready for analysis. This section includes the SQL queries used for analysis, descriptions of insights derived, visualizations, and the business questions addressed.

#### Database creation

To begin, the database was created in SQL.

SQL Query performed:

```sql
CREATE database cafe_project;
USE cafe_project;
```

The SQL and Tableau Analysis was split into 3 sections.

 - **Financial/Monetary Anlysis** - Focused on profit, revenue, and sales to assess overall financial performance, including trends over time
 - **Coffee-Type Analysis** - Examined the performance of different coffee types, identifying the most and least profitable and popular coffee selections, with insights into specific product-level metrics.
 - **Customer Activity Analysis** - Explored customer behavior, ranking customers by their purchases and financial contributions.

# Section-specific analysis

## Financial/Monetary Analysis 
The Financial Analysis section aimed to provide a comprehensive overview of the company's financial performance. The primary goals were to allow users to:

Track Key Financial Metrics: View the company's profit, revenue, units sold, and profit margins for each year.
Analyse Trends Over Time: Examine financial trends by breaking down performance into quarterly insights, enabling a deeper understanding of seasonal variations and long-term patterns.
Interactive filters in the dashboard allowed users to select specific years or view aggregated results across all years. This section also incorporated key performance indicator (KPI) boxes for a quick overview, accompanied by detailed line charts that visualized quarterly trends in revenue and profit with clear distinctions for each year.

These insights helped to identify the company’s most and least profitable periods, supporting data-driven decision-making for financial planning and strategy.

**SQL Query performed**:

###  KPI Sections: 

```sql
SELECT
    YEAR(STR_TO_DATE(o.order_date, '%d-%b-%Y')) AS year,
    SUM(o.quantity) AS total_quantity_sold, 
    SUM(CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2))) AS total_revenue,
    ROUND(SUM(o.quantity * p.profit), 2) AS total_profit,
    ROUND((ROUND(SUM(o.quantity * p.profit), 2)/SUM(CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2))))*100,2) AS profit_margin
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    year
ORDER BY
    year ASC;
```
###  Quarterly Analysis:

```sql
SELECT
    YEAR(STR_TO_DATE(o.order_date, '%d-%b-%Y')) AS year,    
    QUARTER(STR_TO_DATE(o.order_date, '%d-%b-%Y')) AS quarter, 
    SUM(o.quantity) AS total_quantity,                     
    SUM(CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2))) AS total_revenue, 
    ROUND(SUM(o.quantity * p.profit), 2) AS total_profit,   
    ROUND((ROUND(SUM(o.quantity * p.profit), 2)/SUM(CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2))))*100,2) AS profit_margin
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id
GROUP BY 
    YEAR(STR_TO_DATE(o.order_date, '%d-%b-%Y')),            
    QUARTER(STR_TO_DATE(o.order_date, '%d-%b-%Y'))          
ORDER BY 
    year ASC,                                               
    quarter ASC;
```


**Results and Insights:**

This query produced the following results:

- Total Revenue,Profit,Units Sold,Profit Margin for each selected year
- Profit and Revenue for each Quarter. 

### Tableau Visualisation for Financial Overview.

![Image 05-01-2025 at 11 27](https://github.com/user-attachments/assets/d1047c18-629f-4d53-b730-523f49bc4141)


#### Business Questions Answered from this Analysis:

**1. What has been the overall profit and revenue of the company since launch?**
By selecting "ALL" in the dashboard's filters, users can view the company's cumulative financial performance since its launch in 2019.

- **Overall Revenue:** $45,126
- **Overall Profit:** $4,520

**2. What is the estimated profit and revenue for Q4 of 2022, based on historical trends and performance?**

 This formula was used for the estimation:
- Average Q4 Growth Rate = Q4 Revenue or Profit − Q3 Revenue or Profit / Q3 Revenue or Profit * 100
  
  Q3 2022 Revenue was $1151, average Q3 to Q4 Revenue growth rate is 20.66% (using above formula)
  
  Estimated Q4 Revenue = $1151*1.2066 = **$1388.8**
  
  Same method was used to find estimated Q4 profit:
  
  Q3 2022 Profit was $114.4, aberage Q3 to Q4 Profit growth rate is 34.73% (using above formula)
  
  Estimated Q4 Profit = $114.4 * 1.3473 = **$154.13**

### Additional Insights:

**- Seasonal Profit and Revenue Trends:** There is consistently a noticeable spike in both profit and revenue during Q4 across the years. This trend suggests that Q4, possibly driven by seasonal factors such as increased demand during the holidays or special promotions, tends to be a high-performing quarter for the company. The data shows that, on average, Q4 outperforms other quarters in terms of revenue generation and profit margins, making it a key period to focus on for future business strategies and forecasting.


### Coffee-Type Analysis
The aim of this section was to provide an in-depth analysis of the company’s different coffee types, enabling the user to identify which coffee types generate the most revenue, profit, and sales. By exploring the data at the coffee type level, we can see how different types of coffee contribute to the overall performance and identify any trends or preferences that could inform business decisions

This section includes visualizations that display total revenue, profit, and sales for each coffee type, with the ability to filter by specific coffee types to understand their individual performance. Additionally, visual comparisons of the most profitable and most popular coffee types helps highlight top performers and provide insights into customer preferences

**SQL Query's  performed**:

```sql
SELECT
    o.coffee_type_mame AS coffee_type,  
    o.size AS WeightKG,
    SUM(o.quantity) AS total_quantity_sold,
    o.roast_type_name AS roast_type,
    o.product_id ,
    SUM(CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2))) AS total_revenue,
    ROUND(SUM(o.quantity * p.profit), 2) AS total_profit,
    ROUND(ROUND(SUM(o.quantity * p.profit), 2)/SUM(CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2)))*100,2) AS profit_margin
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    coffee_type,
    o.roast_type_name,
    o.size,
    o.product_id
ORDER BY 
    total_profit DESC;
```
**Results and Insights:**

These query's  produced the following results:

- **Revenue and Profit Insights:** This query calculates the total revenue, total profit, and profit margin for each coffee type, roast type, and product size, providing insights into how each coffee product performs financially.
- **Quantity and Product Breakdown:** It also tracks the total quantity sold for each coffee type and roast type, highlighting the most popular products based on sales volume.
- **Profitability Analysis:** By calculating the profit margin, the query enables the identification of coffee types with the highest and lowest profitability, supporting informed decision-making regarding product offerings.


### Tableau Visualisation for Coffee-Type Analysis

<img width="1251" alt="Screenshot 2025-01-05 at 12 47 15" src="https://github.com/user-attachments/assets/8e8a03f6-250a-419e-8598-789492d78dae" />


#### Business Questions Answered from this Analysis:

**3. Which coffee types and roast types have beeen the most profitable and generated the highest revenue up until Q3 2022?**

- **Arabica** had a total revenue of **$11,769** and a total profit of **$1,059**
- **Excelsa** had a total revenue of **$12,307** and a total profit of **$1,354**
- **Liberica** had a total revenue of **$12,054** and a total profit of **$1,567**
- **Robusta** had a total revenue of **$9,006** and a total profit of **$540.3**

**Highest revenue generating roast types are :**

<img src="https://github.com/user-attachments/assets/2a6f8581-f9ca-48f5-969c-f106f4777e5c" width="500"/>

**Highest Profit generating roast types are:**

<img src="https://github.com/user-attachments/assets/740e052a-8a2e-4838-a313-4f287fea1780" width="500"/>

We can see that:
-  Product ID **A-L-2.5** (Arabica,Light,2.5kg) generated the most revenue.
-  Product ID **L-D-2.5** (Liberica,Dark,2.5kg) generated the most profit.


**4. Which coffee sizes and roast types are the most popular among customers?**

This question was answered and visualised using the bar charts that display the most and least popular Product ID, in terms of Units Sold.

<img src="https://github.com/user-attachments/assets/3b41804c-1764-4e6a-a1ba-72f869a70108" width="500"/>

We can see that:
- Products ID **R-L-0.2** (Robusta,Light,0.2kg) sold the most at 100 units, possibly because its one of the cheapest Coffee to purchase




**5. What has been the profit margin for each coffee type since launching in 2019?**

- **Arabica** profit margin is **9%**
- **Excelsa** profit margin is **11%**
- **Liberica** profit margin is **13%**
- **Robusta** profit margin is **6%**


### Customer Activity

The Customer Activity section focuses on tracking and analyzing customer-specific performance. This includes key metrics such as the total profit, revenue, and quantity purchased by each customer over time. By organizing the data to show individual customer contributions, this section enables the identification of high-performing customers and the overall financial impact of each customer on the company’s revenue and profitability.

**SQL Query's  performed**:

```sql
SELECT
    o.customer_id,
    o.customer_name, 
    SUM(o.quantity) AS total_quantity,
    SUM(CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2))) AS total_revenue,
    ROUND(SUM(o.quantity * p.profit), 2) AS total_profit
FROM orders o
INNER JOIN products p 
    ON o.product_id = p.product_id
GROUP BY o.customer_id, o.customer_name 
ORDER BY total_revenue DESC;

SELECT COUNT(DISTINCT customer_id)
FROM orders;

WITH RankedCustomers AS (
    SELECT
        o.customer_id,
        o.customer_name, 
        SUM(o.quantity) AS total_quantity,
        SUM(CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2))) AS total_revenue,
        ROUND(SUM(o.quantity * p.profit), 2) AS total_profit
    FROM orders o
    INNER JOIN products p 
        ON o.product_id = p.product_id
    GROUP BY o.customer_id, o.customer_name 
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS Number, -- Assigns a rank number to each customer
    customer_id,
    customer_name,
    total_quantity,
    total_revenue,
    total_profit
FROM RankedCustomers
ORDER BY total_revenue DESC;
```
**Results and Insights:**

The queries for this section produced the following results:

- **Customer-level metrics:** The query calculates total quantity purchased, total revenue, and total profit generated by each customer.
- **Profit and revenue breakdown:** It provides a detailed breakdown of how much revenue and profit each customer has contributed over time.
- **Ranking customers:** Customers are ranked based on total revenue, allowing for easy identification of high-revenue customers.
- **Ranking order:** The results are sorted in descending order by total revenue, highlighting the most profitable customers at the top.

### Tableau Visualisation for Risk Tolerance and Financial Behaviour.
<img width="1250" alt="Screenshot 2025-01-05 at 13 55 02" src="https://github.com/user-attachments/assets/d0d0ed6e-a930-479c-a904-df483ab353d5" />


#### Business Questions Answered from this Analysis:

**6. Who are the most valuable customers based on revenue, profit, and quantity purchased?**

Navigating through this dashboard, we can easily identify which customers purchased the most, generated the highest revenue, and contributed the most profit. The customer activity section provides a clear ranking of customers based on these metrics.

For example: 

We can see that: 

- Customer 'Allis Willmore' ranked first as they generated the most revenue for the company.
- Using the **Quantity Purchased** filter, Customer 'Terri Farra' purchased the most units.


### Conclusion

The SQL and Tableau analysis provided a comprehensive overview of the company's financial performance, coffee product trends, and customer activity. By extracting and analyzing key data points from the orders and products tables, the analysis allowed us to:

- **Financial Insights**: We were able to evaluate the overall revenue, profit, and profit margins over time, with a detailed breakdown by year and quarter. This revealed important seasonal trends, such as the consistent revenue and profit spikes in Q4, and helped estimate expected profit and revenue for future quarters.

- **Coffee-Type Performance:** The analysis provided valuable insights into which coffee types were the most profitable and popular, as well as how revenue and profit varied across different product sizes and roast types. This information enabled better decision-making regarding inventory management and marketing strategies for specific coffee types.
  
- **Customer Activity:** The customer activity analysis identified the most valuable customers based on their total revenue, profit, and purchase quantity. By segmenting the data, we were able to identify high-value customers and tailor business strategies to retain and engage them.
  
Overall, this analysis offered a clear and data-driven understanding of the company's performance across financial, product, and customer dimensions,

###   Resources

**Interactive Tableau Dashboard** - (https://public.tableau.com/views/Book1_17268354073130/1STPAGE?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link))

**Full SQL code** - [CoffeeBusinessFULLCODE.sql](./CoffeeBusinessFULLCODE.sql)
