WITH SingleNumbers AS
(
    SELECT num FROM MyNumbers GROUP BY num HAVING COUNT(num) = 1
)
SELECT 
    COALESCE(MAX(num), NULL) AS num
FROM
    SingleNumbers