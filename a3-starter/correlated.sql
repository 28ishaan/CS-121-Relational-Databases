-- [Problem 1a]
-- This query counts the number of loans that each customer has.
-- It then orders the count by descending order.
SELECT customer_name, COUNT(loan_number) AS loans
FROM customer NATURAL LEFT JOIN borrower
GROUP BY customer_name
ORDER BY loans DESC;


-- [Problem 1b]
-- This query finds the branches where the number of assets 
-- is less than the total sum of loans at that branch.
SELECT branch_name FROM (
    SELECT branch_name, SUM(amount) AS total_loan_amount, assets
    FROM branch NATURAL JOIN loan
    GROUP BY branch_name, assets) AS loan_totals
WHERE assets < total_loan_amount;


-- [Problem 1c]
-- Computes the number of accounts and the number of 
-- loans at each branch. 
SELECT branch_name,
    (SELECT COUNT(*) FROM account a
    WHERE b.branch_name = a.branch_name) AS num_accounts,
    (SELECT COUNT(*) FROM loan l
    WHERE b.branch_name = l.branch_name) AS num_loans
FROM branch b ORDER BY branch_name;

-- [Problem 1d]
-- Decorrelated query from (1c)
SELECT branch_name, 
    COUNT(DISTINCT account_number) AS num_accounts, 
    COUNT(DISTINCT loan_number) AS num_loans
FROM branch NATURAL LEFT JOIN account NATURAL LEFT JOIN loan
GROUP BY branch_name
ORDER BY branch_name;
