/*
	====================================================================================================
	Product Report
	====================================================================================================
	Purpose:
		- This report consolidates key product metrics and behaviors.

	Highlights:
		1. Gathers essential fields such as product name, category, subcategory, and cost.
		2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
		3. Aggregates product-level metrics:
		   - total orders
		   - total sales
		   - total quantity sold
		   - total customers (unique)
		   - lifespan (in months)
		4. Calculates valuable KPIs:
		   - recency (months since last sale)
		   - average order revenue
		   - average monthly revenue
	====================================================================================================

	====================================================================================================
	Create Report: gold.report_products
	====================================================================================================
*/

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS 
WITH base_query AS (
/*
	----------------------------------------------------------------------------------------------------
	1 - Base Query: Retrieves core columns from tables
	----------------------------------------------------------------------------------------------------
*/
	SELECT 
		s.order_number,
		s.product_key,
		s.customer_key,
		s.order_date,
		s.sales_amount,
		s.quantity,
		s.price,
		p.product_number,
		p.product_name,
		p.category_id,
		p.category,
		p.subcategory,
		p.maintenance,
		p.cost,
		p.product_line
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON p.product_key = s.product_key
	WHERE order_date IS NOT NULL
),
/*
	----------------------------------------------------------------------------------------------------
	2 - Product Aggregation: Retrieves core columns from tables
	----------------------------------------------------------------------------------------------------
*/
product_aggregation AS (
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	sales_amount,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(sales_amount) AS total_sales,
	SUM(sales_amount) - SUM(cost) AS revenue,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS average_selling_price 
FROM base_query
GROUP BY product_key,
	product_name,
	category,
	subcategory,
	cost,
	sales_amount
)
/*
	----------------------------------------------------------------------------------------------------
	3 - Final Query: Combines all product results into one output
	----------------------------------------------------------------------------------------------------
*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	sales_amount,
	cost,
	average_selling_price,
	total_quantity,
	total_orders,
	total_sales,
	revenue,
	lifespan,
	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency,
	CASE WHEN total_orders = 0 THEN 0
	ELSE 	revenue / total_orders 
	END AS average_order_revenue,
	CASE WHEN lifespan = 0 THEN 0
	ELSE 	revenue / lifespan 
	END AS average_monthly_revenue,
	CASE 
		WHEN revenue >= 50000 THEN 'High-Performers'
		WHEN revenue between 25000 and 50000 THEN 'Mid-Range'
		ELSE 'Low-Performers'
	END AS product_segment
FROM product_aggregation
