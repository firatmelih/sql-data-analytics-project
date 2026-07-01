/*
	====================================================================================================
	Customer Report
	====================================================================================================
	Purpose:
		- This report consolidates key customer metrics and behaviors.

	Highlights:
		1. Gathers essential fields such as name, age, and spendings.
		2. Segments customers by spends and lifespan to identify VIP, Regular, New and age groups
		3. Aggregates customer-level metrics:
		   - total orders
		   - total spend
		   - total quantity purchased
		   - total products
		   - lifespan (in months)
		4. Calculates valuable KPIs:
		   - recency (months since last sale)
		   - average order value
		   - average monthly spend
	====================================================================================================

	====================================================================================================
	Create Report: gold.report_customers
	====================================================================================================
*/

IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS 
WITH base_query AS (
/*
	----------------------------------------------------------------------------------------------------
	1 - Base Query: Retrieves core columns from tables
	----------------------------------------------------------------------------------------------------
*/
SELECT 
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	s.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
	DATEDIFF(year, c.birthdate, GETDATE()) AS age
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL),
/*
	----------------------------------------------------------------------------------------------------
	2 - Customer Aggregation: Summarizes key metrics at the customer level
	----------------------------------------------------------------------------------------------------
*/
customer_aggregation AS (
SELECT
	customer_key,
	customer_number,
	customer_name, 
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_spend,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month,MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY customer_key,
	customer_number,
	customer_name, 
	age
)
/*
	----------------------------------------------------------------------------------------------------
	3 - Final Query: Combines all product results into one output
	----------------------------------------------------------------------------------------------------
*/
SELECT 
	customer_key,
	customer_number,
	customer_name, 
	age,
		CASE 
			WHEN age < 20 THEN 'Under 20'
			WHEN age between 20 and 29 THEN '20-29'
			WHEN age between 30 and 39 THEN '30-39'
			WHEN age between 40 and 49 THEN '40-49'
			ELSE '50 and above'
		END AS age_group,
		CASE
			WHEN lifespan >= 12 AND total_spend > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_spend <= 5000 THEN 'Regular'
			ELSE 'New'
		END AS customer_segment,
	total_orders,
	total_spend,
	total_quantity,
	lifespan,
	total_products,
	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency,
	CASE WHEN total_orders = 0 THEN 0
	ELSE total_spend / total_orders
	END AS average_spend,
	CASE WHEN lifespan = 0 THEN 0
	ELSE total_spend / lifespan
	END AS average_monthly_spend
FROM customer_aggregation
