# https://leetcode.com/problems/product-sales-analysis-iii/post-solution/6034116/
#  Problem Breakdown 🧠
Alright, here’s the mission: we’re diving into a Sales table to pull out the product_id, year, quantity, and price for the first year each product was sold. Picture it like picking the debut year of every product in our records. All we need are those exact details—no fancy math, no sneaky totals, just a clean snapshot of each product’s first appearance. The twist? We can grab those rows in any order, just as long as they’re the first year!

---


# Intuition 💡
Our goal is simple—find the first year a product made its grand entrance and keep all the juicy details. So, the plan is to rank each product’s sales records by year and grab the rows that earn the rank of "1." By using a ranking function, we can effortlessly sort through years like a time machine, plucking out each product’s origin story.

# Approach
Here’s the game plan to capture those debut details:

1. Use a window function with DENSE_RANK() to rank each product_id by year within the Sales table. This way, every product has its years ranked, with the earliest year getting a shiny rank of 1.
2. Now that each row has a rank, we filter out any rows that aren’t part of that debut year (aka year_rank = 1).
3. Return the exact columns we care about (product_id, year, quantity, and price)—no extras, no aggregation—just that snapshot of each product’s first year!
---

# The All-Star SQL Code ⭐️
```mssql []
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
```
# Code Explanation 👩‍💻
1. **WITH Clause (FirstYear):** Think of this as our backstage pass. We’re creating a Common Table Expression (CTE) called FirstYear that selects every column from Sales and gives each row a year_rank based on the order of the year. Using DENSE_RANK() here ensures we don’t skip any ranks and gives us the top spot (1) for each product’s first year.
2. **Main Query:** Now that we’ve got our ranked rows, we can filter for only the "first year" entries. We then select the columns we need (product_id, year as first_year, quantity, and price) from FirstYear for our final, polished result.
---
# ⚙️ Deep Dive  SQL Query Breakdown 🛠️
- **DENSE_RANK() OVER (PARTITION BY product_id ORDER BY year):** This line is the magic wand! By partitioning over product_id and ordering by year, we assign a neat rank to each product’s years. Rows with the same year get the same rank, which is perfect in case of ties.
- **WHERE year_rank = 1:** With this line, we keep only the earliest sales records (the rank 1 records) for each product, ditching the rest to keep our focus on the first year.
---
# WANT TO LEARN MORE??? .... 
# When to Use SUM 🧩
Ah, but what about summing quantity and price? Wouldn’t that make things even neater? Well, yes and no! Here’s why summing might or might not suit the job:

# **When Summing is a Power Move:**
1. **Big-Picture Summaries:** If the goal is to create a quick overview of total sales and revenue in each product’s first year, summing would be spot-on. Think dashboards, financial reports, or other bird’s-eye views that benefit from a single summary row.
2. **Condensed Data:** Summing could simplify data when individual transactions don’t add much insight—for example, where all you need is “Product X sold Y units for Z dollars in its first year.”

# **Why Summing Isn’t the Hero Here:**
- **Row-Level Detail Requirement:** LeetCode wants individual transactions in the first year, with exact quantity and price values untouched. By summing, we’d lose the ability to see each specific sale.
- **Keeping Transaction Granularity:** This query lets us see each transaction individually. For instance, if different prices or quantities were recorded in the same year, those details stay intact, providing a more detailed view.


- For this problem, our non-aggregated solution is a perfect fit, letting us show each product’s debut with all the original details intact!
---

![image.png](https://assets.leetcode.com/users/images/fe7ea8af-138b-48b0-9283-66552569cf9a_1731340378.7348585.png)

