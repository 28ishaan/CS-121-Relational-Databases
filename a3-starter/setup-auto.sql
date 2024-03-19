DROP TABLE IF EXISTS participated, owns;
DROP TABLE IF EXISTS person, car, accident;

CREATE TABLE person (
    -- driver_id (exactly 10 chars).
    driver_id CHAR(10) NOT NULL,
    -- driver name (30 char limit).
    name VARCHAR(30) NOT NULL,
    -- address of the driver (255 char limit).
    address VARCHAR(255) NOT NULL,
    PRIMARY KEY (driver_id)
);

CREATE TABLE car (
    -- license (exactly 7 chars).
    license CHAR(7) NOT NULL,
    -- car model (255 char limit).
    model VARCHAR(255) NULL,
    -- car year (year type).
    year YEAR NULL,
    PRIMARY KEY (license)
);

CREATE TABLE accident (
    -- report_number (auto-incrementing integer).
    report_number INT NOT NULL AUTO_INCREMENT,
    -- data_occured stores both date and time values.
    date_occurred TIMESTAMP NOT NULL,
    -- location is an address/intersection (few hundred chars).
    location VARCHAR(255) NOT NULL,
    -- summary is for an accident report (several thousand chars).
    summary TEXT(3000),
    PRIMARY KEY (report_number)
);

-- owns table supports cascaded updates and deletes.
CREATE TABLE owns (
    -- driver_id (exactly 10 chars).
    driver_id CHAR(10) NOT NULL,
    -- license (exactly 7 chars).
    license CHAR(7) NOT NULL,
    PRIMARY KEY (driver_id, license),
    FOREIGN KEY (driver_id) 
        REFERENCES person(driver_id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
    FOREIGN KEY (license)
        REFERENCES car(license)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- participated table only supports cascaded updates.
CREATE TABLE participated (
    -- driver_id (exactly 10 chars).
    driver_id CHAR(10) NOT NULL,
    -- license (exactly 7 chars).
    license CHAR(7) NOT NULL,
    -- report_number (auto-incrementing integer).
    report_number INT NOT NULL,
    -- damage_amount is a monetary value < 1,000,000
    damage_amount DECIMAL(10, 2) NULL,
    PRIMARY KEY (driver_id, license, report_number),
    FOREIGN KEY (driver_id)
        REFERENCES person(driver_id)
            ON UPDATE CASCADE,
    FOREIGN KEY (license)
        REFERENCES car(license)
            ON UPDATE CASCADE,
    FOREIGN KEY (report_number)
        REFERENCES accident(report_number)
            ON UPDATE CASCADE
);
