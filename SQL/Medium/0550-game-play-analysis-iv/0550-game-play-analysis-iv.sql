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