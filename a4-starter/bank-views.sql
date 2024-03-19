-- [Problem 1a]
-- creates a view containing the account numbers and 
-- customer names for all accounts at the Stonewell branch

CREATE VIEW stonewell_customers AS
    SELECT account_number, customer_name
    FROM depositor NATURAL JOIN account
    WHERE branch_name = 'Stonewell';

-- [Problem 1b]
-- creates a view containing the name, street, and city 
-- of all customers who have an account with the bank, 
-- but do not have a loan. This view is also updatable.

CREATE VIEW onlyacct_customers AS
    SELECT customer_name, customer_street, customer_city
    FROM customer
    WHERE customer_name IN (
        SELECT customer_name FROM depositor d
        WHERE NOT EXISTS (
            SELECT * FROM borrower b
            WHERE b.customer_name = d.customer_name));

-- [Problem 1c]
-- creates a view that lists all branches in the bank, 
-- along with the total account balance of each branch, 
-- and the average account balance of each branch.


CREATE VIEW branch_deposits AS
    SELECT b.branch_name, 
        IFNULL(SUM(a.balance), 0) AS total_balance, 
        AVG(a.balance) AS average_balance
    FROM branch b 
    LEFT JOIN account a ON b.branch_name = a.branch_name
    GROUP BY b.branch_name;



