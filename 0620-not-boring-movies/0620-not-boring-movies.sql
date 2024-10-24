SELECT 
    *
FROM
    Cinema AS C
WHERE
    id % 2 <> 0 AND C.description <> 'boring'
ORDER BY
    rating DESC