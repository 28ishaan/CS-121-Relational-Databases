-- [Problem 1a]
-- Compute what would be a “perfect score” in the course.

SELECT SUM(perfectscore) AS total_perfect_score
FROM assignment;

-- [Problem 1b]
-- lists every section’s name, and how 
-- many students are in that section.

SELECT sec_name, COUNT(username) AS number_of_students
FROM student NATURAL JOIN section
GROUP BY sec_name
ORDER BY sec_name ASC;

-- [Problem 1c]
-- Create a view named score_totals, which computes 
-- each student’s total score over all assignments 
-- in the course.

CREATE VIEW score_totals AS
    SELECT username, SUM(score) AS total_score
    FROM student NATURAL LEFT JOIN submission
    WHERE graded = 1
    GROUP BY username;

-- [Problem 1d]
-- Creates a view called passing which lists the 
-- usernames and scores of all students that are passing.

CREATE VIEW passing AS
    SELECT username, total_score
    FROM score_totals
    WHERE total_score >= 40
    ORDER BY total_score DESC, username ASC;


-- [Problem 1e]
-- Creates a view called failing which lists the 
-- usernames and scores of all students that are failing.

CREATE VIEW failing AS
    SELECT username, total_score
    FROM score_totals
    WHERE total_score < 40
    ORDER BY total_score DESC, username ASC;

-- [Problem 1f]
-- lists the usernames of all students that failed 
-- to submit work for at least one lab assignment, 
-- but still managed to pass the course.

-- result:
--    +----------+
--    | username |
--    +----------+
--    | harris   |
--    | ross     |
--    | miller   |
--    | turner   |
--    | edwards  |
--    | murphy   |
--    | simmons  |
--    | tucker   |
--    | coleman  |
--    | flores   |
--    | gibson   |
--    +----------+


WITH no_labs AS (
    SELECT username, sub_id 
    FROM submission NATURAL LEFT JOIN assignment
    WHERE shortname LIKE 'lab%')
SELECT DISTINCT username FROM no_labs
WHERE 
    username IN (SELECT username FROM passing) AND
    sub_id NOT IN (SELECT sub_id FROM fileset);


-- [Problem 1g]
-- updates and reruns the earlier query to list any students 
-- that failed to submit either the midterm or the final, 
-- yet still managed to pass the course.

-- result:
--     +----------+
--     | username |
--     +----------+
--     | collins  |
--     +----------+

WITH no_midfinal AS (
    SELECT username, sub_id 
    FROM submission NATURAL LEFT JOIN assignment
    WHERE shortname LIKE 'final%' OR shortname LIKE 'midterm%')
SELECT DISTINCT username FROM no_midfinal
WHERE 
    username IN (SELECT username FROM passing) AND
    sub_id NOT IN (SELECT sub_id FROM fileset);

-- [Problem 2a]
-- query that reports the usernames of all students 
-- that submitted work for the midterm after the due date. 

SELECT DISTINCT username
FROM assignment NATURAL JOIN submission NATURAL JOIN fileset
WHERE shortname = 'midterm' AND sub_date > due
ORDER BY username;

-- [Problem 2b]
-- query that reports, for each hour in the day, how many lab 
-- assignments are submitted in that hour.

SELECT EXTRACT(HOUR FROM sub_date) AS hour, COUNT(*) AS num_submits
FROM assignment NATURAL JOIN submission NATURAL JOIN fileset
WHERE shortname LIKE 'lab%'
GROUP BY EXTRACT(HOUR FROM sub_date)
ORDER BY hour;

-- [Problem 2c]
-- query that reports the total number of final exams that were 
-- submitted in the 30 minutes before the final exam due date.

SELECT COUNT(*) as num_exams
FROM assignment NATURAL JOIN submission NATURAL JOIN fileset
WHERE 
    shortname = 'final' AND
    sub_date BETWEEN (due - INTERVAL 30 MINUTE) AND due;

-- [Problem 3a]
-- Adds a column named email to the student table.

ALTER TABLE student ADD COLUMN email VARCHAR(200);
UPDATE student SET email = CONCAT(username, '@school.edu');
ALTER TABLE student MODIFY email VARCHAR(200) NOT NULL;

-- [Problem 3b]
-- Add a column named submit_files to the assignment table.

ALTER TABLE assignment
    ADD submit_files TINYINT DEFAULT 1; 
UPDATE assignment
    SET submit_files = 0
    WHERE shortname LIKE 'dq%';

-- [Problem 3c]
-- Create a new table gradescheme with a scheme_id columns and
-- a scheme_desc column.

CREATE TABLE gradescheme (
    scheme_id   INT(10),
    scheme_desc VARCHAR(100) NOT NULL,
    PRIMARY KEY (scheme_id)
);

INSERT INTO gradescheme
VALUES 
    (0, 'Lab assignment with min-grading.'),
    (1, 'Daily quiz.'),
    (2, 'Midterm or final exam.');

ALTER TABLE assignment
    RENAME COLUMN gradescheme TO scheme_id;

ALTER TABLE assignment    
    MODIFY scheme_id INT(10) NOT NULL;
    
ALTER TABLE assignment
    ADD FOREIGN KEY (scheme_id) REFERENCES gradescheme(scheme_id);