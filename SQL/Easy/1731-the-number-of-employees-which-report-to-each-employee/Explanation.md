# https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/solutions/6045753/beats-80-easy-explanations-and-solutions-from-a-fellow-newbi/

# 🕵️‍♂️ Problem Overview 
The task is to identify managers, count their direct reports, and calculate the average age of those reports—rounded to the nearest integer. Managers are defined as employees who have at least one person reporting to them. The result should be ordered by the manager’s employee_id.


#  🔍 Problem Breakdown 
- Manager: An employee who has at least one direct report (i.e., reports_to is not null).
- Output: For each manager, return:
    - Their employee_id and name.
    - The number of employees reporting to them.
    - The average age of those reports, rounded to the nearest integer.

---

# 💡 Intuition 
To solve this, the first step is to **isolate employees who have someone reporting to them**. This will give us a subset of employees who are managers. 
**Then, we join this CTE with the employees table again to count how many employees report to each manager**, and also calculate the average age of these employees.

# # 🛠️ SQL Approach 🧠
1. **CTE to Get Employees Who Have Reports:** The first step is creating a CTE (EmployeesWithManager) that identifies all employees who have someone reporting to them. This is done by filtering for employees where reports_to is not null.

2. **Join Employees to Managers:** To get the number of direct reports and their average age, we join the original employees table with the EmployeesWithManager CTE on employee_id and reports_to. The join ensures that we are only looking at employees who report to a manager.

3. **Aggregations:**

    - Count of Direct Reports: We count how many employees are reporting to each manager using COUNT(EWM.reports_to).
    - Average Age: The average age is calculated by averaging the age of the employees who report to a manager. We multiply EWM.age * 1.0 to ensure that the result is treated as a floating-point number for accurate division (avoiding integer division), and then use ROUND() to round the result to the nearest integer.

4. **Grouping**: We group by E.employee_id and E.name to aggregate the number of reports and the average age by manager.

5. **Ordering**: Finally, we order the result by employee_id to ensure the results are sorted by manager.
---
# ⭐️ The All-Star SQL Code ⭐️
```mssql []
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
```

# 👩‍💻 Code Explanation
1. **CTE (EmployeesWithManager):** This part of the query creates a temporary result set containing employees who have at least one person reporting to them (reports_to IS NOT NULL).

2. **Main Query:**

    - **Join**: We join the employees table (E) with the EmployeesWithManager CTE (EWM). The **join condition E.employee_id = EWM.reports_to ensures we match each manager (whose employee_id appears in the reports_to column of others).**
    - COUNT: COUNT(EWM.reports_to) counts how many direct reports each manager has.
    - **AVG and ROUND: AVG(EWM.age * 1.0) computes the average age of the reports, with * 1.0 ensuring the result is treated as a float.**
    - The ROUND() function rounds this average to the nearest integer.
3. **GROUP BY**: We group the results by E.employee_id and E.name to ensure we get one row per manager.

4. **ORDER BY:** Finally, we sort the result by employee_id as required by the problem.

---
# 💡 Additional Tips
**Handling NULL Values**: In SQL, NULL values are ignored by most aggregation functions (like COUNT and AVG), which is why the WHERE reports_to IS NOT NULL filter is necessary in the CTE to avoid counting employees who don't report to anyone.

**JOIN**: The JOIN here is crucial because we want to link each manager (E.employee_id) to the employees they manage. We join on E.employee_id = EWM.reports_to because reports_to refers to the employee_id of the manager. This ensures we only get employees reporting to a manager, not just all employees.

**Floating Point Arithmetic:** The use of * 1.0 before AVG() ensures that the division involved in averaging does not suffer from integer division problems (which could truncate decimal values if left untreated).

---
# ⚙️ Deep Dive: Key SQL Functions
**COUNT()**: Counts the number of non-null values in a specified column. In this case, it counts the number of employees reporting to each manager.

**AVG()**: Calculates the average value of a numeric column. Here, it's used to calculate the average age of employees reporting to a manager.

**ROUND()**: Rounds a numeric expression to the nearest integer or to a specified number of decimal places. In this case, we use it to round the average age to the nearest integer.

![image.png](https://assets.leetcode.com/users/images/737d03d7-a493-4ca8-811c-50866b449054_1730844587.2710903.png)
