-- [Problem 0]
-- CS 121 24wi: Password Management (A6 and Final Project)

-- (Provided) This function generates a specified number 
-- of characters for using as a
-- salt in passwords.
DELIMITER !
CREATE FUNCTION make_salt(num_chars INT)
RETURNS VARCHAR(20) NOT DETERMINISTIC
BEGIN
    DECLARE salt VARCHAR(20) DEFAULT '';

    -- Don't want to generate more than 20 characters of salt.
    SET num_chars = LEAST(20, num_chars);

    -- Generate the salt!  Characters used are ASCII code 32 (space)
    -- through 126 ('z').
    WHILE num_chars > 0 DO
        SET salt = CONCAT(salt, CHAR(32 + FLOOR(RAND() * 95)));
        SET num_chars = num_chars - 1;
    END WHILE;

    RETURN salt;
END !
DELIMITER ;

-- Provided (you may modify in your FP if you choose)
-- This table holds information for authenticating users based on
-- a password.  Passwords are not stored plaintext so that they
-- cannot be used by people that shouldn't have them.
-- You may extend that table to include an is_admin or role attribute if you
-- have admin or other roles for users in your application
-- (e.g. store managers, data managers, etc.)

DROP TABLE IF EXISTS user_info;

CREATE TABLE user_info (
    -- Usernames are up to 20 characters.
    username VARCHAR(20) PRIMARY KEY,

    -- Salt will be 8 characters all the time, so we can make this 8.
    salt CHAR(8) NOT NULL,

    -- We use SHA-2 with 256-bit hashes.  MySQL returns the hash
    -- value as a hexadecimal string, which means that each byte is
    -- represented as 2 characters.  Thus, 256 / 8 * 2 = 64.
    -- We can use BINARY or CHAR here; BINARY simply has a different
    -- definition for comparison/sorting than CHAR.
    password_hash BINARY(64) NOT NULL
);

-- [Problem 1a]
-- Adds a new user to the user_info table, using the specified password (max
-- of 20 characters). Salts the password with a newly-generated salt value,
-- and then the salt and hash values are both stored in the table.

DROP PROCEDURE IF EXISTS sp_add_user;

DELIMITER !
CREATE PROCEDURE sp_add_user(new_username VARCHAR(20), password VARCHAR(20))
BEGIN
    DECLARE salt VARCHAR(8);
    DECLARE password_hash CHAR(64);
    SET salt = make_salt(8);
    SET password_hash = SHA2(CONCAT(password, salt), 256);

    INSERT INTO user_info
        VALUES(new_username, salt, password_hash);
END !
DELIMITER ;

-- [Problem 1b]
-- Authenticates the specified username and password against the data
-- in the user_info table.  Returns 1 if the user appears in the table, and the
-- specified password hashes to the value for the user. Otherwise returns 0.

DROP FUNCTION IF EXISTS authenticate;

DELIMITER !
CREATE FUNCTION authenticate(username VARCHAR(20), password VARCHAR(20))
RETURNS TINYINT DETERMINISTIC
BEGIN
    -- Variables to hold the user's salt and hashed password from the database
    DECLARE db_salt CHAR(28);
    DECLARE db_password_hash CHAR(64);
    DECLARE actual_pass CHAR(64);

    -- Select the salt and password hash from the database for 
    -- the given username
    SELECT salt, password_hash INTO db_salt, db_password_hash
    FROM user_info u
    WHERE u.username = username;

    -- If no user is found, return 0
    IF db_salt IS NULL THEN
        RETURN 0;
    END IF;

    SET actual_pass = SHA2(CONCAT(password, db_salt), 256);

    IF actual_pass = db_password_hash THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

END !
DELIMITER ;

-- [Problem 1c]
-- Add at least two users into your user_info table so that when 
-- we run this file,
-- we will have examples users in the database.

CALL sp_add_user('imantrip', 'zuko123');
CALL sp_add_user('lightningmcqueen', '95speed95');


-- [Problem 1d]
-- Create a procedure sp_change_password to generate a new salt 
-- and change the given
-- user's password to the given password (after salting and hashing)

DROP PROCEDURE IF EXISTS sp_change_password;

DELIMITER !
CREATE PROCEDURE sp_change_password(username VARCHAR(20), 
                                    new_password VARCHAR(20))
BEGIN

    DECLARE new_salt VARCHAR(8);
    DECLARE new_password_hash CHAR(64);
    SET new_salt = make_salt(8);

    SET new_password_hash = SHA2(CONCAT(new_password, new_salt), 256);
    UPDATE user_info
    SET salt = new_salt,
        password_hash = new_password_hash
    WHERE username = username;
END !
DELIMITER ;

