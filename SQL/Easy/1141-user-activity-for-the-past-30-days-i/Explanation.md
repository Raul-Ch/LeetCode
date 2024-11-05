# https://leetcode.com/problems/user-activity-for-the-past-30-days-i/solutions/6013066/efficient-flexible-why-this-sql-solution-for-daily-active-users-beats-the-rest/
# 🚀 Why This Solution Rocks!
This approach not only meets the requirements but also has added benefits:
This SQL query not only gets the job done, but it also leaves room for additional functionality if you need it. You could, for example, add another WHERE clause to refine the user activities, or even make it into a view for repeated use in analytics.

1. **Reusability**: The CTE can easily be adapted to different date ranges by adjusting the DATEADD function, making this a great “template” query for other activity-based analyses.
2. **Threshold Flexibility**: By adjusting the activities >= 1 condition, we can adapt the definition of “active” without reworking the whole query, which is super handy in real-world applications.
3. **Efficiency**: Using a CTE and filtering early minimizes the data we’re working with, so we’re only counting the records we need. This makes it a pretty efficient approach, especially for large datasets.

---


# Problem Overview 📅
Our task is to identify the daily active users over a 30-day period ending on July 27, 2019. A “daily active user” is defined as someone who performed at least one activity on that day.

# 🧠 Approach and Strategy
Even though the requirements are a bit vague, we’re going to make the most of it! This query allows us not only to get the answer but also to leave room for future enhancements or further analysis. Think of it as creating a highly efficient, reusable snippet that can adapt to other activity patterns or time frames.

Our approach breaks down as follows:

1. **Defining the Date Range**: We’re targeting a fixed 30-day period, so we’ll create a subset of data that captures only activities between “2019-06-28” and “2019-07-27” (inclusive).
2. **Daily Activity Tracking**: For each user on each day, we’ll count how many activities they performed. This helps us flexibly define what “active” means, whether it’s at least one activity or another threshold.
3. **Counting Active Users per Day**: Finally, we’ll tally up how many unique users were active on each day.

Let’s dive in!

# The All-Star SQL Code ⭐️
```mssql []
WITH activities AS(
    SELECT 
        user_id, 
        activity_date,
        COUNT(activity_type) as activities 
    FROM
        Activity
    WHERE
        activity_date BETWEEN DATEADD(day, -29, '2019-07-27') AND '2019-07-27'
    GROUP BY 
        user_id, activity_date
)
SELECT
    activity_date AS day,
    COUNT(user_id) AS active_users
FROM
    activities
WHERE
    activities >= 1
GROUP BY
    activity_date


```
# Code Explanation 🛠️
# **Step 1:** Defining the CTE – activities
In this first part, we use a CTE called activities to limit our data to the 30-day period specified in the task. Here’s how it works:

- **Date Filtering:** Using DATEADD, we dynamically calculate the start date of the 30-day window (DATEADD(day, -29, '2019-07-27')) and select only records from that period.
- **Counting Activities per User, per Day:** For each user_id and activity_date, we count how many activities they performed. This allows us to easily check how “active” each user was.

# Step 2: Main Query – Counting Daily Active Users
In our main query, we use the CTE activities to find out how many users were active on each day:

- Filtering for Active Users: Here’s where the fun starts. We filter where activities >= 1, treating any user with at least one activity as active.

***🔍 Note: This threshold can be adjusted! For instance, if we want to check for users who logged in, performed an activity, and logged out, we could change the filter to activities >= 3 — making the solution adaptable.***

- Counting Unique Active Users per Day: For each day, we count the unique user_ids, resulting in the count of active users for each day in the period.
---
# Key SQL Concepts Used ⚙️
- **WITH (CTE):** CTEs provide temporary, readable tables that help simplify complex queries and keep the main query clean.
- **DATEADD:** Allows us to dynamically calculate date ranges — perfect for time-based filters.
- **COUNT()** with Conditions: Filtering based on activity count lets us define what “active” means, adding flexibility.
- 

---

![image.png](https://assets.leetcode.com/users/images/34c9d560-0508-44c8-ab47-8467332d3d89_1730406220.4817703.png)
