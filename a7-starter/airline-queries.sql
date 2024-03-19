-- [Problem 6a]
-- query that will retrieve all purchases and associated ticket information
-- for the customer (aka “purchaser”) with ID 54321

SELECT p.purchase_id, p.purchase_time, t.sale_price 
    AS ticket_price, c.last_name, c.first_name, f.flight_date
FROM purchase p
JOIN customer c ON p.customer_id = c.customer_id
JOIN ticket t ON p.purchase_id = t.purchase_id
JOIN flight_info fi ON t.ticket_id = fi.ticket_id
JOIN flight f ON fi.flight_number = f.flight_number 
    AND fi.flight_date = f.flight_date
WHERE p.customer_id = '54321'
ORDER BY p.purchase_time DESC, f.flight_date, c.last_name, c.first_name;

-- [Problem 6b]
-- query that reports the total revenue from ticket sales for each 
-- kind of airplane in our flight booking database, generated from 
-- flights with a departure time within the last two weeks

SELECT a.aircraft_code, IFNULL(airplane_info.rev, 0) AS total_revenue
FROM airplane a
LEFT JOIN (
    SELECT f.aircraft_code, SUM(t.sale_price) AS rev
    FROM flight f
    JOIN flight_info fi ON f.flight_number = fi.flight_number 
        AND f.flight_date = fi.flight_date
    JOIN ticket t ON fi.ticket_id = t.ticket_id
    WHERE TIMESTAMP(f.flight_date, f.flight_time) 
        BETWEEN (NOW() - INTERVAL '2 WEEK') AND NOW()
    GROUP BY f.aircraft_code
) AS airplane_info ON a.aircraft_code = airplane_info.aircraft_code;


-- [Problem 6c]
-- query that reports all travelers on international flights that have not yet 
-- specified all of their international flight information

SELECT first_name, last_name, customer_id
FROM customers NATURAL LEFT JOIN ticket NATURAL LEFT JOIN 
    flight NATURAL LEFT JOIN traveler
WHERE domestic = FALSE AND (
    ISNULL(passport_number) OR 
    ISNULL(citizenship) OR 
    ISNULL(emergency_contact) OR 
    ISNULL(emergency_phone)
);