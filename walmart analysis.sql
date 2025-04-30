-- Create database
CREATE DATABASE  walmartSales;


-- Create table
CREATE TABLE  saleswalmart(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
select * from saleswalmart;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------feature engineering-------------------------------------------------------------------
-- time_of_day
select time,(case
when time between "00:00:00" and "12:00:00" then "morming"
when time between "12:01:00" and "16:00:00" then "after noon"
else "evening"
end)as time_of_day from saleswalmart;

alter table saleswalmart
add column time_of_day varchar(20);

update saleswalmart
set time_of_day=(case
when time between "00:00:00" and "12:00:00" then "morming"
when time between "12:01:00" and "16:00:00" then "after noon"
else "evening"
end);

-- day name
select date,dayname(date) from saleswalmart;
alter table saleswalmart
add column day_name varchar(20);
update saleswalmart
set day_name=(dayname(date));

-- month name
select date,monthname(date) from saleswalmart;
alter table saleswalmart
add column month_name varchar(20);
update saleswalmart
set month_name=(monthname(date));
-- ------------------------------------------------------------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------genaric--------------------------------------------------------------------------
-- How many unique cities does the data have
select distinct city from saleswalmart;

-- In which city is each branch
select distinct city,branch from saleswalmart;
-- ---------------------------------------------------------------------------------------------------------------------------------------


-- -------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------product----------------------------------------------------------------------------
-- How many unique product lines does the data have
select count(distinct product_line) from saleswalmart;
-- What is the most common payment method
select distinct payment,count(payment) as cpm from saleswalmart
group by payment
order by cpm desc 
limit 1;
-- What is the most selling product line
select product_line,count(product_line)as cpl from saleswalmart
group by product_line
order by cpl desc
limit 1;
-- What is the total revenue by month
select month_name as month,sum(total) as total_revenue from saleswalmart
group by month
order by total_revenue desc;
-- What month had the largest COGS
select month_name as month,sum(cogs) as mcogs from saleswalmart
group by month
order by mcogs desc;
-- What product line had the largest revenue
select product_line,sum(total) as revenue from saleswalmart
group by product_line
order by revenue desc;
-- What is the city with the largest revenue
select city,branch,sum(total) as revenue from saleswalmart
group by city,branch
order by revenue desc;
-- What product line had the largest VAT
select product_line,avg(tax_pct)as vat from saleswalmart
group by product_line
order by vat desc;
-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM saleswalmart;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM saleswalmart
GROUP BY product_line;

-- Which branch sold more products than average product sold
select branch,sum(quantity)as qty from saleswalmart
group by branch
having sum(quantity) >(select avg(quantity) from saleswalmart);

-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM saleswalmart
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM saleswalmart
GROUP BY product_line
ORDER BY avg_rating DESC;
-- -------------------------------------------------------------------------------------------------------------------------------------


-- -----------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------sales-----------------------------------------------------------------------------
-- Number of sales made in each time of the day per weekday
select time_of_day,count(*) as total_sales from saleswalmart
group by time_of_day
order by total_sales desc;

-- Which of the customer types brings the most revenue
select customer_type,sum(total) as revenue from saleswalmart
group by customer_type
order by revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)
select city,max(tax_pct) as vat from saleswalmart
group by city
order by vat desc;

-- Which customer type pays the most in VAT
select customer_type,max(tax_pct) as vat from saleswalmart
group by customer_type
order by vat desc;
-- ------------------------------------------------------------------------------------------------------------------------------------


-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------customer----------------------------------------------------------------------------
-- How many unique customer types does the data have
select distinct customer_type from saleswalmart;

-- How many unique payment methods does the data have
select distinct payment from saleswalmart;

-- What is the most common customer type
select customer_type,count(*) as count from saleswalmart
group by customer_type
order by count;

-- Which customer type buys the most
select customer_type,count(*) as count from saleswalmart
group by customer_type
order by count desc;

-- What is the gender of most of the customers
select gender,count(*) as gender_count from saleswalmart
group by gender
order by gender_count desc;

-- What is the gender distribution per branch
select gender,branch,count(*) as gender_count from saleswalmart
group by gender,branch
order by gender_count desc;

-- Which time of the day do customers give most ratings
select time_of_day,avg(rating) as avg_rating from saleswalmart
group by time_of_day
order by avg_rating desc;

-- Which time of the day do customers give most ratings per branch
select time_of_day,avg(rating),branch as avg_rating from saleswalmart
group by time_of_day,branch
order by avg_rating desc;

-- Which day of  the week has the best avg ratings
select day_name,avg(rating) as avg_rating from saleswalmart
group by day_name
order by avg_rating desc;

-- Which day of the week has the best average ratings per branch
select day_name,avg(rating),branch as avg_rating from saleswalmart
group by day_name,branch
order by avg_rating desc;


