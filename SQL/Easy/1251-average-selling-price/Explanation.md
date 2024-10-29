# https://leetcode.com/problems/average-selling-price/solutions/5979617/easy-explanations-and-solutions-from-a-fellow-newbi-beats-77-50/?envType=study-plan-v2&envId=top-sql-50
# Intuition
To calculate the average_price for each product, we’ll start by analyzing the prices and units sold for each item. This calculation should account for each time range that a price is in effect, ensuring we use accurate values based on the specific sale dates. Our main goal is to calculate the weighted average price for each product using the available data from the Prices and UnitsSold tables.

---
# Approach
1. **Join the Tables:** We need to join the Prices table with UnitsSold on product_id, matching only where the purchase date in UnitsSold falls within the price’s effective start_date and end_date.
2. **Calculate Total Values:** For each product, we calculate the total sales value by summing price * units and also get the total units sold.

**If we first analyze the Prices and UnitsSold tables, we can understand each product's price, units sold, and price * units. Testing this with a basic query shows us a breakdown:**

```
SELECT
    P.product_id,
    SUM(P.price) AS Price,
    SUM(U.units) AS Total_Units,
    SUM(P.price * U.units) AS Total_Price
FROM
    Prices AS P
JOIN
    UnitsSold AS U
ON
    P.product_id = U.product_id
    AND U.purchase_date BETWEEN P.start_date AND P.end_date
GROUP BY
    P.product_id, P.price;
```
And we get:
| product_id | Price | Total_Units | Total_Price |
| ---------- | ----- | ----------- | ----------- |
| 1          | 5     | 100         | 500         |
| 1          | 20    | 15          | 300         |
| 2          | 15    | 200         | 3000        |
| 2          | 30    | 30          | 900         |

3. **Calculate Weighted Average:** The weighted average price can be calculated by dividing the total sales value by the total units sold for each product.

- **Grouping by Product: From here, we proceed to group results by product_id to see cumulative sales and units.**

```
SELECT
    P.product_id,
    ROUND(SUM(P.price * U.units) * 1.0 / SUM(U.units), 2) AS average_price
FROM
    Prices AS P
LEFT JOIN
    UnitsSold AS U
ON
    P.product_id = U.product_id
    AND U.purchase_date BETWEEN P.start_date AND P.end_date
GROUP BY
    P.product_id;
```
4. **Handle Edge Cases:** Products with no sales (i.e., no entries in UnitsSold) should return an average_price of 0 instead of NULL. For this, we’ll use COALESCE to handle any NULL values gracefully.

---

# FINAL Code
```mssql []
SELECT
    P.product_id,
    COALESCE(ROUND(SUM(P.price * U.units) * 1.0 / SUM(U.units), 2), 0) AS average_price
FROM
    Prices AS P
LEFT JOIN
    UnitsSold AS U
ON
    P.product_id = U.product_id
    AND U.purchase_date BETWEEN P.start_date AND P.end_date
GROUP BY
    p.product_id


```
# Step-by-step Breakdown:
- Join the Tables: Using LEFT JOIN allows us to capture all products, even if they have no sales in UnitsSold. The ON condition ensures that only relevant sales data (where purchase_date is within the effective price date range) is considered.
- Calculate Total Sales and Units: SUM(P.price * U.units) gives us the total revenue for each product based on the effective price and units sold.
SUM(U.units) provides the total units sold for each product.
- Calculate Average Price: Dividing SUM(P.price * U.units) by SUM(U.units) yields the weighted average price.
ROUND(..., 2) ensures the result has two decimal places.
COALESCE(..., 0) handles cases where no units were sold, returning 0 instead of NULL.
- Preventing Division by Zero: Using NULLIF(SUM(U.units), 0) protects against division by zero errors when no units were sold.
---
# QUESTIONS?
**How Does COALESCE Handle Products with No Sales?**
When a product has no corresponding entries in UnitsSold, SUM(U.units) returns NULL. Using COALESCE(..., 0) allows us to set average_price to 0 for these cases instead of showing NULL, which keeps our results clean and meaningful.

**Why Use NULLIF for Division by Zero?**
Using NULLIF(SUM(U.units), 0) avoids errors by returning NULL instead of dividing by zero when no units are sold. This pairs well with COALESCE to ensure we return 0 in such cases.

**How Does the ROUND Function Work?**
ROUND(..., 2) formats our result to two decimal places, providing a precise average_price that meets the problem's requirements.

---


# DEEPER UNDERSTANDING
**JOIN Logic:**
The LEFT JOIN captures all records from Prices while linking to matching rows in UnitsSold. This ensures that all products are included in the result, even if they have no sales.

**Why Use SUM and Division for Weighted Averages?**
Summing price * units gives the total revenue for each product, while summing units provides total units sold. Dividing these gives a weighted average price, considering the quantity of units at each price.
