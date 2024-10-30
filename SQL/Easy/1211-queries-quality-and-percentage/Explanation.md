# https://leetcode.com/problems/queries-quality-and-percentage/solutions/5987384/easy-explanations-and-solutions-from-a-fellow-newbi-beats-80-81/
# Intuition
Step Up Your Query Game! 💡
The goal is to calculate two metrics for each query:
- **quality**: the average quality score, calculated as the average of rating / position.
- **poor_query_percentage**: the percentage of queries with a rating below 3 for each query name.

---
# Approach
Here’s the Game Plan 📝
**Quality: Finding Each Query’s Score**
We’ll rate each query by averaging the ratio of rating to its position (yes, position matters!). The formula AVG(rating / position) will help us capture a balanced score, and we’ll wrap it up with a ROUND(..., 2) to keep things neat at two decimal places.

**Poor Query Percentage: Spotting the Slackers**
Now let’s identify the “poor performers”—queries with a rating below 3. Using a CASE inside COUNT, we’ll selectively tally up these underperformers and then calculate their percentage against the total queries per query_name. Multiplying by 100 gives us a quick conversion to percentage form, and, as before, a little ROUND(..., 2) brings it home with just two decimal points.

**Filtering Out the Nulls 🚫**
With a simple WHERE query_name IS NOT NULL, we keep the dataset clean and relevant—no need to clutter the results with blanks!

---
# The All-Star SQL Code ⭐️
1. Calculate quality:
We calculate the quality for each query_name by averaging the ratio (rating / position). This approach gives a relative score adjusted by the position of each query.
2. Calculate poor_query_percentage:
We count the total number of queries and also count only those with a rating less than 3. Dividing the count of poor queries by the total count for each query_name gives the percentage of poor queries.
3. Handle NULL Values:
To ensure we do not miss any queries, we include a WHERE clause to filter out NULL values for query_name.

```mssql []
SELECT 
    query_name,
    ROUND(AVG((rating * 1.0 / position)), 2) AS quality,
    ROUND((COUNT(CASE WHEN rating < 3 THEN query_name END) * 1.0 / COUNT(query_name)) * 100, 2) AS poor_query_percentage
FROM
    Queries
WHERE
    query_name IS NOT NULL
GROUP BY
    query_name
```
# SQL Query Breakdown 🛠️
- **ROUND(AVG(rating * 1.0 / position), 2) AS quality:**
**Step 1**: rating * 1.0 ensures that our division with position returns a decimal rather than an integer. This prevents SQL from performing integer division, which would round off the decimal and give inaccurate results.
**Step 2**: AVG(rating / position) calculates an average score for each query_name, factoring in position. This gives a weighted quality score that considers the position’s impact on rating.
**Step 3**: ROUND(..., 2) rounds this average quality score to two decimal places, making it easier to read and more precise for quick comparisons.

- **COUNT(CASE WHEN rating < 3 THEN query_name END) * 1.0 / COUNT(query_name):**
**Step 1**: We use CASE WHEN rating < 3 THEN query_name END to selectively count queries with a rating below 3. This lets us tally only the underperformers.
**Step 2**: COUNT(...) * 1.0 / COUNT(query_name) divides the count of poor ratings by the total count of ratings for each query_name. This gives a ratio indicating how often the query is rated below 3.
**Step 3:** We multiply this ratio by 100 to convert it into a percentage, and once again, we round to two decimal places for clean, professional-looking results.

- **ROUND(..., 2):**
Used here to make sure that both quality and poor_query_percentage values are displayed with two decimal places. This provides a consistent, readable output and ensures that your results are easy to interpret.

# The GROUP BY Clause: Pulling It All Together 🎯
The GROUP BY query_name clause is essential in this query. It groups all rows with the same query_name together, allowing us to:

Aggregate data for each unique query_name, calculating averages and counts specifically for each group of queries.
Summarize the quality and poor_query_percentage for each query_name independently, providing insights into each unique query rather than the entire dataset as a whole.

---
# Quick Recap 🚀
Quality Calculation: By averaging rating / position, we get a fair, weighted score for each query.
Poor Query Percentage: Using CASE WHEN rating < 3, we zero in on low-rated queries and tally up their percentage.
Keeping Results Clean: Filtering out NULL names makes sure our results stay sharp.
