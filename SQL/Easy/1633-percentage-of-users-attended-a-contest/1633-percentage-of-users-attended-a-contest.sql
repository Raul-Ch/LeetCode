SELECT
    R.contest_id,
    ROUND (COUNT(R.user_id) * 100.0 / (SELECT COUNT(U.user_id) FROM Users as U), 2) AS Percentage
FROM
    Register as R
GROUP BY
    R.contest_id
ORDER BY
    percentage DESC, contest_id