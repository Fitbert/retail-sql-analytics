/** total revenue by product category */
SELECT 
    p.product_name,
    SUM(oi.quantity * oi.unit_price_at_sale) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

/** customers signed up in the last  6 months */
select customer_id, first_name, last_name, signup_date
from customers
where signup_date >= current_date - interval '6 months'
order by signup_date desc;

/** order count and status breakdown by customer */
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status;

/** top 10 customers by total spending */
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name, SUM(oi.quantity * oi.unit_price_at_sale) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, customer_name
ORDER BY total_spending DESC
LIMIT 10;

/** revenue by product category by month */
SELECT 
DATE_TRUNC('month', o.order_date) AS month,
    p.category,
    SUM(oi.quantity * oi.unit_price_at_sale) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY month, p.category
ORDER BY month, revenue DESC;


/**rank products within each category by revenue */
SELECT 
p.category,
    p.product_name,
    SUM(oi.quantity * oi.unit_price_at_sale) AS revenue,
    RANK() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.unit_price_at_sale) DESC) AS rank_in_category
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category, p.product_name
ORDER BY p.category, rank_in_category;

/**running total of revenue over time */
SELECT
    order_date,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY order_date) AS running_total_revenue
FROM (
    SELECT 
        o.order_date,
        SUM(oi.quantity * oi.unit_price_at_sale) AS daily_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_date
) daily
ORDER BY order_date;

/**customer segments repeat vs one-time buyers */

WITH customer_order_counts AS (
    SELECT 
        customer_id,
         COUNT(order_id) AS num_orders
    FROM orders
    WHERE status = 'Completed'
    GROUP BY customer_id
)
SELECT
CASE 
        WHEN num_orders = 1 THEN 'One-time Buyer'
        WHEN num_orders BETWEEN 2 AND 4 THEN 'Repeat Buyer'
        ELSE 'Loyal Buyer'
    END AS segment,
    COUNT(*) AS num_customers
    FROM customer_order
    GROUP BY segment;

    /** Profit margin by category */
SELECT
p.category,
SUM(oi.quantity * oi.unit_price_at_sale) AS revenue,
SUM(oi.quantity * p.cost) AS total_cost,
SUM(oi.quantity * oi.unit_price_at_sale) - SUM(oi.quantity * p.cost) AS profit,
ROUND(
100.0 * (SUM(oi.quantity * oi.unit_price_at_sale) - SUM(oi.quantity * p.cost)) / NULLIF(SUM(oi.quantity * oi.unit_price_at_sale), 0), 2) AS profit_margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY profit_margin_pct DESC;

