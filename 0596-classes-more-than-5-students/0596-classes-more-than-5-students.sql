SELECT
    class
FROM
    Courses
GROUP BY
    class
HAVING
    COUNT(DISTINCT CONCAT(student, '-', class)) >= 5;