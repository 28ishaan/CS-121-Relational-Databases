-- [Problem 2a]
-- INSERT statements

-- Inserting into person
INSERT INTO person (driver_id, name, address)
VALUES
    ('1234567890', 'Ishaan Mantripragada', '223 Fleming House'),
    ('0987654321', 'Peter Parker', '99 Spider Way'),
    ('1112223334', 'Lightning McQueen', '95 Radiator Springs');

-- Inserting into car with some NULL values
INSERT INTO car (license, model, year)
VALUES
    ('ABC1234', 'Sedan', 2018),
    ('XYZ5678', 'Coupe', NULL),
    ('LMN2345', NULL, 2020);

-- Inserting into accident
INSERT INTO accident (date_occurred, location, summary)
VALUES
    ('2024-2-3 09:00:00', 
    'Highway 101 Southbound', 
    'Blind spot collision.'),
    ('2023-5-9 10:05:37', 
    'McDonalds Parking Lot', 
    'Read end collision at parking lot.'),
    ('2020-8-17 2:00:24', 
    '501 W Spring St.', 
    'Flat tire.');

-- Inserting into owns
INSERT INTO owns (driver_id, license)
VALUES
    ('1234567890', 'ABC1234'),
    ('0987654321', 'XYZ5678'),
    ('1112223334', 'LMN2345');

-- Inserting into participated
INSERT INTO participated (driver_id, license, damage_amount)
VALUES
    ('1234567890', 'ABC1234', 5000.00),
    ('0987654321', 'XYZ5678', 7500.00),
    ('1112223334', 'LMN2345', 3000.00);

-- [Problem 2b]
-- UPDATE statements

-- Updating person (cascade update will affect owns)
UPDATE person
    SET name = 'Johnathan Doe'
    WHERE driver_id = '1234567890';
-- Updating car (cascade update will affect owns)
UPDATE car
    SET model = 'SUV'
    WHERE license = 'ABC1234';

-- [Problem 2c]
-- 1 DELETE statement, as a comment

-- This DELETE statement would cause an error because of the 
-- RESTRICT on delete for participated
-- DELETE FROM car WHERE license = 'ABC1234';
