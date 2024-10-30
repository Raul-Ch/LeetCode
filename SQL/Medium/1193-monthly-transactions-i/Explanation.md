# https://leetcode.com/problems/monthly-transactions-i/solutions/5987578/easy-explanations-and-solutions-from-a-fellow-newbi/

​# Intuition
Mastering Your Transaction Insights! 📊 The goal here is to analyze transactions by month and country, allowing us to derive key metrics that help us understand transaction dynamics.

---

# Approach
Here’s the Game Plan 📝

1. **Year and Month Extraction:** We will format the transaction date to yyyy-MM to get a clear view of each month’s performance.
2. **Country Count:** Each country's transactions will be tallied up so we can see where our activity is concentrated.
3. **Total Transactions Count:** Using COUNT(*), we will capture the total number of transactions for each combination of month and country.
4. **Approved Transactions Count:** With a selective COUNT, we'll identify how many transactions were approved, giving us insight into our successful transactions.
5. **Total Transaction Amount:** We will sum up the amounts for all transactions, providing a clear financial picture.
6. **Approved Transactions Amount:** We’ll use a conditional SUM to find the total amount of approved transactions, giving us a look at our successful financial activity.

---

# The All-Star SQL Code ⭐️
Here’s the SQL query that makes it all happen:
```mssql []
SELECT 
  FORMAT(trans_date, 'yyyy-MM') AS month,
  country,
  COUNT(*) as trans_count,
  COUNT(CASE WHEN state = 'approved' THEN 1 END) AS approved_count,
  SUM(amount) AS trans_total_amount,
  SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM
    transactions
GROUP BY
    FORMAT(trans_date, 'yyyy-MM'), country

```
# SQL Query Breakdown 🛠️
- **FORMAT(trans_date, 'yyyy-MM') AS month:**
**Step 1:** This formats the trans_date to a year-month format (yyyy-MM), making it easy to group and analyze transactions by month.
**Step 2:** It creates a readable month label, which is essential for our analysis.

- **country**:
This simply pulls in the country from our transactions, allowing us to differentiate performance across various regions.

- **COUNT(*) AS trans_count:**
**Step 1:** This counts all transactions within each month and country, giving us a raw count of activity.
**Step 2:** This is a straightforward approach to measure total transaction volume, helping us gauge overall engagement.

- **COUNT(CASE WHEN state = 'approved' THEN 1 END) AS approved_count:**
**Step 1:** This utilizes a CASE statement to count only those transactions that are approved.
**Step 2:** This allows us to focus specifically on successful transactions, providing clarity on performance.

- **SUM(amount) AS trans_total_amount:**
**Step 1:** This sums up the total amount of all transactions for each month and country.
**Step 2:** This gives a clear view of financial activity and is crucial for understanding revenue.

- **SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount:**
**Step 1**: This conditionally sums the amounts of transactions that are approved, allowing us to focus on successful financial engagements.
**Step 2:** Using ELSE 0 ensures that non-approved transactions do not affect our sum, maintaining accuracy in our total.

# The GROUP BY Clause: Pulling It All Together (why not month?)🎯
The GROUP BY clause is crucial in this query. By grouping by FORMAT(trans_date, 'yyyy-MM') and country, we:

Aggregate all relevant transaction data, allowing us to compute counts and sums for each unique combination of month and country.

Summarize insights, revealing patterns and performance metrics that are specific to each month and country combination, rather than treating the entire dataset as a single entity.

# **However, we can’t directly GROUP BY the alias month, since SQL Server doesn't recognize aliases created in the SELECT clause within the same query block.** 

SQL processes the GROUP BY before creating SELECT aliases, so if we try to GROUP BY month, we’ll see an "Invalid column name" error.

---
#  Quick Recap 🚀
By grouping on month and country, we gain meaningful monthly summaries for each country, and these strategies help us navigate SQL’s processing order so we can leverage calculated aliases effectively.
- Month Extraction: Formatting the transaction date helps in tracking monthly performance.
- Country Focus: We can identify where our transactions are taking place, aiding in targeted strategies.
- Transaction Counts: By counting total and approved transactions, we get clarity on success rates.
- Financial Totals: Summing transaction amounts helps in understanding revenue flows and successful transactions.
- - -
- Need to reuse month?
Use a CTE (Common Table Expression): Alternatively, a CTE can make the month alias available for grouping in a cleaner, more readable way. First, we define the alias month in the CTE. Then, in the main query, we can refer to month directly in both SELECT and GROUP BY, because it’s already defined:
```
WITH MonthlyData AS (
    SELECT 
        FORMAT(trans_date, 'yyyy-MM') AS month,
        country,
        COUNT(*) AS trans_count,
        COUNT(CASE WHEN state = 'approved' THEN 1 END) AS approved_count,
        SUM(amount) AS trans_total_amount,
        SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
    FROM
        transactions
    GROUP BY
        FORMAT(trans_date, 'yyyy-MM'), country
)
SELECT * FROM MonthlyData;
```
***Using a CTE this way is particularly helpful if we need to refer to month multiple times in complex queries or when clarity and readability are essential.***
