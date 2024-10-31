SELECT 
    query_name,
    ROUND(AVG((rating * 1.0 / position)), 2) AS quality,
    ROUND((COUNT(CASE WHEN rating < 3 THEN query_name END) * 1.0 / COUNT(query_name)) * 100, 2) AS poor_query_percentage
FROM
    Queries
WHERE
    query_name IS NOT NULL
GROUP BY
    query_name