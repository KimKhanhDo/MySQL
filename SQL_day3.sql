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

-- bus

WITH matching AS (
    SELECT
        b.id AS bus_id,
        p.id AS pass_id,
        FIRST_VALUE(b.id) OVER (PARTITION BY p.id ORDER BY b.time) AS first_arrived_bus
    FROM buses b
    LEFT JOIN passengers p ON b.destination = p.destination
                          AND b.origin = p.origin
                          AND b.time >= p.time
    ORDER BY p.id
)
SELECT
    bus_id AS id,
    COUNT(CASE WHEN bus_id = first_arrived_bus THEN pass_id END) AS passengers_on_board
FROM matching
GROUP BY bus_id
ORDER BY bus_id;
