-- [Problem 1a]
-- Finds the names of all students who have taken at least 
-- one Comp. Sci. course.
USE UNIVERSITY;
SELECT DISTINCT name from student
    JOIN takes ON student.ID = takes.ID
    JOIN course ON takes.course_id = course.course_id
WHERE course.dept_name = 'Comp. Sci.';

-- [Problem 1b]
-- Finds the maximum salary of instructors in that department.
SELECT dept_name, MAX(salary) AS max_sal FROM instructor
    GROUP BY dept_name; 

-- [Problem 1c]
-- Finds the lowest max salary across all departments.
SELECT MIN(max_sal) as smallest_max_salary FROM (
    SELECT dept_name, MAX(salary) AS max_sal FROM instructor
    GROUP BY dept_name)
AS smallest_max_salary;

-- [Problem 1d]
-- (1c) with a temporary table.
CREATE TEMPORARY TABLE memb_counts AS
    SELECT dept_name, MAX(salary) AS max_salary
    FROM instructor
    GROUP BY dept_name;
SELECT MIN(max_salary) AS smallest_max_salary
FROM memb_counts;

-- [Problem 2a]
-- Inserts a new course.
INSERT INTO course
    VALUES ('CS-001', 'Weekly Seminar', 'Comp. Sci.', 0);

-- [Problem 2b]
-- Creates a section of the course.
INSERT INTO section
    VALUES ('CS-001', 1, 'Winter', 2023, NULL, NULL, NULL);

-- [Problem 2c]
-- Enrolls every student in the Comp. Sci. department into the 
-- above section.
INSERT INTO takes (ID, course_ID, sec_id, semester, year, grade)
    SELECT ID, 'CS-001' as course_ID, 1 as sec_id, 'Winter', 2023, NULL
    FROM student WHERE dept_name = 'Comp. Sci.';

-- [Problem 2d]
-- Deletes enrollments in the above sections where the 
-- student's name is Snow.
DELETE FROM takes
WHERE (ID, course_id, sec_id, semester, year) IN (
    SELECT ID, 'CS-001', 1, 'Winter', 2023 FROM student
    WHERE name = 'Snow');

-- [Problem 2e]
DELETE FROM course WHERE course_id = 'CS-001';
-- Running this delete statement without first deleting sections 
-- causes those sections to also get deleted. This is because 
-- course_id is a goreign key that refereces course_id in course. 
-- Therefore, when it is deleted, the sections will also be deleted.

-- [Problem 2f]
-- Deletes all takes tuples corresponding to any section of any 
-- course with the word 'database'.
DELETE FROM takes WHERE course_id = (
    SELECT course_id FROM course 
    WHERE LOWER(title) LIKE '%database%');

-- [Problem 3a]
-- Retrieves names of members who have borrowed any book published 
-- by McGraw-Hill.
USE LIBRARY;
SELECT DISTINCT name FROM member 
    NATURAL JOIN borrowed NATURAL JOIN book
    WHERE publisher = 'McGraw-Hill'
    ORDER BY name ASC;

-- [Problem 3b]
-- Retrieve the names of members who have borrowed all books published 
-- by McGraw-Hill.
SELECT DISTINCT name FROM member NATURAL JOIN borrowed NATURAL JOIN book
WHERE publisher = 'McGraw-Hill'
GROUP BY name
HAVING count(isbn) = (
    SELECT count(isbn) FROM book WHERE publisher = 'McGraw-Hill')
    ORDER BY name ASC;

-- [Problem 3c]
-- retrieve the names of members who have borrowed more than five 
-- books from a given publisher.
SELECT publisher, name FROM member NATURAL JOIN borrowed NATURAL JOIN book
GROUP BY publisher, name HAVING COUNT(*) > 5
ORDER BY name ASC;

-- [Problem 3d]
-- Computes the average number of books borrowed across all members.
SELECT AVG(book_count) AS avg_num_books
FROM (
    SELECT m.memb_no, COUNT(b.isbn) AS book_count
    FROM member m
    LEFT JOIN borrowed b ON m.memb_no = b.memb_no
    GROUP BY m.memb_no
) as member_book_counts;

-- [Problem 3e]
-- Rewrite your answer for part d using a temporary table for 
-- the query.
CREATE TEMPORARY TABLE memb_book_counts AS
    SELECT m.memb_no, COUNT(b.isbn) AS book_count
    FROM member m
    LEFT JOIN borrowed b ON m.memb_no = b.memb_no
    GROUP BY m.memb_no;
SELECT AVG(book_count) as avg_num_books
FROM memb_book_counts;