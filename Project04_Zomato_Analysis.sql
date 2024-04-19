-- Create DataBase
create database Project04_Zomato_Analysis ;

--Use the DataBAse 
use Project04_Zomato_Analysis ; 

--Create Table..
--Gold USer Tables
drop table if exists goldusers_signup ;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');


-- USer Tables ;
drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');


-- Sales Tables
drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);

--Products Tables ; 
drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

--See All The Tables..
select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

--Total  Amount Spend By Each Users
select a.userid , sum(price) as Amount_Spend_By_Each_Customers
from sales a inner join product b
on a.product_id = b.product_id 
group by a.userid
order by Amount_Spend_By_Each_Customers desc; 


--How many days customer visited zomato..
select  userId , count(distinct created_date) as Numbers_of_Repeating_Frequnetly
from sales
group by userId;


--First Product of Each Customers or we can first order Also .......
select created_date , userid , product_id
from (select * , rank() over(partition by userId order by created_date) as Rnks
from sales) A
where rnks = 1;  

--Most Purchase Products
select product_id , count(product_id) as Numbers_of_orders
from sales
group by product_id
order by Numbers_of_orders desc;


--Ranking Based on Top Products..
select *  , rank() over(order by Numbers_of_orders desc) as Rnks
from (select product_id , count(product_id) as Numbers_of_orders
from sales
group by product_id) A ; 

--Which Item was popular for each customers..
select userId , product_id , count(product_id) as Numbers_Of_orders
from sales 
group by userId , product_id; 

--Given The Ranking And Take The Top Products of Each Customers...
select *  
from (select userId , product_id , count(product_id) as Numbers_Of_orders ,
DENSE_RANK() over(partition by userId order by count(product_id) desc) Rnks
from sales 
group by userId , product_id) A
where Rnks = 1; 


--Which Item Was Purchased first by the customer After they became a members..
-- First Product Purchase Also ..
select userid , gold_signup_date , created_date as Order_Date , product_id
from (select * , dense_rank() over(partition by userID order by created_Date) as Rnks
from (select a.gold_signup_date , a.userid , b.created_date , b.product_id
from goldusers_signup a inner join sales b
on a.userid = b.userId) A 
where gold_signup_date <= created_date) B 
where Rnks = 1 ;


-- Which Item Was Purchased just before the customer became a members..
select userId , created_date ,gold_signup_date , product_id
from (select a.userId , a.created_date ,b.gold_signup_date , a.product_id ,rank() over(partition by a.userId order by a.created_date desc) as Rnks
from sales a inner join goldusers_signup b 
on a.userId = b.userId and b.gold_signup_date >= a.created_date ) ABC
where Rnks = 1 ; 

--Total AMount Spend By Each Customer BEfore they are a memebers..



select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;



