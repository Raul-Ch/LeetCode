# https://leetcode.com/problems/game-play-analysis-iv/solutions/6013047/wuu-top-beats-99-10-easy-explanations-and-solutions-from-a-fellow-newbi/
# Problem Overview 🕵️‍♂️
Our SQL mission is to track how many players returned to the game the very next day after their first login. Picture it as finding those die-hard fans who just had to come back. To do this, we’re calculating a fraction: the number of players who returned the next day divided by the total number of players.

# 🔍 Problem Breakdown
- **The Challenge:** Find players who logged in on consecutive days, specifically focusing on the day after their first login.
- **Goal:** Calculate the fraction of these loyal players by dividing the number of players who logged in on back-to-back days by the total player count.

---
# 💡 Intuitive Approach
Let’s break it down step-by-step. Our natural instinct might be to check every possible login and look for any consecutive days. But that can quickly get out of hand, counting irrelevant data from later logins. Instead, let’s focus on just two dates:

- The player’s first login date (we’ll identify this with a MIN()).
 ```
MIN(event_date)
```
- The day after this first login, which we can create with a simple date function.
 ```
DATEADD(day, 1, MIN(event_date)) AS ConsecLogin
```

**Steps to Solve**
Here's the path we'll take:

1. Identify the First Login Date for each player
2. Calculate the Day After their first login.
3. Check for a Login on the Next Day: Count the players who logged in again on this calculated day.

Once we have those players, we'll simply divide by the total number of players to get our fraction.


---

# 🛠️ SQL Approach
To get this right, let’s bring in a Common Table Expression (CTE) and a join:

- **CTE Creation:** Our CTE will calculate each player’s first login date and, using a DATEADD(), will add one day to create our target "next day" login date.
- **Joining:** Now, we’ll join this CTE back to our main table on player_id and filter out those logins where a player logged in again on that “next-day” date.
- **Final Calculation:** We’ll sum up all the players who met this condition and divide by the total player count to get our fraction, rounded to two decimal places.

(This approach efficiently isolates the "next-day" logins, filters for each player’s consecutive days, and calculates the fraction of players who logged in again on the day after their first login.)
---

# The All-Star SQL Code ⭐️
```mssql []
WITH COUNTLOGINS AS (
    SELECT
        player_id,
        DATEADD(day, 1, MIN(event_date)) AS ConsecLogin
    FROM
        Activity
    GROUP BY
        player_id
)
SELECT
    ROUND(SUM(CASE WHEN A.event_date = CL.ConsecLogin THEN 1 ELSE 0 END) * 1.0 / COUNT(DISTINCT A.player_id), 2) as fraction
FROM
    Activity AS A
JOIN
    COUNTLOGINS AS CL
ON A.player_id = CL.player_id


```
# 👩‍💻 Code Explanation
# **Step 1: Define the CTE - COUNTLOGINS**
In this step, we build a mini-table (CTE) with each player’s first login date, plus one additional day:

- **MIN(event_date)**: Grabs the player’s first login date.
- **DATEADD(day, 1, ...)**: Adds one day to that first login, giving us the next day.

This creates a handy reference for each player’s "next-day" login that we’ll use to compare against actual login data.

# **Step 2: Join and Compare**
Next, we join our CTE COUNTLOGINS with the main table Activity on player_id. This step lets us compare the calculated "next day" date against actual login records.

- **CASE WHEN A.event_date = CL.ConsecLogin**: For each matching player, this line checks if they logged in on the target “next day.” If so, we count it as 1.
# **Step 3: Calculate the Fraction**
With our CASE counting who returned the next day, we:

- Sum up those counts, giving us the total number of next-day returns.
- Divide by the distinct count of player_ids to get the fraction of players who logged in consecutively.

The ROUND(..., 2) keeps things tidy, rounding to two decimal places.

---
# 💡 Additional Tips
- *Filter and Experiment:* If you want to see a quick preview, you can try pulling just player_id and ConsecLogin in the CTE, then join on event_date to inspect only consecutive logins.
- *Date Calculations:* By using MIN() and DATEADD, we’re only focusing on the first two days in a player’s activity, keeping the logic clean and efficient.
-* Easy Tweaks*: You can quickly adjust this by tweaking the dates or counts if you want to explore additional login patterns.

---
# ⚙️ Deep Dive: Key SQL Functions
- WITH (Common Table Expressions):

Enables the creation of a temporary dataset for more readable and organized code.
- DATEADD:

Adds a specified interval (in this case, 1 day) to a date, allowing us to calculate the next day after a player’s first login.
- ROUND:

Rounds the result to a specified number of decimal places (2 in this case) for a concise answer.

---

![image.png](https://assets.leetcode.com/users/images/737d03d7-a493-4ca8-811c-50866b449054_1730844587.2710903.png)

---

# PROVEE
![image.png](https://assets.leetcode.com/users/images/54f0a75f-58ef-4579-8a17-8d3d9b700131_1730844243.4477382.png)
