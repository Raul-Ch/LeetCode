# https://leetcode.com/problems/immediate-food-delivery-ii/discuss/5990781/my-first-top-beats-98-10-easy-explanations-and-solutions-from-a-fellow-newbi/

# Problem Overview
This SQL adventure dives into the realm of first order analytics—where we aim to capture how many first orders were delivered on the exact date a customer requested. If an order date matches the preferred date, it's considered immediate. If not, it's scheduled.

# THE PROBLEM
Each customer has multiple orders, but we're only interested in their very first order—the one with the earliest date. Our mission? 🕵️‍♀️ To find the percentage of these first orders that were immediate.

# 🧠 Problem Breakdown
- Immediate Order Definition: An order is immediate if its delivery date matches the customer's order date. Otherwise, it's scheduled.
- Objective: Calculate the percentage of first orders that were immediate. This means focusing only on the earliest order date for each customer.

---


# 💡 Intuition
First approach? You might think: why not just count all cases where the order_date equals the customer_pref_delivery_date? 
`ROUND(SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)`
**WROOONG**, Unfortunately, this will count all immediate orders instead of only the immediate first orders.

# Approach
**Trick from @lex8390:** “Why not use DENSE_RANK() and PARTITION BY?” Brilliant! Let’s use these SQL tools to identify each customer's first order and check if it was immediate.

- PARTITION BY: Groups rows by customer_id, allowing us to isolate each customer’s order history.
- DENSE_RANK(): Assigns a ranking to each order within each customer’s partition based on the order date. The first order will have a DENSE_RANK of 1, so we can filter for these "first" orders.

**This gives us exactly what we need: a set of only the first orders to analyze for immediacy!**

---
# The All-Star SQL Code ⭐️
```mssql []
WITH FirstOrders AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS FirstOrder
    FROM
        Delivery
)
SELECT 
    ROUND(SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS immediate_percentage
FROM 
    FirstOrders
WHERE 
    FirstOrder = 1;

```
# PROVEEE:
![image.png](https://assets.leetcode.com/users/images/d3768cc2-2d2b-48fb-a292-fc8dcde61598_1730403957.0788112.png)

# 👩‍💻 Code Explanation
This query utilizes a Common Table Expression (CTE) to create a copy of the Delivery table, adding a FirstOrder rank for each customer. This way, we can efficiently analyze and filter only the first orders.

```mssql []
WITH FirstOrders AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS FirstOrder
    FROM
        Delivery
)
```

- Step 1: We replicate the Delivery table but add a column, FirstOrder, to denote each customer’s earliest order using DENSE_RANK().

**Why DENSE_RANK()?** 
This rank handles even the smallest differences (down to seconds) in order_date precisely. If two orders happen on the same day but one at 9 AM and another at 11 AM, only the earlier order will be marked as the “first.”

- Step 2: Filter for First Orders Only

```mssql []
SELECT 
    ROUND(SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS immediate_percentage
FROM 
    FirstOrders
WHERE 
    FirstOrder = 1;


```
Here’s what’s happening:

We SUM the immediate first orders (where the order_date matches the customer_pref_delivery_date) and calculate the percentage of those orders by dividing by the total first orders.

**WHERE FirstOrder = 1 restricts results to first orders only.**


---
# SQL Query Breakdown 🛠️
1. **WITH FirstOrders AS (...)**: 
**Step 1**: This defines a Common Table Expression (CTE) named FirstOrders, creating a temporary result set based on the Delivery table. 
**Step 2**: The CTE enables us to simplify subsequent queries by allowing us to reference this pre-processed dataset throughout our SQL script.
2. **DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS FirstOrder**: 
**Step 1:** This assigns a rank to each order within partitions defined by customer_id, ordering them by order_date. 
**Step 2:** By using DENSE_RANK(), we can identify the first order accurately even if multiple orders share the same date, allowing us to handle ties effectively.

3. **ROUND(SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS immediate_percentage:** 
**Step 1:** This expression calculates the percentage of first orders that were delivered immediately (i.e., on the preferred delivery date). 
**Step 2:** It sums up cases where the order_date matches the customer_pref_delivery_date, counts all first orders, and computes the percentage to two decimal places for a clean output.

4. **FROM FirstOrders:**
**Step 1:** This specifies that we’re drawing our results from the FirstOrders CTE created earlier. 
**Step 2**: It ensures that all calculations are based on the filtered dataset containing only the first orders per customer.

5. **WHERE FirstOrder = 1:** 
**Step 1:** This filter restricts our calculations to only those rows where the order is identified as the first for each customer. 
**Step 2:** It guarantees that our percentage calculation focuses solely on first orders, excluding any subsequent orders, which is crucial for accurate analysis.

---

# ⚙️ Deep Dive: PARTITION BY, DENSE_RANK, and Our Approach


# PARTITION BY:
**Purpose**: Divides the dataset into groups (or partitions) to perform computations within each group.
**Usage**: Commonly paired with window functions like RANK(), ROW_NUMBER(), and DENSE_RANK() to add ranking or numbering within each partition.
**Example**:

``` sql []
SELECT
    column1,
    column2,
    RANK() OVER (PARTITION BY column1 ORDER BY column2 DESC) AS rank
FROM
    your_table;
```
In this example, rows are ranked within each partition of column1 based on the ordering of column2.

# RANK():

**Purpose**: Assigns ranks within each partition of the result set.
**Behavior**: If there are ties, the same rank is assigned to all tied rows, and the next rank is skipped.
**Example**:

``` sql []
Copiar código
SELECT
    column1,
    RANK() OVER (ORDER BY column1 DESC) AS rank
FROM
    your_table;
```

# ROW_NUMBER():

**Purpose**: Assigns a unique number to each row within a partition.
**Example**:

``` sql []
Copiar código
SELECT
    column1,
    ROW_NUMBER() OVER (PARTITION BY column1 ORDER BY column2 DESC) AS row_num
FROM
    your_table;
```

# DENSE_RANK():
**Purpose**: Similar to RANK(), but without skipping ranks when there are ties. Useful when subtle time differences matter, such as in transactions recorded down to the hour, minute, or second.
**Example**:

``` sql []
Copiar código
SELECT
    column1,
    DENSE_RANK() OVER (PARTITION BY column1 ORDER BY column2 DESC) AS dense_rank
FROM
    your_table;
```
![image.png](https://assets.leetcode.com/users/images/34c9d560-0508-44c8-ab47-8467332d3d89_1730406220.4817703.png)


