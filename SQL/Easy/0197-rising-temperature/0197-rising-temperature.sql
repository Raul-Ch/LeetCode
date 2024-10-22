SELECT 
    W1.id
FROM 
    Weather AS W1
JOIN 
    Weather AS W2
ON 
    W1.recordDate = DATEADD(day, 1, W2.recordDate)
WHERE 
    W1.temperature > W2.temperature;
/* DATE_ADD(W2.recordDate, INTERVAL 1 DAY) adds one day to the recordDate of W2. By doing this, we're looking for a row in W1 where the recordDate is exactly one day after the recordDate of a row in W2.
In simpler terms: For each row in W2, we find the corresponding row in W1 that represents the next day. */
