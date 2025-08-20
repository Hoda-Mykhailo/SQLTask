-- Task 5. Нагадування на сьогодні для HR Alice (hr_id = 1)

SELECT 
    r.id AS reminder_id,
    r.remdate,
    r.candidate_id,
    c.full_name,
    r.note
    -- Тут в кінці виконання завдання таблиця пуста буде, бо в таблиці reminders дати на 03 місяць, а в завданні просять перевірии нагадування на сьогоднішній день.
    -- Якщо в тій таблиці замінити значення в колонці із датами, або додати, то має виводити вже дані за сьогоднішні нагадуваня.
FROM reminders r
JOIN candidates c ON c.id = r.candidate_id
JOIN access a ON a.entity_id = r.id
             AND a.entity_type = 'reminder'
             AND a.hr_id = 1
             AND a.right_code = 'Read'
WHERE r.hr_id = 1
  AND r.remdate >= CURDATE()
  AND r.remdate <  CURDATE() + INTERVAL 1 DAY
ORDER BY r.remdate;
