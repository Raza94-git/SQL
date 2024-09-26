/*
 Problem Statement:

 You are a database administrator. You want to use the data to answer a few
 questions about your customers, especially about the sales and profit coming
 from different states, money spent in marketing and various other factors such as
 COGS (Cost of Goods Sold), budget profit etc. You plan on using these insights
 to help find out which items are being sold the most. You have been provided
 with the sample of the overall customer data due to privacy issues. But you hope
 that these samples are enough for you to write fully functioning SQL queries to
 help answer the questions.

 Dataset:

 The 3 key datasets for this case study:

 a. FactTable: The Fact Table has 14 columns mentioned below and 4200
 rows. Date, ProductID, Profit, Sales, Margin, COGS, Total Expenses,
 Marketing, Inventory, Budget Profit, Budget COGS, Budget Margin, Budget
 Sales, and Area Code
 Note: COGS stands for Cost of Goods Sold

 b. ProductTable: The ProductTable has four columns named Product Type,
 Product, ProductID, and Type. It has 13 rows which can be broken down
 into further details to retrieve the information mentioned in theFactTable.

 c. LocationTable: Finaly, the LocationTable has 156 rows and follows a
 similar approach to ProductTable. It has four columns named Area Code,
 State, Market, and Market Size
*/

create database revision_casestudy_1;
use revision_casestudy_1;

-- Import flat files
select * from product
select * from location
select * from fact

-- 1. Display the number of states present in theLocationTable

select count(state) from location;
-- The above query gives the total count in state column

select count(*) as cnt_dist_state from 
(
select distinct state from location
) as dist_state

-- The above query gives us the count of distinct states present in the location table

-- 2. How many products are of regular type?

select count(*) as cnt_type from product where type='regular';

--  3. Howmuch spending has been done on marketing of product ID1?

select sum(marketing) as marketing_expenditure from fact where productid=1;

--  4. What is the minimum sales of a product?

select min(sales) as min_sales from fact;

-- Gives us the minimum value in the sales column

/* with total_sales as
(
select productid, sum(sales) as sum_sales
from fact
group by productid
order by sum(sales)
)
select min(sum_sales) min_total_sales from total_sales */

/* when executing the above query, we get the following error:
The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions, 
unless TOP, OFFSET or FOR XML is also specified. 

Order by clause is used to order the final result in a query, hence it cannot be used in a subquery or cte or derived tables */

-- There is no need of order by clause for the outpur we require, hence it is redundant
-- Now, we will execute the above same query without the order by clause

with total_sales as
(
select productid, sum(sales) as sum_sales
from fact
group by productid
)
select min(sum_sales) as min_total_sales from total_sales;

-- The above query calculates the aggregate of sales for each product id and returns the product id with minimum total sales

-- Now, what if we also want to display the productid which has minimum total sales

with total_sales as
(
select productid, sum(sales) as sum_sales
from fact
group by productid
)
select * from total_sales where sum_sales=min(sum_sales);

/* The above query returns the following error:
An aggregate may not appear in the WHERE clause unless it is in a subquery contained in a HAVING clause or a select list, 
and the column being aggregated is an outer reference.

The WHERE clause is evaluated before aggregates are calculated, so we cannot use an aggregate function like MIN() directly there.
We can modify the above query as below to get the required output
*/

with total_sales as
(
select productid, sum(sales) as min_total_sales
from fact
group by productid
)
select * from total_sales
where min_total_sales = (select min(min_total_sales) from total_sales)

-- The above query returns the minimum total sales and it's product id

/* From the error we got earlier:
An aggregate may not appear in the WHERE clause unless it is in a subquery contained in a HAVING clause or a select list, 
and the column being aggregated is an outer reference.

Let us try to understand what is the meaning of 'the column being aggregated is an outer reference'. what does it entail?

The above pharase refers to the concept of correalted subqueries.
In correlated subquery is a subquery that references the columns from the outer query.
Here, the sql is trying to tell us that we cannot use the aggreagate function like min directly with the where clause
It has to be used in a subquery

For example:
SELECT e.employee_id, e.salary
FROM employee e
WHERE e.salary > (SELECT AVG(e2.salary) 
                  FROM employee e2 
                  WHERE e2.department_id = e.department_id);

Here, the aggregate function avg(e2.salary) references the e.department_id column from the outer query
This is what it means that the column being aggregated should be an outer reference
*/

-- 5. Display the max Cost of Good Sold (COGS)

select * from fact;

select max(cogs) as max_cogs from fact;

-- The above query gives the maximum values of COGS

with total_cost as
(
select productid, sum(cogs) as total_cogs
from fact
group by productid
)
select * from total_cost where total_cogs = (
select min(total_cogs) from total_cost
)

-- The above query returns the productid where the sum of cogs is minimum

-- 6. Display the details of the product where product type is coffee

select * from product where product_type='coffee';

--  7. Display the details where total expenses are greater than 40

select * from fact where total_expenses>40;

--  8. What is the average sales in area code 719?

select sum(sales) as total_sales from fact where area_code=719

-- 9. Find out the total profit generated by Colorado state.

select * from fact;
select * from location;

select sum(profit) as total_profit from fact as f
inner join
location as l
on f.area_code=l.area_code
where state='colorado';

-- The above query gives us the total  profit for colorado state

-- If we also want to display the state in the output, we can use the following query:

select state, sum(profit) as total_profit
from fact as f
inner join
location as l
on f.area_code=l.area_code
group by state
having state='colorado';

-- 10. Display the average inventory for each product ID.

select * from fact;

select productid, avg(inventory) as avg_inventory
from fact
group by productid
order by productid;

-- 11.  Display state in a sequential order in a LocationTable

select * from location;

select state from location order by state;
-- Returns the states with repitition

select distinct state from location order by state;
-- Display distinct states

-- 12.  Display the average budget of the Product where the average budget margin should be greater than 100.

select * from fact;
select * from product;

select f.productid, product, avg(budget_margin) as avg_budg_margin
from fact as f
inner join
product as p
on f.productid=p.productid
group by product, f.productid
having avg(budget_margin) >100
order by avg(budget_margin)

-- 13.  What is the total sales done on date 2010-01-01

select * from fact;

select date, sum(sales) as sum_sales from fact
group by date
having date='2010-01-01';

-- 14.  Display the average total expense of each product ID on an individual date.

select productid, date, avg(total_expenses) as avg_expenses
from fact
group by productid, date
order by productid, date;

-- 15.  Display the table with the following attributes such as date, productID, product_type, product, sales, profit, state, area_code.

select date, f.productid, product_type, product, sales, profit, state, f.area_code
from fact as f
inner join 
product as p
on f.productid=p.productid
inner join
location as l
on f.area_code=l.area_code

-- 16. Display the rank without any gap to show the sales wiserank.

select *,
DENSE_RANK() over(order by sales desc) as rnk,
row_number() over(order by sales desc) as row_num
from fact

-- 17. Find the state wise profit and sales.

select state, sum(profit) as sum_profit, sum(sales) as sum_sales
from fact as f
inner join
location as l
on f.area_code=l.area_code
group by state
order by sum(sales) desc;

-- 18.  Find the state wise profit and sales along with the productname

select state, product, sum(sales) as sum_sales, sum(profit) as sum_profit
from fact as f
inner join product as p
on f.productid=p.productid
inner join
location as l
on f.area_code=l.area_code
group by state, product
order by state, product;

-- 19.  If there is an increase in sales of 5%, calculate the increasedsales.

alter table fact
add increased_sales float;

select * from fact;

update fact
set increased_sales = sales*1.05;

-- 20.  Find the maximum profit along with the product ID and producttype

select * from product;

select p.productid,type, profit
from product as p
inner join
fact as f
on p.productid=f.productid
where profit = (select max(profit) from fact);

-- If we have to find the maximum profit of aggregation of profit on product id, we can use the followin query:

with profit_sum as
(
select p.productid, type, sum(profit) as sum_profit
from product as p
inner join
fact as f
on p.productid=f.productid
group by p.productid, type
)
select * from profit_sum
where
sum_profit = (select max(sum_profit) from profit_sum);

-- 21.  Create a stored procedure to fetch the result according to the product type from ProductTable

create procedure product_type(@type varchar(50))
as
select * from product where type=@type
;
go

execute product_type regular
execute product_type decaf

-- 22. Write a query by creating a condition in which if the total expenses is less than 60 then it is a profit or else loss

-- We can create a new column that will return profit or loss as per the condition

alter table fact
add profit_or_loss varchar(20)

update fact
set profit_or_loss = 
iif (total_expenses<60, 'profit', 'loss')

alter table fact
drop column profit_or_loss

alter table fact
drop column increased_sales

-- We can also write a query for it

select *, iif(total_expenses<60, 'profit', 'loss') as profit_or_loss from fact;

--  23. Give the total weekly sales value with the date and product ID details. Use roll-up to pull the data in hierarchical order

select * from fact;

select datepart(week,date) as grp_week,
productid as grp_id,
sum(sales) as weekly_sales
from fact
group by rollup(datepart(week,date), ProductId);

-- 24.  Apply union and intersection operator on the tables which consist of attribute area code.

select * from fact
select * from Location

select area_code from fact 
union
select area_code from Location

select area_code from fact
intersect
select area_code from location

-- 25.  Create a user-defined function for the product table to fetch aparticular product type based upon the user’s preference

SELECT * FROM PRODUCT;

create function what_type(@PRODUCT_type varchar(50))
returns table
as
return(select * from product where type=@PRODUCT_type);

select * from what_type('TEA');

-- 26. Change the product type from coffee to tea where product ID is 1 and undo it.

BEGIN TRANSACTION TEA
UPDATE Product
SET Product_Type='TEA'
WHERE ProductId=1
ROLLBACK TRANSACTION
PRINT 'Operation Undone'

select * from Product;

-- 27. Display the date, product ID and sales where total expensesare between 100 to 200

select date, productid, sales from fact where Total_Expenses between 101 and 199;

-- 28.  Delete the records in the Product Table for regulartype.

begin transaction del_reg
delete from Product
where type='regular'

rollback transaction

select * from product;

-- 29.  Display the ASCII value of the fifth character from the columnProduct.

select product, substring(product,5,1) as fith_char,
ascii(substring(product,5,1)) as ascii_value from Product

