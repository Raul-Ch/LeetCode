WITH FirstOrders AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS FirstOrder
    FROM
        Delivery
)
SELECT 
    ROUND(SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS immediate_percentage
FROM 
    FirstOrders
WHERE 
    FirstOrder = 1;
