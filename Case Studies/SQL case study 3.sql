/*
 Problem Statement:
 You are the database developer of an international bank. You are responsible for
 managing the bank’s database. You want to use the data to answer a few
 questions about your customers regarding withdrawal, deposit and so on,
 especially about the transaction amount on a particular date across various
 regions of the world. Perform SQL queries to get the key insights of a customer.
 
 Dataset:
 
 The 3 key datasets for this case study are:
 
 a. Continent: The Continent table has two attributes i.e., region_id and
 region_name, where region_name consists of different continents such as
 Asia, Europe, Africa etc., assigned with the unique region id.
 
 b. Customers: The Customers table has four attributes named customer_id,
 region_id, start_date and end_date which consists of 3500 records.
 
 c. Transaction: Finally, the Transaction table contains around 5850 records
 and has four attributes named customer_id, txn_date, txn_type and
 txn_amount.
 
 */

create database case_study_3;
use case_study_3;

-- Import flat files

select * from [transaction]
/* Transaction is a reserved key word in sql. Hence, we have to enclose it in square bracket to tell sql that it is a table name. */
select * from continent
select * from customers;

-- 1.  Display the count of customers in each region who have done the transaction in the year 2020

select count(distinct customer_id) as ct from [Transaction] where year(txn_date)=2020

-- 2.  Display the maximum and minimum transaction amount of each transaction type

select txn_type, max(txn_amount) as max_trans, min(txn_amount) as min_trans
from [Transaction]
group by txn_type

-- The above query shows the min txn_amount as 0 for deposit
-- Let us check how many records have txn_amount = 0

select * from [Transaction] where txn_amount=0;
-- The above query shows only one record where the txn_amount=0

-- Let's say we want to find the minimum txn_amoun for deposit other than zero
-- So, we can implement transaction and drop the row that txn_amount=0
-- Then we run the query max and min txn amount
-- Once, we get our outpu, we can roll back the transaction

begin transaction
delete from [Transaction]
where txn_amount=0

select txn_type, max(txn_amount) as max_trans, min(txn_amount) as min_trans
from [Transaction]
group by txn_type

rollback transaction

/* 3.  Display the customer id, region name and transaction amount where
 transaction type is deposit and transaction amount > 2000 */

 select * from [Transaction];
 select * from Continent
 select * from Customers

 select t.customer_id, region_name, txn_amount
 from [Transaction] as t
 inner join
 Customers as cu
 on t.customer_id=cu.customer_id
 inner join
 Continent as c
 on cu.region_id=c.region_id
 where txn_type='deposit' and txn_amount>2000;

-- 4. Find the duplicate records in the customer table

select * from Customers;

select customer_id, count(*) as ct from Customers
group by customer_id
having count(*)>1

/* 5. Display the customer id, region name, transaction type and transaction
 amount for the minimum transaction amount in deposit .*/

 select t.customer_id, region_name, txn_type, txn_amount
 from [Transaction] as t
 inner join
 Customers as cu
 on t.customer_id=cu.customer_id
 inner join
 Continent as c
 on cu.region_id=c.region_id
 where txn_type='deposit' and txn_amount = (select min(txn_amount) from [Transaction]);

 /* 6. Create a stored procedure to display details of customers in the
 Transaction table where the transaction date is greater than Jun 2020 */

create procedure cust_details(@customer_id int)
as
select * from [Transaction] where txn_date>'2020-06-30' and customer_id=@customer_id;
Go

exec cust_details 75;

/* 7.  Create a stored procedure to insert a record in the Continent table. */

select * from Continent

create procedure conti_record(@region_id int, @region_name varchar(20))
as
insert into Continent (region_id, region_name)
values
(@region_id, @region_name);
GO

exec conti_record 6, 'South America';

select * from Continent

delete from Continent
where region_id=6;


/* 8. Create a stored procedure to display the details of transactions that
 happened on a specific day. */

 create procedure txn_day(@txn_date date)
 as
 select * from [Transaction] where txn_date=@txn_date
 go

 exec txn_day '2020-01-21';

 /* 9. Create a user defined function to add 10% of the transaction amount in a
 table */

 create function txn_amount_10(@amount float)
 returns float
 as
 begin
 return @amount*0.1
 end

 select *, dbo.txn_amount_10(txn_amount) as trans_10 from [Transaction]

 /* 10. Create a user defined function to find the total transaction amount for a
 given transaction type */

 create function txn_type_total(@txn_type varchar(20))
 returns table
 as
 return (select sum(txn_amount) as total_trxn from [Transaction] where txn_type=@txn_type);

 select * from txn_type_total('deposit');
 select * from txn_type_total('purchase');

 /* 12.  Create a TRY...CATCH block to print a region id and region name in a
 single column */

 set implicit_transactions on;

 begin try
 select CONCAT(cast(region_id as varchar(10)), '-> ', region_name) as combine_string from continent;
 end try
 begin catch
 print 'an error occured' + error_message();
 end catch

 /* 13. Create a TRY...CATCH block to insert a value in the Continent table .*/

 begin try
 insert into Continent(region_id, region_name) values
 (6, 'South America'),
 (7, 'Antartica');
 end try
 begin catch
 print 'an error occured' + error_message();
 end catch

 select * from Continent

 /*delete from Continent
 where region_id=6 and region_id=7*/
 -- The above code showed error because of the 'and' operator
 -- region_id cannot have two values at the same time
 -- The corrected code is below

 delete from Continent
 where region_id=6 or region_id=7

 /* 14. Create a trigger to prevent deleting a table in a database. */
 
 create trigger prevent_table_deletion
 on database
 for drop_table
 as
begin
	print 'Table deletion is not allowed'
	rollback transaction
end

drop table Continent;
-- The transaction ended in the trigger. The batch has been aborted.
-- We get the abov error when we drop the table

drop trigger prevent_table_deletion on database;

-- Suppose we want to create a trigger against dropping a specific table

/* create trigger prevent_table_deletion
on database
after drop_table
as
begin
	declare @tablename nvarchar(128)

	-- Retrieve the table name being dropped
	select @tablename = EVENTDATA().value('(/event_instance/object_name)[1]', 'nvarchar(128)')

	if @tablename='Continent'
   	begin
		raiserror('Deletion of continent table is not allowed', 16,1)
		ROLLBACK Transaction
	end
end
*/

drop table continent;

-- The above code is not working
-- It is supposed to prevent the deletion of tabel
-- But it is not doing so
-- Let us see a different code


CREATE TRIGGER prevent_table_deletion
ON DATABASE
AFTER DROP_TABLE
AS
BEGIN
    DECLARE @TableName NVARCHAR(128);

    -- Retrieve the table name being dropped
    SELECT @TableName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(128)');

    -- Debugging message to ensure the trigger is firing
    PRINT 'Trigger fired for table: ' + @TableName;

    IF @TableName = 'Continent'
    BEGIN
        -- Raise an error if the table 'Continent' is being dropped
        RAISERROR('Deletion of Continent table is not allowed!', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        PRINT 'Table deletion allowed for: ' + @TableName;
    END
END

drop table Continent
-- When we attempt to the drop this table, we get the following output:
/* Trigger fired for table: Continent
Msg 50000, Level 16, State 1, Procedure prevent_table_deletion, Line 17 [Batch Start Line 216]
Deletion of Continent table is not allowed!
Msg 3609, Level 16, State 2, Line 217
The transaction ended in the trigger. The batch has been aborted. */

select * from Continent

/* Let us understand some of the terms of the above code

 SELECT @TableName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(128)');

 In the above code:
 
 eventdata() - It is a system function in sql that captures detailed information about the event that triggered the DDL trigger
 It returns an XML result that contains metadata about the event (such as type of operation, the name of the affected object
 (in this case the table) and the user who executed the event)

 .value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(128)')
 - This is an XML query on the data returned by eventdata().
 - It navigates through the XML structure to extract the value of the OBJECTNAME(in this case our table) element.
 - (/EVENT_INSTANCE/ObjectName)[1]: 
 - This XPath-like expression extracts the value of the <ObjectName> node, which represents the name of the object
(the table in this case) that triggered the event. 
/EVENT_INSTANCE is the root node in the XML returned by EVENTDATA(), 
and ObjectName is the child node that holds the table name.
 
 -The [1] means "get the first occurrence of this element," 
 which is useful when there might be multiple occurrences (though in this case, there should only be one table name).
 
 -'NVARCHAR(128)': This is the data type to which the result is converted. 
 In this case, it converts the value of ObjectName to an NVARCHAR(128) string.

 Example of EventData():

 <EVENT_INSTANCE>
  <EventType>DROP_TABLE</EventType>
  <ObjectName>MyTable</ObjectName>
  <ObjectType>TABLE</ObjectType>
  <TSQLCommand>DROP TABLE MyTable;</TSQLCommand>
  <LoginName>sa</LoginName>
</EVENT_INSTANCE>

RAISERROR ('Deletion of MyTable is not allowed!', 16, 1)
What is 16,1 in the above line?

1. 16 (Severity Level):
The severity level indicates how serious the error is. In SQL Server, severity levels range from 0 to 25.
16 is a common severity level for user-defined errors. 
It indicates general errors that can be corrected by the user. 
In this case, it is used to report an application error that doesn't crash the system but needs to be addressed by the user or developer.
Severity levels:
0–10: Informational messages, not considered as errors.
11–16: Errors that the user can fix (like invalid input).
17–25: System and hardware failures.

1 (State):
The state is an integer value that helps identify the location in the code where the error occurred. 
It is used to provide more context about the error.
In most user-defined errors, the state is just set to 1, meaning that it is a general user-defined error.
The state can be any value between 0 and 255, 
allowing developers to specify different states for the same error message to track different scenarios.
*/


/* 17. Display top n customers on the basis of transaction type. */

declare @n int;
set @n=3

create function top_n_cus(@n int, @txn_type varchar(50))
returns table
as
return select top(@n) customer_id, txn_type, txn_amount from [Transaction] where txn_type=@txn_type order by txn_amount desc

/*drop function top_n_cus */ -- to drop a function

select * from dbo.top_n_cus(3, 'purchase');

