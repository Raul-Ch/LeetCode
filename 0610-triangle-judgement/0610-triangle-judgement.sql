---The rule for Triangle line is: Lenth of one line is less than sum of lenth 2 others lines.
SELECT
    *,
    CASE
        WHEN (x + y > z AND x + z > y AND y + z > x) THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM
    Triangle