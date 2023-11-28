#1. Show film which dont have any screening
SELECT name  
FROM film f 
LEFT JOIN screening sr ON f.id = sr.film_id 
WHERE sr.id IS NULL ;
    
#2. Who book more than 1 seat in 1 booking
SELECT 
	 c.id AS customer_id,
	 c.first_name,
	 c.last_name,
	 b.id as booking_id,
	 COUNT(rs.id) AS num_seats_booked
     
FROM customer c 
JOIN booking b ON c.id = b.customer_id
JOIN reserved_seat rs ON b.id = rs.booking_id

GROUP BY c.id, b.id
HAVING num_seats_booked > 1;
    
#3. Show room show more than 2 film in one day
SELECT
    r.name AS room_name,
    DATE(sr.start_time) AS screening_date,
    COUNT(DISTINCT sr.film_id) AS num_films_showed
    
FROM room r
JOIN screening sr ON r.id = sr.room_id

GROUP BY r.name, DATE(start_time)
HAVING num_films_showed > 2;
    
#4. which room show the least film ? 
SELECT
    r.name AS room_name,
    COUNT(DISTINCT sr.film_id) AS num_films_showed
FROM room r
LEFT JOIN screening sr ON r.id = sr.room_id
GROUP BY r.name
HAVING num_films_showed = (
        SELECT MIN(count_films)
        FROM (
            SELECT COUNT(DISTINCT film_id) AS count_films
            FROM screening
            GROUP BY room_id
        ) AS subquery
    );

#5. what film don't have booking
SELECT DISTINCT f.name AS film_name
FROM screening s
JOIN booking b ON s.id = b.screening_id
RIGHT JOIN film f ON f.id = s.film_id
WHERE b.id IS NULL;

#6. WHAT film have show the biggest number of room? Which film were screen the most amongs the room?
SELECT
	f.id,
    f.name,
    COUNT(DISTINCT sc.room_id) AS num_rooms_screened
    
FROM film f
JOIN screening sc ON f.id = sc.film_id

GROUP BY f.id, f.name
HAVING num_rooms_screened = (
			SELECT MAX(count_rooms)
			FROM 
				(SELECT COUNT(DISTINCT room_id) AS count_rooms
				FROM screening
				GROUP BY film_id) AS subquery
				) ; 

#7. Show number of film  that show in every day of week and order descending
SELECT
    DAYNAME(sc.start_time) AS date,
    COUNT(DISTINCT sc.film_id) AS num_films_shown
FROM screening sc

GROUP BY date
ORDER BY num_films_shown DESC;

#8. show total length of each film that showed in 28/5/2022
SELECT
    f.name AS film_name,
    SUM(f.length_min) AS total_length,
    DATE(sc.start_time) AS show_time
    
FROM film f
JOIN screening sc ON f.id = sc.film_id
WHERE 
	DATE(sc.start_time) = '2022-05-28'
GROUP BY
     f.name, show_time;

#9. Which film has showing time above and below average show time of all film
SELECT 
	f.name,
    AVG(sc.id) AS above_ave_showtime
FROM screening sc
JOIN film f ON sc.film_id = f.id
GROUP BY f.name
HAVING above_ave_showtime > (
			SELECT AVG(sc.id)
            FROM screening sc);
            
SELECT 
	f.name,
    AVG(sc.id) AS below_ave_showtime
FROM screening sc
JOIN film f ON sc.film_id = f.id
GROUP BY f.name
HAVING below_ave_showtime < (
			SELECT AVG(sc.id)
            FROM screening sc);
            
#10. what room have least number of seat?
SELECT
    r.id,
    r.name,
    COUNT(DISTINCT s.id) AS number_of_seat
FROM room r 
JOIN seat s ON r.id = s.room_id 

GROUP BY r.id, r.name
HAVING number_of_seat = (
        SELECT MIN(total_seats_each_room)
        FROM (SELECT
                room_id,
                COUNT(DISTINCT s.id) AS total_seats_each_room 
            FROM seat s
            GROUP BY room_id) AS subquery
				);

#11. what room have number of seat bigger than average number of seat of all rooms
SELECT 
	r.id, r.name,
    COUNT(DISTINCT s.id) AS num_of_seats
FROM room r 
JOIN seat s ON r.id = s.room_id 

GROUP BY r.name, r.id
HAVING num_of_seats > (
		SELECT AVG(num_of_seats) AS ave_seat
		FROM (SELECT 
				r.id, r.name, 
				COUNT(DISTINCT s.id) AS num_of_seats
			FROM room r 
			JOIN seat s ON r.id = s.room_id 
			GROUP BY r.name, r.id) AS seat_counts_each_room
	)
	;
    
#12 Ngoai nhung seat mà Ong Dung booking duoc o booking id = 1 thi ong CÓ THỂ (CAN) booking duoc nhung seat nao khac khong?

    
#13.Show Film with total screening and order by total screening. BUT ONLY SHOW DATA OF FILM WITH TOTAL SCREENING > 10
SELECT 
	f.id,
    f.name,
    SUM(sr.film_id) AS total_screening
    
FROM film f 
JOIN screening sr ON f.id = sr.film_id

GROUP BY f.id, f.name
HAVING total_screening > 10
ORDER BY total_screening;

#14.TOP 3 DAY OF WEEK based on total booking
SELECT 
	DAYNAME(sr.start_time) AS days_of_week,
	COUNT(DISTINCT b.id) AS total_booking
FROM booking b
JOIN screening sr ON b.screening_id = sr.id
GROUP BY days_of_week
ORDER BY total_booking DESC
LIMIT 3;

#15.CALCULATE BOOKING rate over screening of each film ORDER BY RATES.
SELECT
    f.id AS film_id,
    f.name AS film_name,
    COUNT(DISTINCT b.id) AS num_bookings,
    COUNT(DISTINCT sr.id) AS num_screenings,
    COUNT(DISTINCT b.id) / COUNT(DISTINCT sr.id) AS booking_rate
    
FROM film f 
LEFT JOIN screening sr ON f.id = sr.film_id
LEFT JOIN booking b ON sr.id = b.screening_id

GROUP BY f.id, f.name
ORDER BY booking_rate DESC; 

#16.CONTINUE Q15 -> WHICH film has rate over average?
SELECT
    f.id AS film_id,
    f.name AS film_name,
    COUNT(DISTINCT b.id) / COUNT(DISTINCT sr.id) AS booking_rate
    
FROM film f
    LEFT JOIN screening sr ON f.id = sr.film_id
    LEFT JOIN booking b ON sr.id = b.screening_id
GROUP BY f.id, f.name

HAVING
    COUNT(DISTINCT b.id) / COUNT(DISTINCT sr.id) > (
        SELECT AVG(booking_rate)
        FROM (SELECT
                f.id AS film_id,
                f.name AS film_name,
                COUNT(DISTINCT b.id) / COUNT(DISTINCT sr.id) AS booking_rate
            FROM film f
                LEFT JOIN screening sr ON f.id = sr.film_id
                LEFT JOIN booking b ON sr.id = b.screening_id
            GROUP BY f.id, f.name) AS avg_rates
    );

#17.TOP 2 people who enjoy the least TIME (in minutes) in the cinema based on booking info - only count who has booking info (example : Dũng book film tom&jerry 4 times -> Dũng enjoy 90 mins x 4)



    
