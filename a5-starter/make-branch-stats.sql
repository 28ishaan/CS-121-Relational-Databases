-- [Problem 1]
-- Index definition

CREATE INDEX account_index ON account (branch_name, balance);

-- [Problem 2]
-- Table definition for the materialized results 
-- mv_branch_account_stats

CREATE TABLE mv_branch_account_stats (
    branch_name     VARCHAR(15) NOT NULL PRIMARY KEY,
    num_accounts    INT NOT NULL,
    total_deposits  NUMERIC(12, 2) NOT NULL,
    min_balance     NUMERIC(12, 2) NOT NULL,
    max_balance     NUMERIC(12, 2) NOT NULL
);

-- [Problem 3]
-- SQL DML statement to populate  mv_branch_account_stats

INSERT INTO mv_branch_account_stats
    SELECT branch_name,
        COUNT(*) AS num_accounts,
        SUM(balance) AS total_deposits,
        MIN(balance) AS min_balance,
        MAX(balance) AS max_balance
    FROM account GROUP BY branch_name;

-- [Problem 4]
-- View definition for branch_account_stats

CREATE VIEW branch_account_stats AS
    SELECT branch_name,
        num_accounts,
        total_deposits,
        (total_deposits / num_accounts) AS avg_balance,
        min_balance,
        max_balance
    FROM mv_branch_account_stats;

-- [Problem 5]
-- Provided solution for Problem 5
DELIMITER !

-- A procedure to execute when inserting a new branch name and balance
-- to the bank account stats materialized view (mv_branch_account_stats).
-- If a branch is already in view, its current balance is updated
-- to account for total deposits and adjusted min/max balances.
CREATE PROCEDURE sp_branchstat_newacct(
    new_branch_name VARCHAR(15),
    new_balance NUMERIC(12, 2)
)
BEGIN 
    INSERT INTO mv_branch_account_stats 
        -- branch not already in view; add row
        VALUES (new_branch_name, 1, new_balance, new_balance, new_balance)
    ON DUPLICATE KEY UPDATE 
        -- branch already in view; update existing row
        num_accounts = num_accounts + 1,
        total_deposits = total_deposits + new_balance,
        min_balance = LEAST(min_balance, new_balance),
        max_balance = GREATEST(max_balance, new_balance);
END !

-- Handles new rows added to account table, updates stats accordingly
CREATE TRIGGER trg_account_insert AFTER INSERT
       ON account FOR EACH ROW
BEGIN
      -- Example of calling our helper procedure, 
      -- passing in the new row's information
    CALL sp_branchstat_newacct(NEW.branch_name, NEW.balance);
END !
DELIMITER ;


-- [Problem 6]
-- Trigger to handle deletes

DELIMITER !
CREATE PROCEDURE sp_branchstat_delacct(
    deleted_branch VARCHAR(15),
    deleted_balance NUMERIC(12, 2)
) 
BEGIN
    DECLARE current INTEGER;
    DECLARE curr_minimum, curr_maximum NUMERIC(12, 2);
    
    SELECT COUNT(*), MIN(balance), MAX(balance)
        INTO current, curr_minimum, curr_maximum
    FROM account 
        WHERE branch_name = deleted_branch;
    IF current = 0 THEN
        DELETE FROM mv_branch_account_stats
        WHERE branch_name = deleted_branch;
    ELSE
        UPDATE mv_branch_account_stats SET
            num_accounts = num_accounts - 1,
            total_deposits = total_deposits - deleted_balance,
            min_balance = curr_minimum,
            max_balance = curr_maximum
        WHERE branch_name = deleted_branch;
    END IF;
END !


CREATE TRIGGER trg_delete AFTER DELETE
    ON account FOR EACH ROW
BEGIN
    CALL sp_branchstat_delacct(OLD.branch_name, OLD.balance);
END !
DELIMITER ;

-- [Problem 7]

