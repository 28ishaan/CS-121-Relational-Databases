-- [Problem 1]
-- Calculates the minimum submit interval

DELIMITER !
CREATE FUNCTION min_submit_interval(
    s_id INT
) RETURNS INT DETERMINISTIC

BEGIN
    DECLARE min_interval        INT; 
    DECLARE temp_interval       INT; 
    DECLARE last_sub_time       TIMESTAMP; 
    DECLARE cur_sub_time        TIMESTAMP; 
    DECLARE done                INT DEFAULT 0; 
    
    DECLARE c CURSOR FOR SELECT sub_date FROM fileset
        WHERE sub_id = s_id
        ORDER BY sub_date;
        
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
    
    OPEN c;
        FETCH c INTO last_sub_time;
        WHILE NOT done DO FETCH c INTO cur_sub_time;
            IF NOT done THEN 
                SET temp_interval = 
                    UNIX_TIMESTAMP(cur_sub_time) - 
                    UNIX_TIMESTAMP(last_sub_time);
                IF temp_interval < min_interval THEN 
                    SET min_interval = temp_interval;
                ELSEIF ISNULL(min_interval) THEN
                    SET min_interval = temp_interval;
                END IF;
                SET last_sub_time = cur_sub_time;
            END IF;
        END WHILE;
    CLOSE c;
    
    RETURN min_interval;
END !
DELIMITER ;

-- [Problem 2]
-- Calculates the maximum submit interval

DELIMITER !
CREATE FUNCTION max_submit_interval(
    s_id INT
) RETURNS INT DETERMINISTIC

BEGIN
    DECLARE max_interval        INT; 
    DECLARE temp_interval       INT; 
    DECLARE last_sub_time       TIMESTAMP; 
    DECLARE cur_sub_time        TIMESTAMP; 
    DECLARE done                INT DEFAULT 0; 
    
    DECLARE c CURSOR FOR SELECT sub_date FROM fileset
        WHERE sub_id = s_id
        ORDER BY sub_date;
        
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
    
    OPEN c;
        FETCH c INTO last_sub_time;
        WHILE NOT done DO FETCH c INTO cur_sub_time;
            IF NOT done THEN 
                SET temp_interval = 
                    UNIX_TIMESTAMP(cur_sub_time) - 
                    UNIX_TIMESTAMP(last_sub_time);
                IF temp_interval > max_interval THEN 
                    SET max_interval = temp_interval;
                ELSEIF ISNULL(max_interval) THEN
                    SET max_interval = temp_interval;
                END IF;
                SET last_sub_time = cur_sub_time;
            END IF;
        END WHILE;
    CLOSE c;
    
    IF max_interval = -1
        THEN RETURN NULL;
    END IF;

    RETURN max_interval;
END !
DELIMITER ;

-- [Problem 3]
-- Calculates the average submit interval

DELIMITER !
CREATE FUNCTION avg_submit_interval(
    s_id int
) RETURNS DOUBLE DETERMINISTIC

BEGIN
    DECLARE avg_interval DOUBLE;
    SELECT (UNIX_TIMESTAMP(MAX(sub_date)) - 
            UNIX_TIMESTAMP(MIN(sub_date))) / (COUNT(*) - 1)
    INTO avg_interval
    FROM fileset
    WHERE sub_id = s_id;
    RETURN avg_interval;
END !
DELIMITER ;

-- [Problem 4]
-- Creates an index on fileset

CREATE INDEX idx_sub_id ON fileset (sub_id, sub_date);

