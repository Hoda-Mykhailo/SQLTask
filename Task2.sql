-- Task 2. Місячна статистика по вакансіях (березень 2025)

WITH events AS (
    SELECT 
        v.id AS vacancy_id,
        v.title AS vacancy_title,
        s.user_uid AS candidate_id,
        s.type_id,
        s.creation_date
    FROM early_statuses s
    JOIN vacancies v ON v.id = s.vacancy_id
    WHERE s.creation_date >= '2025-03-01'
      AND s.creation_date <  '2025-04-01'
)
SELECT 
    v.id AS vacancy_id,
    v.title AS vacancy_title,
    '2025-03' AS month,
    COUNT(DISTINCT CASE WHEN e.type_id IN (1,3,4,10,11,12,14,19) THEN e.candidate_id END) AS total_candidates,
    COUNT(DISTINCT r.id) AS resumes_sent,
    SUM(CASE WHEN e.type_id = 10 THEN 1 ELSE 0 END) AS contracts,
    SUM(CASE WHEN e.type_id = 11 THEN 1 ELSE 0 END) AS rejections,
    SUM(CASE WHEN e.type_id = 2 THEN 1 ELSE 0 END) AS calls,
    SUM(CASE WHEN e.type_id IN (12,14) THEN 1 ELSE 0 END) AS interviews
FROM vacancies v
LEFT JOIN events e ON e.vacancy_id = v.id
LEFT JOIN resumes r 
       ON r.vacancy_id = v.id 
      AND r.sent_at >= '2025-03-01' 
      AND r.sent_at <  '2025-04-01'
GROUP BY v.id, v.title
ORDER BY v.id;
