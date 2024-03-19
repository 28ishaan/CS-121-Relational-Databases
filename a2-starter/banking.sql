-- [Problem 0a]
-- Using FLOAT or DOUBLE values introduces imprecise calculations. 
-- For example, calculations that require exact precision, like 
-- financial transactions, can accumulate rounding errors. 
-- Over time, these can become quite significant.

-- [Problem 0b]
-- account_number could be represented by a CHAR type instead of 
-- VARCHAR. Since we know that all the account numbers are of the 
-- same length, there is no need to have the name be of type VARCHAR.

-- [Problem 1a]
-- Retrieves loan numbers and amounts >= $1000 and <= $2000.
USE BANKING
SELECT loan_number, amount FROM loan 
WHERE amount >= 1000 AND amount <= 2000;

-- [Problem 1b]
-- Retrieves loan number and amount of all loans owned by Smith.
SELECT loan_number, amount FROM loan NATURAL JOIN borrower
WHERE customer_name = 'Smith'
ORDER BY loan_number;

-- [Problem 1c]
-- Retrieve the city of the branch where account A-446 is open.
SELECT branch_city from branch NATURAL JOIN account
WHERE account_number = 'A-446';

-- [Problem 1d]
-- Retrieve the customer name, account number, branch name, and 
-- balance of accounts owned by customers whose names start with “J”.
SELECT DISTINCT customer_name, account_number, branch_name, balance
FROM depositor NATURAL JOIN account
WHERE customer_name LIKE 'J%'
ORDER by customer_name;

-- [Problem 1e]
-- Retrieve the names of all customers with more than five bank accounts.
SELECT customer_name FROM depositor
GROUP BY customer_name
HAVING COUNT(account_number) > 5;

-- [Problem 2a]
-- Generate a list of all cities that customers live in, where there 
-- is no bank branch in that city
SELECT DISTINCT customer_city 
FROM customer LEFT JOIN branch ON customer_city = branch_city
WHERE branch.branch_city IS NULL
ORDER BY customer.customer_city ASC;

-- [Problem 2b]
-- Retrieves customers who have neither an account nor a loan.
SELECT customer_name FROM customer 
WHERE customer_name NOT IN (
    SELECT customer_name 
    FROM depositor
) AND customer_name NOT IN (
    SELECT customer_name 
    FROM borrower
);

-- [Problem 2c]
-- 75 gift-deposit into all accounts held at branches in the city of Horseneck.
UPDATE account 
SET balance = balance + 75
WHERE branch_name IN (
    SELECT branch_name FROM branch
    WHERE branch_city = 'Horseneck'
);

-- [Problem 2d]
-- 75 gift-deposit into all accounts held at branches in the city of Horseneck.
UPDATE branch b, account a
SET a.balance = a.balance + 75
WHERE b.branch_name = a.branch_name AND branch_city = 'Horseneck';

-- [Problem 2e]
-- Retrieve all details (account_number, branch_name, balance) 
-- for the largest account at each branch.
SELECT account_number, branch_name, balance 
FROM account NATURAL JOIN (
    SELECT branch_name, MAX(balance) AS max_balance
    FROM account GROUP BY branch_name
) AS max_balances;

-- [Problem 2f]
-- same query as in the previous problem, this time using an 
-- IN predicate with multiple columns.
SELECT account_number, branch_name, balance
FROM account WHERE (branch_name, balance) IN (
    SELECT branch_name, MAX(balance)
    FROM account
    GROUP BY branch_name
);

-- [Problem 3]
-- Orders branches by rank
SELECT branch_name, assets, COUNT(*) as `rank` FROM (
    SELECT b.branch_name, b.assets FROM branch b, branch a
    WHERE b.assets <= a.assets) AS ranks
GROUP BY branch_name, assets
ORDER BY `rank`, branch_name; 

