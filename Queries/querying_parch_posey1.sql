/* This script is 1 of 2 which is used to answer various business questions to help Parch & Posey better understand its company data */


-- Sample web_events table 
SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;


-- 10 earliest orders 
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY 2
LIMIT 10;


-- top 5 orders 
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY 3 DESC 
LIMIT 5;


-- lowest 2 orders 
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY 3
LIMIT 20;


-- sorting practice 
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY 2, 3 DESC;


-- reverse of previous query 
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY 3 DESC, 2;
/* switching columns sorted on first made the account_id irrelevant in this query because it was only
concerned with the highest dollar amt. Previous query grouped account_id first, then by highest amt within each 
account. Highest dollar amt. isn't necessarily going to come from the same account_id consecutively */


-- 1st five rows with gloss_amt_usd >= 1000 
SELECT*
FROM orders 
WHERE gloss_amt_usd >= 1000
LIMIT 5;


-- 1st 10 rows with total_amt_usd < 500 
SELECT* 
FROM orders 
WHERE total_amt_usd < 500
LIMIT 10; 


-- filter accounts table to include only Exxon Mobile  
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';
-- issue with retrieving data  


-- unit price for standard paper for each order 
SELECT id, account_id, (standard_amt_usd/standard_qty) standard_unit_price
FROM orders
LIMIT 10;


-- percentage of sales from poster paper for each order 
SELECT id, account_id, (poster_amt_usd/(standard_amt_usd+gloss_amt_usd+poster_amt_usd))*100 percent_poster 
FROM orders
ORDER BY 3 DESC;


-- all companies whose names start with C 
SELECT* 
FROM accounts
WHERE name LIKE 'C%';


-- all companies whose names contain 'one' 
SELECT*
FROM accounts
WHERE name LIKE BINARY '%one%';


-- all companies whose names end with s 
SELECT*
FROM accounts 
WHERE name LIKE BINARY '%s';


-- find info for Walmart, Target, & Nordstrom 
SELECT name, primary_poc, sales_rep_id
FROM accounts 
WHERE name IN ('Walmart', 'Target', 'Nordstrom');


-- find all info regarding individuals contacted via organic or adwords 
SELECT*
FROM web_events
WHERE channel IN ('organic', 'adwords');


-- find info for all stores EXCEPT Walmart, Target, & Nordstrom 
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');


-- find all info regarding individuals contacted via any method EXCEPT organic or adwords 
SELECT*
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');


-- all companies whose names don't start with C 
SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';


-- all companies whose names dont contain 'one' somewhere in name 
SELECT *
FROM accounts 
WHERE name NOT LIKE BINARY '%one%';


-- all companies whose names dont end with s 
SELECT *
FROM accounts 
WHERE name NOT LIKE BINARY '%s';


-- standard_qty>1000, poster_qty=0, gloss_qty=0 
SELECT*
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;


-- companies whose names DONT start with C and end with s 
SELECT*
FROM accounts 
WHERE name NOT LIKE BINARY 'C%' AND name LIKE BINARY '%s';


-- all orders where gloss_qty between 24 and 29 
SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY 1;


-- all information regarding individuals contacted via organic or adwords, and started acct at any point in 2016 
SELECT * 
FROM web_events
WHERE channel IN ('organic', 'adwords') AND YEAR(occurred_at) = 2016
ORDER BY occurred_at DESC;


-- orders where gloss_qty OR poster_qty > 4000 
SELECT* 
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;


-- orders where standard_qty = 0 AND gloss_qty OR poster_qty > 1000 
SELECT*
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);


-- all company names that start with C OR W, AND primary contact contains 'ana' OR 'Ana', but doesn't contain 'eana' 
SELECT *
FROM accounts 
WHERE (name LIKE 'C%' OR name LIKE 'W%') AND ((primary_poc LIKE BINARY '%ana%' OR primary_poc LIKE BINARY '%Ana%') AND primary_poc NOT LIKE BINARY 'eana');


-- all web_events associated with Walmart 
SELECT a.name, a.primary_poc, w.occurred_at, w.channel
	FROM web_events w
    JOIN accounts a 
		ON w.account_id = a.id
	WHERE name = 'Walmart';


-- region for each sales_rep along with their associated accounts 
SELECT r.name region, s.name sales_rep, a.name account 
	FROM region r
    JOIN sales_reps s
		ON r.id = s.region_id 
	JOIN accounts a
		ON s.id = a.sales_rep_id
	ORDER BY 3;
    
    
-- name of region for every order, as well as acct name and unit price paid for each order 
SELECT r.name region, a.name account, o.total_amt_usd/o.total unit_price
	FROM region r
    JOIN sales_reps s
		ON r.id = s.region_id
	JOIN accounts a
		ON s.id = a.sales_rep_id
	JOIN orders o
		ON a.id = o.account_id;	 
        
        
-- region for each sales_rep along with associated accts (only for Midwest region) 
SELECT r.name region, s.name sales_rep, a.name account 
	FROM region r
    JOIN sales_reps s
		ON r.id = s.region_id
	JOIN accounts a
		ON s.id = a.sales_rep_id
	WHERE r.name = 'Midwest' 
    ORDER BY 3;


-- region for each sales_rep along with associated accts, WHERE sales_rep first name starts with S and in Midwest 
SELECT r.name region, s.name sales_rep, a.name account
	FROM region r
    JOIN sales_reps s
		ON r.id = s.region_id
	JOIN accounts a
		ON s.id = a.sales_rep_id
	WHERE r.name = 'Midwest' AND s.name LIKE BINARY 'S%'
    ORDER BY 3;


-- region for each sales_rep along with associated accts, WHERE sales_rep last name starts with K and in Midwest 
SELECT r.name region, s.name sales_rep, a.name account
	FROM region r
    JOIN sales_reps s
		ON r.id = s.region_id
	JOIN accounts a
		ON s.id = a.sales_rep_id
	WHERE r.name = 'Midwest' AND s.name LIKE BINARY '% K%'
    ORDER BY 3;
    
    
-- region name for every order along with acct name and unit price paid (only where standard_qty > 100 & poster_qty > 50) 
SELECT r.name region, a.name account, o.total_amt_usd/o.total unit_price, o.standard_qty, o.poster_qty
	FROM region r
    JOIN sales_reps s
		ON r.id = s.region_id
	JOIN accounts a
		ON s.id = a.sales_rep_id
	JOIN orders o
		ON a.id = o.account_id
	WHERE o.standard_qty > 100 AND o.poster_qty > 50
    ORDER BY 3;
    
    
-- region name for every order along with acct name and unit price paid (only where standard_qty > 100 & poster_qty > 50) 
SELECT r.name region, a.name account, o.total_amt_usd/o.total unit_price, o.standard_qty, o.poster_qty
	FROM region r
    JOIN sales_reps s
		ON r.id = s.region_id
	JOIN accounts a
		ON s.id = a.sales_rep_id
	JOIN orders o
		ON a.id = o.account_id
	WHERE o.standard_qty > 100 AND o.poster_qty > 50
    ORDER BY 3 DESC;
    
    
-- different channels used by account_id 1001 
SELECT DISTINCT a.name account, w.channel
		FROM accounts a
        JOIN web_events w
			ON a.id = w.account_id
		WHERE a.id = 1001;
      
      
-- all orders from 2015 
SELECT 	o.occurred_at, a.name account, o.total, o.total_amt_usd 
		FROM accounts a
        JOIN orders o
			ON a.id = o.account_id
		WHERE YEAR(o.occurred_at) = 2015
        ORDER BY 1 DESC;
	-- OR 	
SELECT 	o.occurred_at, a.name account, o.total, o.total_amt_usd 
		FROM accounts a
        JOIN orders o
			ON a.id = o.account_id
		WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
        ORDER BY 1 DESC;
        
        
-- total amount of poster paper ordered 
SELECT	SUM(poster_qty) total_poster 
FROM orders;
       
       
-- total dollar amount of sales 
SELECT	SUM(total_amt_usd) total_dollars
FROM orders;


-- total amount spent on standard and gloss paper for each order 
SELECT	standard_amt_usd + gloss_amt_usd total_gloss_standard 
FROM orders;


-- standard_amt_usd per unit of standard_qty 
SELECT	SUM(standard_amt_usd)/SUM(standard_qty) unit_price_standard
FROM orders;
   
   
-- earliest order ever placed 
SELECT 	MIN(occurred_at) ealiest_order 
FROM orders;
	
    
-- same query result as above w/o aggregate 
SELECT 	occurred_at
FROM orders 
ORDER BY 1
LIMIT 1;
	
    
-- latest web_event occurrence 
SELECT	MAX(occurred_at) 
FROM web_events;


-- same query result as above w/o aggregate 
SELECT	occurred_at
FROM web_events 
ORDER BY 1 DESC
LIMIT 1;


-- mean amount spent for each paper type, and mean amount of each paper type purchased 
SELECT	AVG(standard_amt_usd) avg_spent_standard,
		AVG(poster_amt_usd) avg_spent_poster, 
        AVG(gloss_amt_usd) avg_spent_gloss, 
        AVG(standard_qty) avg_standard_qty, 
        AVG(poster_qty) avg_poster_qty,
        AVG(gloss_qty) avg_gloss_qty 
FROM orders;
	
    
-- account that placed earliest order 
SELECT 	a.name account, o.occurred_at 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
ORDER BY 2
LIMIT 1;


-- total sales for each acct 
SELECT a.name account, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 2;


-- channel and acct associated with latest web_event 
SELECT w.occurred_at, w.channel, a.name account 
FROM web_events w
JOIN accounts a
	ON a.id = w.account_id
ORDER BY 1 DESC
LIMIT 1;


-- primary contact associated with earliest web_event 
SELECT a.primary_poc, w.occurred_at
FROM web_events w
JOIN accounts a
	ON a.id = w.account_id
ORDER BY 2
LIMIT 1;


-- total number of times each type of channel was used  
SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY 1;


-- smallest order by each acct in terms of total usd 
SELECT a.name account, MIN(o.total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 2, 1;


-- number of reps in each region 
SELECT r.name region, COUNT(*) num_reps 
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
GROUP BY 1
ORDER BY 2;


-- avg amount of paper purchased for each paper type across all orders for each acct 
SELECT 	a.name account, 
		AVG(o.standard_qty) avg_standard, 
        AVG(o.gloss_qty) avg_gloss, 
		AVG(o.poster_qty) avg_poster 
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY 1
ORDER BY 1;


-- avg amount spent on each paper type across all orders for each acct 
SELECT 	a.name account, 
		AVG(o.standard_amt_usd) avg_usd_standard,
        AVG(o.gloss_amt_usd) avg_usd_gloss,
        AVG(o.poster_amt_usd) avg_usd_poster 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 1;


-- number of times particular channel was used for each rep 
SELECT s.name rep, w.channel, COUNT(*) num_events
FROM sales_reps s
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN web_events w
	ON w.account_id = a.id
GROUP BY 1, 2
ORDER BY 3 DESC;


-- number of times particular channel was used for each region 
SELECT r.name region, w.channel, COUNT(*)
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN web_events w
	ON a.id = w.account_id
GROUP BY 1, 2
ORDER BY 3 DESC;


-- any accts associated with more than one region 
-- Query 1 
SELECT a.name account, r.name region 
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON a.sales_rep_id = s.id;      

-- Query 2 
SELECT DISTINCT name
FROM accounts;
/* Since Query 1 & Query 2 return same number of rows, each acct is associated with one region */


-- any reps worked on more than one acct 
-- Query 1 
SELECT s.name rep, COUNT(*) num_accts 
FROM sales_reps s
JOIN accounts a
	ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 2;

-- Query 2 
SELECT DISTINCT*
FROM sales_reps;
/* There are 50 reps (result from Query 2). Query 1 shows that ALL reps have worked on more than one acct. */


-- how many reps have more than 5 accts that they manage 
SELECT s.name rep, COUNT(*) num_accts 
FROM sales_reps s
JOIN accounts a 
	ON a.sales_rep_id = s.id
GROUP BY 1
HAVING num_accts > 5
ORDER BY num_accts;


-- how many accts have more than 20 orders 
SELECT a.name account, COUNT(*) num_orders 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
HAVING num_orders > 20
ORDER BY 2;


-- acct with most orders 
SELECT a.name account, COUNT(*) num_orders 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


-- accts that spent more than 30,000 total across all orders 
SELECT a.name account, SUM(o.total_amt_usd) total_spent 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
HAVING total_spent > 30000
ORDER BY total_spent;


-- accts that spent less than 1000 across all orders 
SELECT a.name account, SUM(o.total_amt_usd) total_spent 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
HAVING total_spent < 1000
ORDER BY 2;


-- acct that has spent the most 
SELECT a.name account, SUM(o.total_amt_usd) total_spent 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


-- acct that has spent the least 
SELECT a.name account, SUM(o.total_amt_usd) total_spent 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 2
LIMIT 1;


-- accts that used facebook as channel to contact customers more than 6 times 
SELECT a.name account, COUNT(*) times_contacted 
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY 1
HAVING COUNT(*) > 6
ORDER BY 2;


-- acct that used facebook most 
SELECT a.name account, COUNT(*) times_contacted 
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
/* only works if there are no ties for acct that used facebook most, which is true in this case. 
best practice to use larger LIMIT number first to check for any ties */ 


-- channel most frequently used by most accts  
SELECT a.name account, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
GROUP BY 1, 2
ORDER BY 3 DESC;


-- total sales for each year in terms of dollar  
SELECT EXTRACT(YEAR FROM occurred_at) year, SUM(total_amt_usd) total_sales
FROM orders 
GROUP BY 1
ORDER BY 2 DESC;
/* big dip in sales from 2016 to 2017. All other years saw increasing numbers  */


-- month with greatest sales in terms of dollars 
SELECT EXTRACT(MONTH FROM occurred_at) month, SUM(total_amt_usd) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
/* all months are not evenly represented. 2013 and 2017 both only account for 1 month of data. 
for this reason, those sales should be removed */

-- Modified Query 
SELECT EXTRACT(MONTH FROM occurred_at) month, SUM(total_amt_usd) total_sales
FROM orders 
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;


-- year with most number of orders 
SELECT EXTRACT(YEAR FROM occurred_at) year, COUNT(*) num_orders
FROM orders 
GROUP BY 1
ORDER BY 2 DESC;
/* all years are not evenly represented. 2013 only has data for Dec. and 2017 only has data for Jan. */


-- month with most number of orders 
SELECT EXTRACT(MONTH FROM occurred_at) month, COUNT(*) num_orders 
FROM orders 
GROUP BY 1
ORDER BY 2 DESC;


-- month and year in which Walmart spent most dollars on gloss paper 
SELECT EXTRACT(YEAR FROM o.occurred_at), EXTRACT(MONTH FROM o.occurred_at), SUM(o.gloss_amt_usd) total_sales_gloss
FROM orders o 
JOIN accounts a
	ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;


-- order is 'large' or 'small' 
SELECT 	account_id, 
		total_amt_usd, 
        CASE WHEN total_amt_usd < 3000 THEN 'Small'
			 ELSE 'Large' END order_level
FROM orders;


-- number of orders in each of three categories 
SELECT 	CASE 
		WHEN total >= 2000 THEN 'At least 2000'
        WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
        ELSE 'Less than 1000' END order_category,
        COUNT(*) num_orders 
FROM orders
GROUP BY 1;


-- 3 levels of customers based on total sales of all orders 
SELECT 	a.name account, 
		SUM(o.total_amt_usd) total_sales, 
		CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Top'
			 WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Middle'
             WHEN SUM(o.total_amt_usd) < 100000 THEN 'Low' END level 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;


-- 3 levels of customers based on total sales of all orders in 2016 and 2017 
SELECT 	a.name account, 
		SUM(o.total_amt_usd) total_sales, 
		CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Top'
			 WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Middle'
             WHEN SUM(o.total_amt_usd) < 100000 THEN 'Low' END level 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01' OR o.occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;


-- top performing reps 
SELECT 	s.name rep, 
		COUNT(*) num_orders, 
        CASE WHEN COUNT(*) > 200 THEN 'top'
			 ELSE 'not' END performance
FROM sales_reps s
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;
/* assumes each name is unique */
		
        
-- top performing reps revised 
SELECT 	s.name rep, 
		COUNT(*) num_orders, 
        SUM(o.total_amt_usd) total_sales,
        CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
			 WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) BETWEEN 500000 AND 750000 THEN 'middle'
			 ELSE 'low' END performance
FROM sales_reps s
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;
/* a couple of reps will be upset because some reps below them are considered top even though they didn't bring in 
as many sales. the only thing placing them higher is having more number of orders, but does that really matter more? */


/* avg number of events for each day for each channel */
# Step 1: number of events for each day for each channel 
SELECT DATE(occurred_at) YMD, channel, COUNT(*) num_events
FROM web_events
GROUP BY 1, 2 
ORDER BY 3 DESC;
# Step 2: use subquery to find avg 
SELECT channel, AVG(num_events) avg_events
FROM 
	(SELECT DATE(occurred_at) YMD, channel, COUNT(*) num_events
	FROM web_events
	GROUP BY 1, 2 
	ORDER BY 3 DESC) sub
GROUP BY 1
ORDER BY 2 DESC;


/* all orders that occurred in same month and year as first order ever.
then, pull avg for each paper type qty and total amt spent on all orders in this month */
SELECT 	AVG(standard_qty) avg_standard_qty,
        AVG(gloss_qty) avg_gloss_qty,
        AVG(poster_qty) avg_poster_qty, 
        SUM(total_amt_usd) total_spent
FROM 
	(SELECT *
	FROM orders 
	WHERE EXTRACT(YEAR_MONTH FROM occurred_at) = 
		(SELECT EXTRACT(YEAR_MONTH FROM MIN(occurred_at))
		FROM orders)
	ORDER BY occurred_at) sub;


# Sub1    
/* name of rep in each region with largest sales in terms of usd */
SELECT t2.region, rep, t2.largest_sale_amt
FROM 	
    (SELECT region, MAX(total_sales) largest_sale_amt
	FROM
		(SELECT r.name region, s.name rep, SUM(o.total_amt_usd) total_sales 
		FROM region r
		JOIN sales_reps s
			ON r.id = s.region_id
		JOIN accounts a
			ON a.sales_rep_id = s.id
		JOIN orders o
			ON o.account_id = a.id
		GROUP BY 1, 2
		ORDER BY 1) t1
	GROUP BY 1) t2
JOIN (SELECT r.name region, s.name rep, SUM(o.total_amt_usd) total_sales 
		FROM region r
		JOIN sales_reps s
			ON r.id = s.region_id
		JOIN accounts a
			ON a.sales_rep_id = s.id
		JOIN orders o
			ON o.account_id = a.id
		GROUP BY 1, 2
		ORDER BY 1) t1
ON t1.region = t2.region AND t1.total_sales = t2.largest_sale_amt
ORDER BY 3 DESC;


#Sub2
/* total orders placed for region with largest sum of sales */
SELECT r.name region, COUNT(*) total_orders
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON a.sales_rep_id = s.id
JOIN orders o
	ON o.account_id = a.id
WHERE r.name = (SELECT region
	FROM 
	(SELECT r.name region, SUM(o.total_amt_usd) total_sales 
	FROM region r
	JOIN sales_reps s
		ON r.id = s.region_id
	JOIN accounts a
		ON a.sales_rep_id = s.id
	JOIN orders o
		ON o.account_id = a.id
	GROUP BY 1
	ORDER BY 2 DESC) t1
	LIMIT 1)
GROUP BY 1;


#Sub3
/* number of accts with more total purchases than acct which has bought most std_qty paper throughout its lifetime */
SELECT COUNT(*) num_accts
FROM 
	(SELECT a.name account, SUM(o.total) total_purchases
	FROM accounts a
	JOIN orders o
		ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > (SELECT SUM(o.total) total_purchses  
		FROM accounts a
		JOIN orders o
			ON a.id = o.account_id
		WHERE a.name = (SELECT account 
			FROM 
			(SELECT a.name account, SUM(standard_qty) total_qty_std
			FROM accounts a
			JOIN orders o
				ON a.id = o.account_id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1) t1))
            ) sub;


#Sub4
/* number of web_events for each channel for customer who spent the most usd in their lifetime */
SELECT a.name account, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
WHERE a.name = (SELECT account
	FROM (
	SELECT a.name account, SUM(o.total_amt_usd) total_spent
	FROM accounts a
	JOIN orders o
		ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1) t1)
GROUP BY 1, 2
ORDER BY 3 DESC;


#Sub5
/* lifetime avg amount spent (usd) for top 10 spending accts */ 
SELECT AVG(o.total_amt_usd) lifetime_avg_spent
FROM accounts a
JOIN orders o
	ON a.id	= o.account_id
WHERE a.name IN (SELECT account
	FROM (
	SELECT a.name account, SUM(o.total_amt_usd) total_spent 
	FROM accounts a
	JOIN orders o
		ON a.id	= o.account_id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10) t1)
GROUP BY 1
ORDER BY 2 DESC;


#Sub6
/* lifetime avg amount spent (usd) including only companies that spent more per order, on avg, 
than avg of all orders */
SELECT AVG(avg_spent)
FROM (SELECT a.name account, AVG(o.total_amt_usd) avg_spent
	FROM accounts a
	JOIN orders o
		ON a.id	= o.account_id
	GROUP BY 1
	HAVING AVG(o.total_amt_usd) > (SELECT AVG(total_amt_usd) 
		FROM orders)
	ORDER BY 2 DESC) t1;


/* Sub1 using CTE */
WITH t1 AS (SELECT r.name region, s.name rep, SUM(o.total_amt_usd) total_sales 
		FROM region r
		JOIN sales_reps s
			ON r.id = s.region_id
		JOIN accounts a
			ON a.sales_rep_id = s.id
		JOIN orders o
			ON o.account_id = a.id
		GROUP BY 1, 2
		ORDER BY 1), 
	t2 AS (SELECT region, MAX(total_sales) largest_sale_amt
		FROM t1
		GROUP BY 1)
	
SELECT t2.region, rep, t2.largest_sale_amt
FROM t2
JOIN t1 
ON t1.region = t2.region AND t1.total_sales = t2.largest_sale_amt
ORDER BY 3 DESC;


/* Sub2 with CTE */
WITH t1 AS (SELECT r.name region, SUM(o.total_amt_usd) total_sales 
	FROM region r
	JOIN sales_reps s
		ON r.id = s.region_id
	JOIN accounts a
		ON a.sales_rep_id = s.id
	JOIN orders o
		ON o.account_id = a.id
	GROUP BY 1
	ORDER BY 2 DESC)
                    
SELECT r.name region, COUNT(*) total_orders
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON a.sales_rep_id = s.id
JOIN orders o
	ON o.account_id = a.id
WHERE r.name = (SELECT region
	FROM t1
	LIMIT 1)	
GROUP BY 1;


/* Sub3 using CTE */
WITH t1 AS (SELECT a.name account, SUM(standard_qty) total_qty_std
	FROM accounts a
	JOIN orders o
		ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1),
    
	t2 AS (SELECT a.name account, SUM(o.total) total_purchases
		FROM accounts a
		JOIN orders o
			ON a.id = o.account_id
		GROUP BY 1
		HAVING SUM(o.total) > (SELECT SUM(o.total) total_purchses  
			FROM accounts a
			JOIN orders o
				ON a.id = o.account_id
			WHERE a.name = (SELECT account 
				FROM t1))
			)

SELECT COUNT(*) num_accts
FROM t2;


/* Sub4 using CTE */
WITH t1 AS (SELECT a.name account, SUM(o.total_amt_usd) total_spent
	FROM accounts a
	JOIN orders o
		ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1)

SELECT a.name account, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
WHERE a.name = (SELECT account
	FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;


/* Sub5 using CTE */
WITH t1 AS (SELECT a.name account, SUM(o.total_amt_usd) total_spent 
		FROM accounts a
		JOIN orders o
			ON a.id	= o.account_id
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10)

SELECT AVG(total_spent) lifetime_avg_spent
FROM t1;


/* Sub6 using CTE */
WITH t1 AS (SELECT a.name account, AVG(o.total_amt_usd) avg_spent
	FROM accounts a
	JOIN orders o
		ON a.id	= o.account_id
	GROUP BY 1
	HAVING AVG(o.total_amt_usd) > (SELECT AVG(total_amt_usd) 
									FROM orders)
	ORDER BY 2 DESC)

SELECT AVG(avg_spent)
FROM t1;


