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