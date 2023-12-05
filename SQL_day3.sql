-- sensors most recent
SELECT 
    p.id AS play_id,
    p.title,
    COUNT(r.number_of_tickets) AS reserved_tickets
    
FROM plays p
LEFT JOIN reservations r ON p.id = r.play_id
GROUP BY p.id, p.title
ORDER BY reserved_tickets DESC, p.id ASC;

-- transfer
SELECT name,
	SUM(CASE WHEN money > 0 THEN money ELSE 0 END) AS sum_of_deposits,
    SUM(CASE WHEN money < 0 THEN ABS(money) ELSE 0 END) AS sum_of_withdrawals
FROM transfers 
GROUP BY name
ORDER BY name;


