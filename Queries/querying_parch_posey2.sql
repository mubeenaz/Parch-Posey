-- This script is 2 of 2 which is used to answer various business questions to help Parch & Posey better understand its company data 


-- pull last 3 characters (extensions) of each accounts website & provide how many of each type 
SELECT RIGHT(website, 3) extension, COUNT(*)
FROM accounts 
GROUP BY 1;


-- find distribution of company names that begin with each letter or number 
SELECT LEFT(name, 1) first_char, COUNT(*)
FROM accounts 
GROUP BY 1
ORDER BY 2 DESC;


-- create columns that categorize company names starting with letter or number
-- what proportion of names start with a letter 
SELECT SUM(num) num_ct, SUM(letter) letter_ct
FROM (
	SELECT	name,
	CASE 
		WHEN LEFT(UPPER(name), 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 1 ELSE 0 END num,
	CASE
		WHEN LEFT(UPPER(name), 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 0 ELSE 1 END letter
FROM accounts
ORDER BY 1) t1;


-- proportion of company names that start with vowels and proportion that start with anything else 
SELECT SUM(vowel) vowel_ct, SUM(not_vowel) not_vowel_ct
FROM (
	SELECT	name,
	CASE
		WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 1 ELSE 0 END vowel, 
	CASE
        WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 0 ELSE 1 END not_vowel
FROM accounts) t1;
/* 23% vowel : 77% not vowel */


-- create first and last name columns for primary_poc 
SELECT 	primary_poc, 
	LEFT(primary_poc, (LOCATE(' ', primary_poc))-1) first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - LOCATE(' ', primary_poc)) last_name
FROM accounts;

	# UPDATE primary_poc column to remove all newline characters (\n) & replace with spaces 
    # SET safe_updates mode OFF 
    SHOW VARIABLES LIKE '%update%';
    SET sql_safe_updates = 0;
	SHOW VARIABLES LIKE '%update%';

	UPDATE accounts SET primary_poc = REPLACE(primary_poc, '\n', ' ')
	WHERE LOCATE(' ', primary_poc) = 0;

-- run previous query again
SELECT 	primary_poc, 
	LEFT(primary_poc, (LOCATE(' ', primary_poc))-1) first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - LOCATE(' ', primary_poc)) last_name
FROM accounts;											

		
-- create first and last name columns for reps 
SELECT	name, 
	LEFT(name, (LOCATE(' ', name)) - 1) first_name,
	RIGHT(name, LENGTH(name) - LOCATE(' ', name)) last_name
FROM sales_reps;


-- create email for each primary_poc 
WITH t1 AS (SELECT primary_poc, name,
	LEFT(primary_poc, (LOCATE(' ', primary_poc))-1) first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - LOCATE(' ', primary_poc)) last_name
FROM accounts)

SELECT 	primary_poc, name,
	LOWER(CONCAT(first_name, '.', last_name, '@', name, '.com')) email_address
FROM t1;


-- remove spaces from previous solution 
WITH t1 AS (SELECT primary_poc, name,
	LEFT(primary_poc, (LOCATE(' ', primary_poc))-1) first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - LOCATE(' ', primary_poc)) last_name
FROM accounts)

SELECT primary_poc,name,
	LOWER(CONCAT(first_name, '.', last_name, '@', REPLACE(name,' ',''), '.com')) email_address
FROM t1;

	# same spacing problem as primary_poc column for name column here
	# UPDATE name column to remove all newline characters (\n) & replace with spaces 
	# safe_updates already set OFF. just update directly 
    UPDATE accounts SET name = REPLACE(name, '\n', ' ')
    WHERE LOCATE('\n', name) != 0;
    
-- run previous query again 
WITH t1 AS (SELECT primary_poc, name,
	LEFT(primary_poc, (LOCATE(' ', primary_poc))-1) first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - LOCATE(' ', primary_poc)) last_name
FROM accounts)

SELECT 	primary_poc,name,
	LOWER(CONCAT(first_name, '.', last_name, '@', REPLACE(name,' ',''), '.com')) email_address
FROM t1;


	# SET safe_updates mode back to ON
    SET sql_safe_updates = 1;
    SHOW VARIABLES LIKE '%update%';


-- create initial password for all primary_poc's 
WITH t1 AS (SELECT primary_poc, name,
	LEFT(primary_poc, (LOCATE(' ', primary_poc))-1) first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - LOCATE(' ', primary_poc)) last_name
FROM accounts)

SELECT 	first_name, 
	last_name, 
	name,
	CONCAT(LOWER(LEFT(first_name, 1)), LOWER(RIGHT(first_name, 1)), LOWER(LEFT(last_name, 1)), LOWER(RIGHT(last_name, 1)), 
	LENGTH(first_name), LENGTH(last_name), UPPER(REPLACE(name, ' ', ''))) initial_password
	FROM t1;


-- convert to date data type         
SELECT	SUBSTR(date, 7, 4) yyyy,
	SUBSTR(date, 4, 2) dd, 
	SUBSTR(date, 1, 2) mm,
	CONCAT(SUBSTR(date, 7, 4), '-',  SUBSTR(date, 1, 2), '-', SUBSTR(date, 4, 2)) yyyy_mm_dd, 
	CONVERT(CONCAT(SUBSTR(date, 7, 4), '-',  SUBSTR(date, 1, 2), '-', SUBSTR(date, 4, 2)), date) yyyy_mm_dd		             
FROM sf_crime_data
LIMIT 5;


-- create running total of standard_amt_usd over order time 
SELECT	standard_amt_usd, 
	SUM(standard_amt_usd) OVER (ORDER BY occurred_at) std_amt_running_total
FROM orders;


-- create running total of standard_amt_usd over order time, but partitioned by year 
SELECT	standard_amt_usd, 
	occurred_at, 
	EXTRACT(YEAR FROM occurred_at) YYYY,
	SUM(standard_amt_usd) OVER (PARTITION BY EXTRACT(YEAR FROM occurred_at) ORDER BY occurred_at) std_amt_running_total
FROM orders;


-- create total_rank column which ranks total amt of paper ordered for each acct 
SELECT	id, 
	account_id, 
	total, 
	DENSE_RANK() OVER (PARTITION BY account_id ORDER BY total DESC) total_rank
FROM orders;


-- create running total of standard_amt_usd over order time 
SELECT	standard_amt_usd, 
	SUM(standard_amt_usd) OVER (ORDER BY occurred_at) std_amt_running_total
FROM orders;


-- create running total of standard_amt_usd over order time, but partitioned by year 
SELECT	standard_amt_usd, 
	occurred_at, 
	EXTRACT(YEAR FROM occurred_at) YYYY,
	SUM(standard_amt_usd) OVER (PARTITION BY EXTRACT(YEAR FROM occurred_at) ORDER BY occurred_at) std_amt_running_total
FROM orders;


-- create total_rank column which ranks total amt of paper ordered for each acct 
SELECT	id, 
	account_id, 
	total, 
	DENSE_RANK() OVER (PARTITION BY account_id ORDER BY total DESC) total_rank
FROM orders;


-- create and use alias to shorten following query 
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dens_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders;

SELECT id,
       account_id,
       EXTRACT(YEAR FROM occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY EXTRACT(YEAR FROM occurred_at)) AS dens_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY EXTRACT(YEAR FROM occurred_at));


-- find how current order's total revenue compares to next order's total revenue 
SELECT	occurred_at, 
	total_amt_usd, 
	LEAD (total_amt_usd) OVER date_time AS next_order, 
	LEAD (total_amt_usd) OVER date_time - total_amt_usd AS lead_difference
FROM orders
WINDOW date_time AS (ORDER BY occurred_at);


-- divide accts into quartiles based on standard_qty 
SELECT 	account_id, 
	occurred_at, 
	standard_qty,
	NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) standard_tile
FROM orders;


-- divide accts into two levels based on gloss_qty 
SELECT 	account_id, 
	occurred_at, 
	gloss_qty,
	NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) gloss_half
FROM orders
ORDER BY 1 DESC;


-- divide orders for each acct into 100 levels based on total_amt_usd 
SELECT 	account_id, 
	occurred_at, 
	total_amt_usd,
	NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) total_percentile
FROM orders;

    
-- use UNION ALL on two instances of accounts table 
SELECT *
FROM accounts 

UNION ALL

SELECT *
FROM accounts;


-- pretreat previous query before doing UNION 
SELECT *
FROM accounts 
WHERE name = 'Walmart'

UNION ALL

SELECT *
FROM accounts
WHERE name = 'Disney';


-- perform operation on combined (UNIONed) dataset 
WITH double_accounts AS (SELECT *
FROM accounts 

UNION ALL

SELECT *
FROM accounts)

SELECT name, COUNT(*) name_count
FROM double_accounts 
GROUP BY 1;

