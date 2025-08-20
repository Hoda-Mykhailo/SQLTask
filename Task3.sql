-- Task 3. KPI по HR за вчора

DROP TEMPORARY TABLE IF EXISTS kpi_table;

CREATE TEMPORARY TABLE kpi_table (
    day_date DATE,
    hr_id INT,
    leads_created INT,
    statuses_added INT,
    resumes_prepared INT,
    resumes_sent INT,
    calls_made INT,
    contracts_signed INT
);

INSERT INTO kpi_table
SELECT
    DATE(NOW() - INTERVAL 1 DAY) AS day_date,
    u.id AS hr_id,
    SUM(CASE WHEN s.type_id = 1 THEN 1 ELSE 0 END) AS leads_created,
    SUM(CASE WHEN s.type_id <> 1 THEN 1 ELSE 0 END) AS statuses_added,
    SUM(CASE WHEN s.type_id = 3 THEN 1 ELSE 0 END) AS resumes_prepared,
    COUNT(r.id) AS resumes_sent,
    SUM(CASE WHEN s.type_id = 2 THEN 1 ELSE 0 END) AS calls_made,
    SUM(CASE WHEN s.type_id = 10 THEN 1 ELSE 0 END) AS contracts_signed
FROM aspnetusers u
LEFT JOIN early_statuses s 
       ON s.created_by = u.id
      AND s.creation_date >= DATE(NOW() - INTERVAL 1 DAY)
      AND s.creation_date <  DATE(NOW())
LEFT JOIN resumes r 
       ON r.created_by = u.id
      AND r.sent_at >= DATE(NOW() - INTERVAL 1 DAY)
      AND r.sent_at <  DATE(NOW())
GROUP BY u.id;

SELECT * FROM kpi_table;