SELECT * FROM walmart.walmart_sales;

-- I. Feature Engineering
-- 1. Adding Time of Day column
SELECT time, (CASE
WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM walmart_sales;

ALTER TABLE walmart_sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE walmart_sales
SET time_of_day = (
	CASE
		WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- 2. Adding Day name column
ALTER TABLE walmart_sales ADD COLUMN day_name VARCHAR(10);

UPDATE walmart_sales
set day_name = dayname(date);

-- 3. Adding Month name
ALTER TABLE walmart_sales ADD COLUMN month_name VARCHAR(20);
UPDATE walmart_sales set month_name = monthname(date);

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- II. EXPLORATORY DATA ANALYSIS -- GENERIC
-- 1. How many unique cities does the data have?

SELECT distinct city from walmart_sales;

-- 2. In which city is each branch?
SELECT distinct city, branch from walmart_sales;

-- PRODUCT

-- How many unique product lines does the data have?
SELECT distinct product_line from walmart_sales;

-- Which is the most selling product line

SELECT product_line, sum(quantity) as qty
from walmart_sales
group by product_line
order by qty desc;

-- What is the total revenue by month

SELECT  month_name, round(sum(total),2) as total
from walmart_sales
group by month_name;


-- Which is the most used payment method?
SELECT payment, count(payment) as cnt 
from walmart_sales
group by payment
order by cnt desc
limit 1;

-- Which month has the largest COGS?
select month_name as month, round(sum(cogs),2) as total_amount
from walmart_sales
group by month
order by total_amount desc
limit 1;

-- Which product line has the largest revenue? 
SELECT product_line, round(sum(Total),2) as total_revenue
from walmart_sales
group by product_line
order by total_revenue desc
limit 1;

-- Which city has the largest revenue?
SELECT city, round(sum(Total),2) as total_revenue
from walmart_sales
group by city
order by total_revenue desc
limit 1;

-- Which product line has the highest VAT percentage?
select product_line, round(avg(tax_5),2) as total_vat
from walmart_sales
group by product_line
order by total_vat desc
limit 1;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT avg(quantity) as avg_qty
from walmart_sales;

SELECT product_line, case when
avg(quantity) > 5.5 then "Good" 
else "Bad"
END as "AVG Sales Remark"
from walmart_sales
group by product_line;

--  Which branch sold more products than average product sold?
SELECT branch, sum(quantity) as qty 
from walmart_sales
group by branch
having sum(quantity) > avg(quantity)
order by qty desc
limit 1;

-- -- Which is the most used product line by gender.
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM walmart_sales
GROUP BY product_line, gender
ORDER BY total_cnt DESC
;

-- What is the average rating of each product line?
SELECT product_line, round(avg(rating),1) as avg_rating
from walmart_sales
group by product_line;

-- CUSTOMERS
-- How many unique customer types does the data have?
select distinct customer_type from walmart_sales;

-- How many unique payment methods does the data have?
select distinct payment from walmart_sales;

-- What is the count of normal and member customers?
select customer_type, count(*) as Count
from walmart_sales
group by customer_type;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM walmart_sales
GROUP BY customer_type;

-- Count of customer gender-wise
SELECT gender, count(gender) as total_count
from walmart_sales
group by gender
order by total_count desc;

--  What is the gender distribution per branch?

SELECT branch, gender, COUNT(*) as count
FROM walmart_sales
GROUP BY branch, gender
order by branch;

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmart_sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	round(AVG(rating),1) AS avg_rating
FROM walmart_sales
GROUP BY day_name
ORDER BY avg_rating DESC
;

-- Which day of the week has the best average ratings per branch?
select branch, day_name, round(avg(rating),1) as avg_rating
from walmart_sales
group by day_name, branch
order by avg_rating desc
limit 3;

-- SALES
-- Number of sales made in each time of the day per weekday.
SELECT
	day_name, time_of_day,
	COUNT(*) AS total_sales
FROM walmart_sales
GROUP BY day_name, time_of_day 
ORDER BY day_name;

-- Which customer types brings the most revenue?
select customer_type, round(sum(total),2) as total_revenue
from walmart_sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax/VAT percent?
select city, round(avg(tax_5),1) as vat_percentage
from walmart_sales
group by city
order by vat_percentage desc;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	round(AVG(tax_5),2) AS total_tax
FROM walmart_sales
GROUP BY customer_type
ORDER BY total_tax;
