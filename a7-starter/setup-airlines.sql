-- [Problem 5]

DROP TABLE IF EXISTS flight_info;
DROP TABLE IF EXISTS ticket;
DROP TABLE IF EXISTS phone_numbers;
DROP TABLE IF EXISTS traveler;
DROP TABLE IF EXISTS purchaser;
DROP TABLE IF EXISTS purchase;
DROP TABLE IF EXISTS seat;
DROP TABLE IF EXISTS flight;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS airplane;


-- Creating table for `airplane`
CREATE TABLE airplane (
    aircraft_code VARCHAR(20) PRIMARY KEY,
    company VARCHAR(100),
    model VARCHAR(100)
);

-- Creating table for `flight`
CREATE TABLE flight (
    aircraft_code VARCHAR(20),
    flight_number VARCHAR(20),
    flight_date DATE,
    flight_time TIME,
    source VARCHAR(50),
    destination VARCHAR(50),
    domestic BOOLEAN,
    PRIMARY KEY (flight_number, flight_date),
    FOREIGN KEY (aircraft_code) REFERENCES airplane(aircraft_code)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Creating table for `seat`
CREATE TABLE seat (
    aircraft_code VARCHAR(20),
    seat_number VARCHAR(10),
    seat_class VARCHAR(50),
    seat_type VARCHAR(50),
    exit_row BOOLEAN,
    PRIMARY KEY (aircraft_code, seat_number),
    FOREIGN KEY (aircraft_code) REFERENCES airplane(aircraft_code)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Creating table for `customer`
CREATE TABLE customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(50),
    email VARCHAR(50)
);

-- Creating table for `purchase`
CREATE TABLE purchase (
    customer_id VARCHAR(20),
    purchase_id VARCHAR(20) PRIMARY KEY,
    purchase_time TIMESTAMP,
    confirmation VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Creating table for `ticket`
CREATE TABLE ticket (
    ticket_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    purchase_id VARCHAR(20),
    sale_price DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (purchase_id) REFERENCES purchase(purchase_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Creating table for `flight_info`
CREATE TABLE flight_info (
    seat_number VARCHAR(10),
    flight_number VARCHAR(20),
    flight_date DATE,
    ticket_id VARCHAR(20),
    aircraft_code VARCHAR(20),
    FOREIGN KEY (flight_number, flight_date) 
        REFERENCES flight(flight_number, flight_date)
            ON DELETE CASCADE 
            ON UPDATE CASCADE,
    FOREIGN KEY (aircraft_code) REFERENCES airplane(aircraft_code)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (aircraft_code, seat_number)
        REFERENCES seat(aircraft_code, seat_number)
            ON DELETE CASCADE 
            ON UPDATE CASCADE,
    UNIQUE (ticket_id)
);


-- Creating table for `phone_numbers`
CREATE TABLE phone_numbers (
    customer_id VARCHAR(20),
    phone_num VARCHAR(20),
    PRIMARY KEY (customer_id, phone_num),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- Creating table for `traveler`
CREATE TABLE traveler (
    customer_id VARCHAR(20),
    passport_number VARCHAR(20) PRIMARY KEY,
    citizenship VARCHAR(100),
    emergency_contact VARCHAR(100),
    emergency_phone VARCHAR(20),
    frequent_flyer_num VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Creating table for `purchaser`
CREATE TABLE purchaser (
    customer_id VARCHAR(20),
    card_number VARCHAR(20),
    exp_date DATE,
    ver_code VARCHAR(5),
    PRIMARY KEY (customer_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);


