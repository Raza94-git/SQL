/* Problem Statement:
 ABC Fashion is a leading retailer with a vast customer base and a team of dedicated sales
 representatives. They have a Sales Order Processing System that helps manage customer
 orders and interactions.*/

 /*
 Tasks to be Performed:
 1. Insert a new record in your Orders table.
 2. Add Primary key constraint for SalesmanId column in Salesman table. Add default
 constraint for City column in Salesman table. Add Foreign key constraint for SalesmanId
 column in Customer table. Add not null constraint in Customer_name column for the
 Customer table.
 3. Fetch the data where the Customer’s name is ending with ‘N’ also get the purchase
 amount value greater than 500.
 4. Using SET operators, retrieve the first result with unique SalesmanId values from two
 tables, and the other result containing SalesmanId with duplicates from two tables.
 5. Display the below columns which has the matching data.
 Orderdate, Salesman Name, Customer Name, Commission, and City which has the
 range of Purchase Amount between 500 to 1500.
 6. Using right join fetch all the results from Salesman and Orders table
*/

create database revision_assgn1;
use revision_assgn1;

create table salesman (
SalesmanId Int,
Name varchar(255),
Commission decimal(10,2),
City varchar(255),
Age INT
);

/* How to rename the table?
EXEC sp_rename 'OldTableName', 'NewTableName'; */

Create table customer (
SalesmanId Int,
CustomerId int,
customer_Name varchar(255),
purchase_amount int
);

create table orders (
Orderid int,
customerid int,
salesmanid int,
order_date date,
amount money
);

Insert into salesman (SalesmanId, Name, Commission, City, Age) values
(101, 'Joe', 50, 'California', 17),
(102, 'Simon', 75, 'Texas', 25),
(103, 'Jessie', 105, 'Florida', 35),
(104, 'Danny', 100, 'Texas', 22),
(105, 'Lia', 65, 'New Jersey', 30);

Insert into customer (SalesmanId, CustomerId, customer_Name, purchase_amount) values
(101, 2345, 'Andrew', 550),
(103, 1575, 'Lucky', 4500),
(104, 2345, 'Andrew', 4000),
(107, 3747, 'Remona', 2700),
(110, 4004, 'Julia', 4545);

Insert into orders (orderid, customerid, salesmanid, order_date, amount) values
(5001, 2345, 101, '2021-07-04', 550),
(5003, 1234, 105, '2022-02-15', 1500)

select * from salesman
select * from customer
select * from orders

/* TASKS TO BE PERFORMED */

-- 1. Insert a new record in your Orders table.

Insert into orders (orderid, customerid, salesmanid, order_date, amount) values
(5004, 4004, 110, '2022-06-09', 4545);

select * from orders

/* 2. Add Primary key constraint for SalesmanId column in Salesman table. Add default
 constraint for City column in Salesman table. Add Foreign key constraint for SalesmanId
 column in Customer table. Add not null constraint in Customer_name column for the
 Customer table. */

/* alter table salesman
 add constraint primary_key primary key(salesmanid); */

 /* When we execute the above code, we get the following error:
 Cannot define PRIMARY KEY constraint on nullable column in table 'salesman'.

 - Primary key cannot be defined on a column that does not have a not null constraint
 - First we have to provide not null constraint on the column */

 alter table salesman
 alter column salesmanid int not null;

 alter table salesman
 add constraint primary_key primary key (salesmanid);

 -- Add default constraint for City column in Salesman table

 alter table salesman
 add constraint default_city default 'New York' for City;

 -- Add foreign key constraint for salesmanid column in customer table

 alter table customer
 add constraint fk_sales foreign key (salesmanid) 
 references salesman(salesmanid);

 /* The above code gives us the following error:
 The ALTER TABLE statement conflicted with the FOREIGN KEY constraint "fk_salesmanid". 
 The conflict occurred in database "revision_assgn1", table "dbo.salesman", column 'SalesmanId'. */

 /* This is because the salesmanid column in customer table has values that are not present in salesmanid column in salesman table
 If we are adding a foreign key constraint on salesmanid in customer table referencing salesmanid in salesman table, 
 then it must not have values other than that in salesman table */

 -- Add not null constraint in the customer_name column for the customer table
 
 alter table customer
 alter column customer_name varchar(255) not null;

 /* 3. 
 Fetch the data where the Customer’s name is ending with ‘N’ also get the purchase
 amount value greater than 500 */

 select * from orders;

 select customer_name, amount
 from orders as o
 inner join customer as c
 on o.customerid=c.customerid
 where amount>500 and customer_Name like '%N';

/* 4. Using SET operators, retrieve the first result with unique SalesmanId values from two
 tables, and the other result containing SalesmanId with duplicates from two tables */

 select salesmanid as unique_salesmanid from salesman
 union
 select salesmanid as unique_salesmanid from customer

 select salesmanid as duplicate_salesmanid from salesman
 union all
 select salesmanid as duplicate_salesmanid from customer

 /* 5. Display the below columns which has the matching data.
 Orderdate, Salesman Name, Customer Name, Commission, and City which has the
 range of Purchase Amount between 500 to 1500 */

 select order_date, name, customer_name, commission, city, purchase_amount
 from
 orders as o
 inner join customer as c
 on o.salesmanid=c.SalesmanId
 full join
 salesman as s 
 on c.salesmanid=s.salesmanid
 where purchase_amount between 500 and 1500;

 /* 6. Using right join fetch all the results from Salesman and Orders table */

 select * from orders as o
 right join
 salesman as s
 on o.salesmanid=s.SalesmanId

