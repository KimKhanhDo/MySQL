#Show film name ONLY which has screening.
SELECT DISTINCT film.name
FROM film JOIN screening ON film.id = screening.film_id;

#Show Room name with all seat row and seat column of "Room 2"
SELECT room.name,
	   seat.row,
       seat.number 
       
FROM seat JOIN room ON seat.room_id = room.id
WHERE room.name = "Room 2";

#Show all Screening Infomation including film name, room name, time of film "Tom&Jerry"
SELECT film.name,
	   room.name,
       screening.start_time
       
FROM film JOIN screening ON film.id = screening.film_id
JOIN room ON screening.room_id = room.id
WHERE film.name = "Tom&Jerry";

#Show what seat that customer "Dung Nguyen" booked
SELECT seat.row, seat.number
FROM reserved_seat JOIN booking ON reserved_seat.booking_id = booking.id
JOIN customer ON booking.customer_id = customer.id
JOIN seat ON reserved_seat.seat_id = seat.id
WHERE customer.first_name = 'Dung' AND customer.last_name = 'Nguyen';

#How many film that showed in 24/5/2022
SELECT COUNT(DISTINCT film.id) AS total_films
FROM film JOIN screening ON film.id = screening.film_id
WHERE DATE (screening.start_time) = '2022-05-24';

#What is the maximum length and minumum length of all film
SELECT MIN(length_min) AS min_length,
	   MAX(length_min) AS max_length
FROM film;

#How many seat of Room 7
SELECT COUNT(seat.id) AS total_seats
FROM seat JOIN room ON seat.room_id = room.id
WHERE room.name = "Room 7";

#Total seat are booked of film "Tom&Jerry"
SELECT
    COUNT(reserved_seat.id) AS total_seats_booked
FROM reserved_seat JOIN booking ON reserved_seat.booking_id = booking.id
JOIN screening ON booking.screening_id = screening.id
JOIN film ON screening.film_id = film.id
WHERE film.name = 'Tom&Jerry';