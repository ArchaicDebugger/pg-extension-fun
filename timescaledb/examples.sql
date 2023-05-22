-- Active: 1677054367051@@127.0.0.1@5432@pg_extension_fun@public


SELECT COUNT(1)
FROM hello_world_entries;















-- normal aggregation by month
SELECT date_part('month', time) AS month, COUNT(1) AS count
FROM hello_world_entries
GROUP BY month
ORDER BY count DESC;













































-- adding year in aggregation
SELECT date_part('year', time) AS year, date_part('month', time) AS month, COUNT(1) AS count
FROM hello_world_entries
GROUP BY year, month
ORDER BY count DESC;
































-- time bucket aggregation
-- https://docs.timescale.com/api/latest/hyperfunctions/time_bucket/
SELECT TIME_BUCKET('1 month', time) AS interval,
    COUNT(1) AS count
FROM hello_world_entries
GROUP BY interval
ORDER BY interval DESC;







































-- use a window function to calculate first language
WITH cte_ranked_languages AS (
    SELECT TIME_BUCKET('1 month', time) AS interval,
        language,
        ROW_NUMBER() OVER (PARTITION BY TIME_BUCKET('1 month', time) ORDER BY time ASC) AS row_number
    FROM hello_world_entries
)
SELECT interval, language
FROM cte_ranked_languages
WHERE row_number = 1
GROUP BY interval, language;































-- time bucket aggregation, first used language of the month, last of the mont
SELECT TIME_BUCKET('1 month', time) AS interval,
    first(language, time) AS language, last(language, time) AS last_language
FROM hello_world_entries
GROUP BY interval;







































-- most used in time bucket
SELECT DISTINCT ON (TIME_BUCKET('1 month', time)) TIME_BUCKET('1 month', time) AS interval,
    language, COUNT(1) AS total
FROM hello_world_entries
GROUP BY interval, language
ORDER BY interval ASC, total ASC;






