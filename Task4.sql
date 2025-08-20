-- Task 4. Оновлення skill_variants.cnt

UPDATE skill_variants sv
JOIN (
    SELECT cs.variant_id, COUNT(DISTINCT cs.candidate_id) AS cnt
    FROM candidate_skills cs
    GROUP BY cs.variant_id
) t ON t.variant_id = sv.id
SET sv.cnt = t.cnt;
SELECT * FROM skill_variants;