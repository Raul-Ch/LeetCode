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

/*
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
*/