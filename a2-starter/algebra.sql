-- [Problem 1]
SELECT DISTINCT A FROM r;

-- [Problem 2]
SELECT * FROM r WHERE B = 42;

-- [Problem 3]
SELECT * FROM r, s;

-- [Problem 4]
SELECT DISTINCT A, F FROM r, s ON C = D;

-- [Problem 5]
SELECT A, B, C FROM r1 UNION SELECT A, B, C FROM r2;

-- [Problem 6]
SELECT A, B, C FROM r1 INTERSECT SELECT A, B, C FROM r2;

-- [Problem 7]
SELECT A, B, C FROM r1 EXCEPT SELECT A, B, C FROM r2;

