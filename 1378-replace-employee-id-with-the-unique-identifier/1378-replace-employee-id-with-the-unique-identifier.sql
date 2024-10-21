SELECT
    EU.unique_id,
    E.name
FROM
    Employees as E
LEFT OUTER JOIN
    EmployeeUNI as EU
ON
    EU.id = E.id