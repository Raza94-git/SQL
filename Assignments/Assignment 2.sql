create database revision_assgn2
use revision_assgn2;

/*
Dataset: Jomato
 
 About the dataset:
 You work for a data analytics company, and your client is a food delivery platform similar to
 Jomato. They have provided you with a dataset containing information about various
 restaurants in a city. Your task is to analyze this dataset using SQL queries to extract valuable
 insights and generate reports for your client.
 
 Tasks to be performed:
 
 1. Create a user-defined functions to stuff the Chicken into ‘Quick Bites’. Eg: ‘Quick
 Chicken Bites’.
 
 2. Use the function to display the restaurant name and cuisine type which has the
 maximum number of rating.
 
 3. Create a Rating Status column to display the rating as ‘Excellent’ if it has more the 4
 start rating, ‘Good’ if it has above 3.5 and below 4 star rating, ‘Average’ if it is above 3
 and below 3.5 and ‘Bad’ if it is below 3 star rating and
 
 4. Find the Ceil, floor and absolute values of the rating column and display the current
 date and separately display the year, month_name and day.
 
 5. Display the restaurant type and total average cost using rollup.
 */

 -- Import flat file Jomato

 select * from Jomato;

 /* 1. Create a user-defined functions to stuff the Chicken into ‘Quick Bites’. Eg: ‘Quick
 Chicken Bites’. */

 create function stuff_fun(@string varchar(50))
 returns varchar(50)
 as
 begin
 return STUFF('Quick Bites', 6,0, ' '+ @string)
 end

 select dbo.stuff_fun('Chicken') as stuff_string;


 /* 2. Use the function to display the restaurant name and cuisine type which has the
 maximum number of rating. */

 select * from Jomato

 select restaurantname, cuisinestype from jomato where No_of_rating = (select max(No_of_Rating) from Jomato);

 /* 3. Create a Rating Status column to display the rating as ‘Excellent’ if it has more the 4
 start rating, ‘Good’ if it has above 3.5 and below 4 star rating, ‘Average’ if it is above 3
 and below 3.5 and ‘Bad’ if it is below 3 star rating */

 select *,
 case
 when rating>4 then 'Excellent'
 when rating between 3.5 and 4 then 'Good'
 when rating between 3.0 and 3.5 then 'Average'
 else 'Bad'
 end
 as rating_category
 from jomato
 order by rating desc;

 /* 4. Find the Ceil, floor and absolute values of the rating column and display the current
 date and separately display the year, month_name and day. */

 select CEILING(rating) as ceil_rating,
		floor(rating) as floor_rating,
		ABS(rating) as absolute_rating,
		getdate() as current_dates,
		year(getdate()) as current_year,
		datename(MM, getdate()) as current_month,
		datename(weekday, getdate()) as current_day
from Jomato;

/*  5. Display the restaurant type and total average cost using rollup. */

select * from Jomato;

select coalesce(restauranttype, 'all restaurants') as restaurant_type, 
sum(averagecost) as total from jomato
group by rollup (restauranttype)
order by sum(averagecost) desc;