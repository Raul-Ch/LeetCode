WITH EmployeesWithManager AS(
    SELECT 
        *
    FROM 
        employees
    WHERE 
        reports_to IS NOT NULL
)
SELECT
    E.employee_id,
    E.name,
    COUNT(EWM.reports_to) AS reports_count,
    ROUND(AVG(EWM.age*1.0), 0) AS average_age
FROM Employees as E
JOIN
    EmployeesWithManager AS EWM
ON
    E.employee_id = EWM.reports_to
GROUP BY
    E.employee_id, E.name
ORDER BY
    E.employee_id