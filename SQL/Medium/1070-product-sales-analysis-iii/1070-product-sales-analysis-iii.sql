WITH FirstYear AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY product_id ORDER BY year) AS year_rank 
    FROM
        Sales
)
SELECT
    product_id,
    year AS first_year,
    quantity,
    price
FROM
    FirstYear
WHERE
    year_rank = 1