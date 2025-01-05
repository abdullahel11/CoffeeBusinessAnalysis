# Coffee Business Data Analysis Project

## Project Overview
This project analyses coffee sales, profit, and revenue data using SQL and Tableau for a Coffee business. It provides a comprehensive overview of coffee type performance, customer preferences, and product trends over three years. The analysis includes insights on revenue, profit margins, and sales trends across different dimensions.

## Tools Used
- **SQL**: Used for database creation, data queries, and analysis.
- **Excel**: Used for data cleaning, initial data manipulation, and working with raw datasets.
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
**For regional analysis**
```sql
SELECT -- Rejection/Approval Rates per region (4)
    region,
    COUNT(CASE WHEN loan_status = 'rejected' THEN 1 END) AS rejected_count,
    ROUND((COUNT(CASE WHEN loan_status = 'rejected' THEN 1 END) * 100.0 / COUNT(Customer_Demographics.cust_id)), 2) AS rejected_rate,
    COUNT(CASE WHEN loan_status = 'approved' THEN 1 END) AS approved_count,
    ROUND((COUNT(CASE WHEN loan_status = 'approved' THEN 1 END) * 100.0 / COUNT(Customer_Demographics.cust_id)), 2) AS approved_rate,
    COUNT(Customer_Demographics.cust_id) AS total_customers
FROM Customer_Demographics
JOIN Loan_Details ON Customer_Demographics.cust_id = Loan_Details.cust_id
GROUP BY region
ORDER BY rejected_rate DESC;
```
**Results and Insights:**

These query's  produced the following results:

- Count of loan application outcomes (approved, rejected) for each loan status.
- The number of unemployed customers for each loan outcome (approved, rejected).
- Average loan amount and interest rate for each loan decision (approved, rejected).
- Rejection and approval rates for loan applications by region.

### Tableau Visualisation for Loan Performance
![Image 23-12-2024 at 13 08](https://github.com/user-attachments/assets/da201aa7-5086-44c9-9599-2da5a27f011d)

#### Business Questions Answered from this Analysis:

**3. What are the approval and rejection rates for loan applications across different continents?**

This question was answered and visualized using a bar chart that shows the rejection and approval rates for loan applications by region. The visualization allows for a clear comparison of loan application outcomes across different geographic regions. For example, the region with the highest approval rate is North America, with an approval rate of 48.32%, while customers from Asia had the highest rejection rate, at 32.12%.

**4. What are the average loan sizes and interest rates for approved, rejected, and pending loan applications**

This question was answered and visualized using two bar charts that display the average loan amount and average interest rates for each loan outcome (approved, rejected, and pending).The first bar chart illustrates the average loan amount corresponding to each loan outcome, while the second bar chart shows the average interest rate for each loan decision.

**Approved Applications** had an average Loan Amount of **$10,951** and an average interest rate of **6.5%**

**Pending Applications** had an average Loan Amount of **$10,987** and an average interest rate of **9.2%**

**Rejected Applications** had an average Loan Amount of **$11,286** and an average interest rate of **9.1%**

**5. To what extent does unemployment affect the chances of loan approval?**

This question was answered and visualised using a bar chart that shows the proportion of unemployed customers for each loan outcome (approved, rejected, and pending).

The analysis revealed the following insights:

- 25% of the customers whose loan applications were approved were unemployed.
- 22.2% of customers with pending loan applications were unemployed.
- 29% of customers with rejected loan applications were unemployed.

From these findings, it is evident that unemployment has a slight influence on loan approval, as a higher percentage of unemployed individuals have had their loan applications rejected. The rate of unemployment among approved applicants is relatively lower, while pending applications have a slightly lower unemployment rate compared to rejected ones.

### Additional Insights:
Despite the highest unemployment rate among rejected applicants (29%), the fact that over 70% of rejected applicants were employed indicates that unemployment alone is not a decisive factor in the rejection of loan applications.

### Risk Tolerance and Finanical Behaviour 

This section delves into customers’ financial behaviours, focusing on their risk tolerance levels and how this influences their investment activities. Customers were segmented into different risk tolerance groups Low, Medium, and High Risk, allowing for a detailed analysis of how their risk preferences relate to their investment behaviours.Additionally,for high-net-worth individuals, account activity is further analysed to reveal trends in their financial behaviour. Lastly, a financial activity section provides a closer look at individual customer activity through bar charts.

**SQL Query's  performed**:

```sql
SELECT -- Average Investment per risk category (5)
    Customer_Demographics.risk_tolerance,
    ROUND(AVG(Account_Activity.account_investments),2) AS avg_investments,
    COUNT(Customer_Demographics.cust_id) AS total_customers
FROM Customer_Demographics
JOIN Account_Activity ON Customer_Demographics.cust_id = Account_Activity.cust_id
GROUP BY Customer_Demographics.risk_tolerance
ORDER BY avg_investments DESC;
```

**Account Activity for all individual Customers**

```sql
SELECT 
    Account_Activity.cust_id,
    ROUND(account_balance, 2) AS account_balance,
    ROUND(account_deposits, 2) AS account_deposits,
    ROUND(account_withdrawals, 2) AS account_withdrawals,
    ROUND(account_deposits - account_withdrawals, 2) AS net_flow,
    Customer_Demographics.risk_tolerance
FROM Account_Activity
JOIN Customer_Demographics ON Account_Activity.cust_id = Customer_Demographics.cust_id
ORDER BY account_balance;
```

**Insights into financial behaviour for High Net-worth Customers**
```sql
SELECT -- Account Activity Analysis for High Income earners (3)
    cust_id,
    ROUND(account_balance, 2) AS account_balance,
    ROUND(account_deposits, 2) AS account_deposits,
    ROUND(account_withdrawals, 2) AS account_withdrawals,
    ROUND(account_deposits - account_withdrawals, 2) AS net_flow
FROM Account_Activity
WHERE account_balance >= 70000
ORDER BY net_flow DESC;
```
**Results and Insights:**

The queries for this section produced the following results:

- **Count of Customers:** The number of customers categorized into each risk tolerance group (e.g., Low, Medium, High Risk).
- **Average Investment Amount:** The average amount invested by customers in each risk tolerance group.
- **Account Activity for High Net Worth Customers:** A breakdown of financial activity (e.g., deposits, withdrawals, transfers) specific to high-net-worth individuals.
- **Individual Account Activity:** The ability to explore account activity at the individual customer level through an interactive visual.

### Tableau Visualisation for Risk Tolerance and Financial Behaviour.
![Image 23-12-2024 at 16 26](https://github.com/user-attachments/assets/8078dff2-1c50-41d4-bafe-f161be6781ff)

#### Business Questions Answered from this Analysis:

**6. How does the average investment vary across different risk tolerance groups (e.g., low, medium, high)?**

The results aligned with expectations:

**- Customers with high risk tolerance had the highest average investment at $2,571.**

**- Customers with medium risk tolerance followed with an average investment of $1,676.**

**- Customers with low risk tolerance had the lowest average investment at $1,416.**

This trend highlights a clear relationship between risk tolerance and investment behavior, with higher risk tolerance correlating to larger investment amounts.

### Additional Insights:

**- Potential Growth Opportunity for Low-Risk Customers:** 

While low-risk customers represent a large segment of the customer base, their average investment is significantly lower. Encouraging this group to diversify their portfolios with safer investment options could unlock new revenue streams for the bank.

**- Importance of Monitoring High-Networth Customer Activity**

Observing the activity of high-net-worth individuals (HNWIs) is crucial as they contribute significantly to a bank's revenue while representing a small customer base. Monitoring their deposit and withdrawal trends helps manage liquidity, detect risks, and identify cross-selling opportunities. Insights into their financial behavior enable the bank to offer tailored services, ensuring retention and enhancing customer satisfaction. This strategic focus strengthens the bank's relationship with these valuable clients


### Conclusion

This project demonstrated how SQL and Tableau can be combined to extract, analyze, and visualize key insights from a financial dataset. Through segmentation, performance analysis, and behavioral patterns, actionable insights were uncovered to support decision-making in areas such as loan approvals, customer risk tolerance, and high-net-worth account activity

###   Resources

**Interactive Tableau Dashboard** - (https://public.tableau.com/views/Bank_17339341988090/CustomerDemo?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

**Full SQL code** - [bankSQLcode.sql](./bankSQLcode.sql)
