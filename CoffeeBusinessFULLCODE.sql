CREATE database cafe_project;
USE cafe_project;
    

    
-- FINANCIAL OVERVIEW (YEARLY)

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


-- FINACIAL OVERVIEW (QUARTERLY)

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


-- COFFEE-TYPE ANALYSIS
    
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
    
    


-- CUSTOMER ACTIVITY

SELECT
    o.customer_id,
    o.customer_name, -- Accessed directly from the orders table
    SUM(o.quantity) AS total_quantity,
    SUM(CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2))) AS total_revenue,
    ROUND(SUM(o.quantity * p.profit), 2) AS total_profit
FROM orders o
INNER JOIN products p 
    ON o.product_id = p.product_id
GROUP BY o.customer_id, o.customer_name -- Ensure both customer_id and customer_name are included in GROUP BY
ORDER BY total_revenue DESC;

SELECT COUNT(DISTINCT customer_id)
FROM orders;

WITH RankedCustomers AS (
    SELECT
        o.customer_id,
        o.customer_name, -- Accessed directly from the orders table
        SUM(o.quantity) AS total_quantity,
        SUM(CAST(REPLACE(o.sales, '$', '') AS DECIMAL(10, 2))) AS total_revenue,
        ROUND(SUM(o.quantity * p.profit), 2) AS total_profit
    FROM orders o
    INNER JOIN products p 
        ON o.product_id = p.product_id
    GROUP BY o.customer_id, o.customer_name -- Ensure both customer_id and customer_name are included in GROUP BY
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






    



    






    



























































































