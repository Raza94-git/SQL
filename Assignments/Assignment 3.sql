create database revision_assgn3;
use revision_assgn3;

/*
Dataset: Jomato
 About the dataset:

 You work for a data analytics company, and your client is a food delivery platform similar to
 Jomato. They have provided you with a dataset containing information about various
 restaurants in a city. Your task is to analyze this dataset using SQL queries to extract valuable
 insights and generate reports for your client.
 
 Tasks to be performed:
 
 1. Create a stored procedure to display the restaurant name, type and cuisine where the
 table booking is not zero.
 
 2. Create a transaction and update the cuisine type ‘Cafe’ to ‘Cafeteria’. Check the result
 and rollback it.
 
 3. Generate a row number column and find the top 5 areas with the highest rating of
 restaurants.
 
 4. Use the while loop to display the 1 to 50.
 
 5. Write a query to Create a Top rating view to store the generated top 5 highest rating of
 restaurants.
 
 6. Create a trigger that give an message whenever a new record is inserted.
 */

 -- Import flat file Jomato

 select * from Jomato;

 /*  1. Create a stored procedure to display the restaurant name, type and cuisine where the
 table booking is not zero. */

 create procedure table_booking
 as
	select Restaurantname, restauranttype, cuisinestype from jomato where tablebooking<>0;
go

exec table_booking

/* 2. Create a transaction and update the cuisine type ‘Cafe’ to ‘Cafeteria’. Check the result
 and rollback it. */

 begin transaction
 update jomato
 set cuisinestype='Cafeteria'
 where cuisinestype ='cafe'

 select * from Jomato where cuisinestype='cafeteria';
 select count(*) from Jomato where CuisinesType='cafeteria';

 rollback transaction

 /* 3. Generate a row number column and find the top 5 areas with the highest rating of
 restaurants.*/

 select * from Jomato;

 with group_area as 
 (
 select avg(rating) as avg_rating, area,
 ROW_NUMBER() over(order by avg(rating) desc) as rownumber
 from jomato
 group by Area
 )
 select * from group_area where rownumber<=5;

 -- We can also use multiple CTEs to solve the above query

 with group_area as
 (
 select avg(rating) as avg_rating, area
 from jomato
 group by Area
 ),
 rank_number as
 (
 select *, ROW_NUMBER() over(order by avg_rating) as rownumber
 from group_area
 )
 select * from rank_number where rownumber<=5;


 /* 4. Use the while loop to display the 1 to 50. */

 declare @n int
 set @n=1

 while @n<=50
 begin
	print @n
	set @n = @n+1
end

/* 5. Write a query to Create a Top rating view to store the generated top 5 highest rating of
 restaurants. */

 create view top_rating
 as
with group_area as 
 (
 select avg(rating) as avg_rating, area,
 ROW_NUMBER() over(order by avg(rating) desc) as rownumber
 from jomato
 group by Area
 )
 select * from group_area where rownumber<=5;

 select * from top_rating

/* 6. Create a trigger that give an message whenever a new record is inserted. */

-- Let us solve this query in two ways:

/* In the first method, we are going to create a table insert_record
- We will create a trigger on Jomato table such that When anyone inserts a record in our Jomato table,
the inserted orderid, date of inserting and the user who has inserted will be inserted in our insert_record table
- Let us see how to do that */

select * from Jomato;

create table insert_record(
orderid int not null,
modification_date date default getdate() not null,
changed_by varchar(50) default current_user not null
)

create trigger records_inserted on Jomato
for insert
as
begin
insert into insert_record(orderid, modification_date, changed_by)
select j.orderid, getdate(), SUSER_NAME()
from Jomato as j inner join inserted as b
on j.OrderId=b.OrderId
end

select * from Jomato
insert into Jomato values (8001, 'a', 'b', 5, 10, 200, 1, 0, 'food', 'ahmd', 'sarkhej', 60)

select * from insert_record
-- We can see that a record has been inserted in our insert_record table

delete from Jomato
where RestaurantName='a'

-- Another way, we will create a trigger to prevent inserting a record into our table

create trigger prevent_insert on jomato
for insert
as
begin
	print 'Inserting not allowed'
	rollback transaction
end

insert into Jomato values (8001, 'a', 'b', 5, 10, 200, 1, 0, 'food', 'ahmd', 'sarkhej', 60)

select * from Jomato where orderid=8001;
-- No records displayed
