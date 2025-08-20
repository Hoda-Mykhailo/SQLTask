-- Task 1. Ліди без подальших дій

SELECT DISTINCT
    c.id AS candidate_id,
    c.full_name,
    c.linkedin_url,
    v.id AS vacancy_id,
    v.title AS vacancy_title,
    s.creation_date,
    s.comment_text,
    c.is_friend,
    c.is_pro
FROM early_statuses s
JOIN candidates c ON c.id = s.user_uid
JOIN vacancies v ON v.id = s.vacancy_id
JOIN access a1 ON a1.entity_id = c.id
               AND a1.entity_type = 'candidate'
               AND a1.hr_id = 1
               AND a1.right_code = 'Read'
JOIN access a2 ON a2.entity_id = v.id
               AND a2.entity_type = 'vacancy'
               AND a2.hr_id = 1
               AND a2.right_code = 'Read'
WHERE s.type_id = 1
  AND s.creation_date >= '2025-03-01'
  AND s.creation_date <  '2025-04-01'
  -- немає пізнішого статусу по тому ж кандидату і вакансії
  AND NOT EXISTS (
        SELECT 1
        FROM early_statuses s2
        WHERE s2.user_uid = s.user_uid
          AND s2.vacancy_id = s.vacancy_id
          AND s2.creation_date > s.creation_date
    )
  -- немає відправленого резюме по цій парі
  AND NOT EXISTS (
        SELECT 1
        FROM resumes r
        WHERE r.candidate_id = s.user_uid
          AND r.vacancy_id = s.vacancy_id
          AND r.sent_at IS NOT NULL
    )
ORDER BY s.creation_date ASC
LIMIT 0, 1000;
