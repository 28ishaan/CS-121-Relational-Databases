-- [Problem 1a]
-- Given: Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a date value, returns 1 if it is a weekend, 0 if weekday
CREATE FUNCTION is_weekend (d DATE) RETURNS TINYINT DETERMINISTIC
BEGIN

-- DAYOFWEEK returns 7 for Saturday, 1 for Sunday
IF DAYOFWEEK(d) = 7 OR DAYOFWEEK(d) = 1
   THEN RETURN 1;
ELSE RETURN 0;
END IF;
END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 1b]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a date value, returns the name of the holiday if it's a holiday
-- or NULL if it's not a holiday
CREATE FUNCTION is_holiday(d DATE) RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
    -- New Year's Day
    IF MONTH(d) = 1 AND DAY(d) = 1 THEN 
        RETURN 'New Year''s Day';
    -- Memorial Day (last Monday of May)
    ELSEIF MONTH(d) = 5 AND DAYOFWEEK(d) = 2 AND DAY(d) > 24 THEN 
        RETURN 'Memorial Day';
    -- National Dog Day
    ELSEIF MONTH(d) = 8 AND DAY(d) = 26 THEN 
        RETURN 'National Dog Day';
    -- Labor Day (first Monday of September)
    ELSEIF MONTH(d) = 9 AND DAYOFWEEK(d) = 2 AND DAY(d) <= 7 THEN 
        RETURN 'Labor Day';
    -- Thanksgiving (fourth Thursday of November)
    ELSEIF MONTH(d) = 11 AND DAYOFWEEK(d) = 5 AND DAY(d) BETWEEN 22 AND 28 THEN 
        RETURN 'Thanksgiving';
    ELSE 
        RETURN NULL;
    END IF;
END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 2a]
-- query that reports how many filesets were submitted on 
-- the various holidays recognized by your is_holiday()

SELECT is_holiday(DATE(sub_date)) AS holiday, COUNT(*) AS num_submissions
FROM fileset
GROUP BY holiday;

-- [Problem 2b]
-- query that reports how many filesets were submitted on 
-- a weekend, and how many were not submitted on a weekend

SELECT (CASE
    WHEN is_weekend(DATE(sub_date)) = 1 THEN 'weekend'
    ELSE 'weekday'
END) AS submitted_on, COUNT(*) AS num_submissions
FROM fileset
GROUP BY submitted_on;

