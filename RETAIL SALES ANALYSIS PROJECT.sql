-- Retail Sales Analysis Project --

CREATE DATABASE Sales_Analysis;

USE Sales_Analysis;

-- Create Table for ---

CREATE TABLE Retail_Sales
	(
    transactions_id INT PRIMARY KEY,
	sale_date DATE,	
    sale_time TIME,
    customer_id	INT,
    gender VARCHAR (10),
    age	 INT,
    category VARCHAR (15),	
    quantiy	INT,
    price_per_unit	FLOAT,
    cogs FLOAT,
    total_sale FLOAT
	);
    
SELECT * FROM Retail_Sales;

SELECT 
	COUNT(*)
FROM Retail_sales;

--- Data Cleaning-

SELECT * FROM  Retail_sales
WHERE
	transactions_id IS NULL
    OR 
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR 
    customer_id IS NULL
    OR 
    gender IS NULL
    OR 
    age IS NULL
    OR 
    category IS NULL
    OR
    quantiy IS NULL 
    OR 
    price_per_unit IS NULL
    OR 
    Cogs IS NULL
    OR 
    total_sale IS NULL;
    
    -- Data Exploration--
    
    -- How many sales we have?
    SELECT
		COUNT(*) AS total_sales
	FROM retail_sales;

-- How many unique customer we have?

SELECT 
	COUNT(DISTINCT customer_id) 
    as total_sales
FROM Retail_sales;

-- Data Analysis and business Key Problems & answers.

-- Q.1 Write a SQL query to retrive all columns for sales made on '2022-11-05.

SELECT *
FROM Retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrive all transactions where the category is 'Clothing' and the quantiy sold is more than 4 in the month of  Nov-2022. 

SELECT
	category, 
    SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing'
	AND month(sale_date) = 11 and year(sale_date) =2022
	-- (sale_date,'YYYY-MM') = '2022-11'
GROUP BY category;

-- Q.3 Write a SQL query to calculate the total sales (total-sale) for each category.

SELECT
	category,
	SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM Retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
	ROUND(AVG(age), 2) AS Avg_age
FROM Retail_sales	
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM Retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transtaction (transaction_id) made by each gender in each category. 

SELECT 
	category,
    gender,
    COUNT(customer_id) AS total_trans
FROM retail_sales
GROUP BY
	category,
    gender;
-- ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year. 

SELECT
	YEAR,
    MONTH,
    avg_sale
FROM 
(
SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month, 
		AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANKOF
FROM Retail_sales
GROUP BY 1, 2
) AS t1
WHERE RANKOF = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
	customer_id,
    SUM(total_sale) AS total_sales
FROM Retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a Sql query to find the number of  unique customers who purchased items from each category.

SELECT 
	category,
    COUNT(DISTINCT customer_id ) AS cnt_unique_cs
FROM REtail_sales
GROUP BY category; 

-- Q.10 Write a SQL query to create each shift and number of orders (example MOrning <=12, Afternoon is 12 & 17, Evening >17).

WITH hourly_sale
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END as shift
FROM Retail_sales
)
SELECT 
	shift,
    count(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

--- END OF PROJECT  