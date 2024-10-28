# https://leetcode.com/problems/average-time-of-process-per-machine/post-solution/5953893/

# Intuition
For each process, you know when it starts and when it ends, and you're tasked with figuring out how long, on average, each machine spends running its processes. Our first instinct? **Compare the timestamps for when a process starts and when it ends, For every machine**, we calculate the difference between the end and start times for all its processes, then average those differences to get the "processing time."

---


# Approach
```
SELECT
    A1.machine_id,
    A1.process_id,
    A1.timestamp AS StartTime,
    A2.timestamp AS EndTime
FROM
    Activity AS A1
JOIN
    Activity AS A2
ON
    A1.machine_id = A2.machine_id
    AND A1.process_id = A2.process_id
    AND A1.activity_type = 'start'
    AND A2.activity_type = 'end'
ORDER BY
    A1.machine_id, A1.process_id;
```


![image.png](https://assets.leetcode.com/users/images/18b20f80-757c-4a2d-bfca-2a158ae9e62a_1729617689.17188.png)


---
# Solution
We begin by self-joining the table so that for each process (identified by machine_id and process_id), we can pair the "start" activity with the "end" activity. This allows us to directly compute the difference in time for every process. From there, we group the results by machine_id and apply the AVG() function to calculate the average processing time for each machine.

Here’s the step-by-step breakdown:

1. Self-Join the Table: We join the Activity table on itself (A1 and A2), where A1 captures the "start" events and A2 captures the corresponding "end" events for the same machine and process.
2. Calculate Time Differences: For each process, subtract the start time (A1.timestamp) from the end time (A2.timestamp) to get the processing time for that specific process.
3. Group by Machine: Since we want the average processing time per machine, we group the results by machine_id.
4. Compute the Average: Finally, use the AVG() function to compute the average of all process durations for each machine.

---
# Code
```mssql []
SELECT
    A1.machine_id,
    ROUND(AVG(A2.timestamp - A1.timestamp), 3) AS processing_time
FROM
    Activity AS A1
JOIN
    Activity AS A2
ON
    A1.machine_id = A2.machine_id
    AND A1.process_id = A2.process_id
    AND A1.activity_type = 'start'
    AND A2.activity_type = 'end'
GROUP BY
    A1.machine_id
```
![image.png](https://assets.leetcode.com/users/images/1f0c10ff-9106-4190-8e29-c0ce031f7599_1729618255.195419.png)

---
# QUESTIONS?
**How Does AVG() Know How Many Processes?**
The number of processes a machine runs is inferred from the number of (machine_id, process_id) pairs that appear in the joined result. In the input example, each machine has multiple processes, and each process has exactly one start and one end event.

For example, for Machine 0:

The query joins the two rows for process_id = 0 (start and end) and calculates the processing time (1.520 - 0.712 = 0.808).
It does the same for process_id = 1 (4.120 - 3.140 = 0.980).
Since GROUP BY machine_id is used, these two processes are grouped under machine_id = 0.
The AVG() function then averages the two times (0.808 + 0.980) / 2 = 0.894.

***Thus, AVG() "knows" the number of processes a machine runs because, within each group (based on machine_id), it computes the average of all the time differences for each process.***

**DEEPER UNDERSTANDING**
- JOIN:
First, the query joins the Activity table (A1 and A2) on machine_id, process_id, and the activity_type (i.e., matching start and end events for the same process on the same machine). This gives you pairs of rows for each process with a start and end event, allowing you to calculate the time difference for each process (A2.timestamp - A1.timestamp).

- GROUP BY machine_id:
The GROUP BY clause ensures that the results are grouped by machine_id. This means that for each machine_id, all the processes (matched start and end times) are aggregated into one group.
Within each group, AVG() will then calculate the average time difference for all the processes associated with that machine.

- AVG() Calculates the Average Processing Time:
Once the rows are grouped by machine_id, the AVG() function computes the average of the values it receives from the expression A2.timestamp - A1.timestamp, which represents the time taken for each process.
The number of processes for each machine is implicitly determined by the number of rows in the group for that machine.

![image.png](https://assets.leetcode.com/users/images/196c8801-3b61-40da-9e5f-924093831cb1_1729618349.6386812.png)

