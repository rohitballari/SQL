/* Case Studies on SQL.
Case Study #1 - Danny's Diner
Case Study #2 - Pizza Runner
Case Study #3 - Foodie-Fi
Case Study #4 - Data Bank
Case Study #5 - Data Mart
Case Study #6 - Clique Bait
*/

drop database if exists Case_Study_1_DannyS_Diner;
create database Case_Study_1_DannyS_Diner;
use Case_Study_1_DannyS_Diner;



CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  
/* Case Study Questions
Each of the following case study questions can be answered using a single SQL statement:

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?*/

show tables;
select * from members;
select * from menu;
select * from sales;
-- 1. What is the total amount each customer spent at the restaurant?
select s.customer_id,sum(m.price) as Total_amount
from sales s inner join menu m using(product_id)
group by s.customer_id;

select s.customer_id,sum(price) as total_amount from sales s inner join menu m using(product_id) group by s.customer_id;

-- 2. How many days has each customer visited the restaurant?
select customer_id,count(distinct order_date) as No_of_days_visited
from sales group by customer_id;

-- 3. What was the first item from the menu purchased by each customer?
select customer_id,order_date,product_name from (
select *,row_number() over(partition by customer_id order by order_date) as rnk
from sales s inner join menu m using(product_id)) as t
where rnk = 1;


-- 4. What is the most purchased item on the menu and how many times 
-- was it purchased by all customers?

with purchased_details as (
select product_name,count(*) as No_of_purchased,
dense_rank() over(order by count(*) desc) as drnk
from menu m inner join sales s using(product_id)
group by product_name) 
select * from purchased_details where drnk = 1;

-- 5. Which item was the most popular for each customer?

with Customer_Most_popular_item as (
select customer_id,product_name,count(*) as Most_Popular_item,
dense_rank() over(partition by customer_id order by count(*) desc) as drnk
from sales s inner join menu m using(product_id)
group by customer_id,product_name)
select * from Customer_Most_popular_item 
where drnk = 1;

select * from (
select customer_id,product_name,count(*) as no_of_order,rank() over(partition by customer_id order by count(*)desc)rnk
from sales s inner join menu m using(product_id) group by customer_id,product_name)as t where rnk=1;

-- 6. Which item was purchased first by the customer after they 
-- became a member?

with first_purchase as (
select s.customer_id,s.order_date,m.product_name,
row_number() over(partition by s.customer_id order by order_date asc) as rn
from sales s 
inner join menu m using(product_id) inner join members mb 
on s.customer_id=mb.customer_id and s.order_date>mb.join_date)
select * from first_purchase where rn =1;

-- 7. Which item was purchased just before the customer became a member?

with Purchased_before_member as (
select s.customer_id,s.order_date,product_name,
rank() over(partition by customer_id order by order_date desc) rnk
 from sales s 
inner join menu m using(product_id) inner join members mb
on s.customer_id = mb.customer_id and s.order_date <mb.join_date)
select * from Purchased_before_member where rnk = 1;

-- 8. What is the total items and amount spent for each member
-- before they became a member?
select s.customer_id,count(product_name) as Total_Items,
sum(price) as Total_Amount from sales s inner join menu m
using(product_id) inner join members mb on s.customer_id = mb.customer_id
and s.order_date<mb.join_date
group by s.customer_id order by customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points 
-- multiplier - how many points would each customer have?

select s.customer_id, sum(case when product_name = 'sushi' then Price * 10 * 2
else Price * 10 end) as Total_Points  from sales s inner join menu m
using(product_id) group by s.customer_id;	

-- 10. In the first week after a customer joins the program
-- (including their join date) they earn 2x points on all items,
-- not just sushi - how many points do customer A and B have at the end of January?*/

select s.customer_id,sum(case when s.order_date between join_date and date_add(join_date, interval 6 day) then Price * 10 * 2
when product_name = "Sushi" then Price * 10 * 2 else Price * 10 end) as Total_Points
 from sales s inner join menu m using(product_id)
inner join members mb on mb.customer_id = s.customer_id 
where s.order_date <= "2021-01-31"
group by customer_id order by customer_id;


-- Bonus Questions 
select s.customer_id,s.order_date,Product_name,price from sales s inner join menu m using (product_id)
inner join members mb using(customer_id);

select * from members;
select * from menu;
select * from sales;

#1. What is the total amount each customer spent at the restaurant?		
select customer_id,sum(price) as Total_spent from sales inner join menu using(product_id) group by customer_id;

#2. How many days has each customer visited the restaurant?			
select  customer_id, count(distinct order_date) as visited from sales
group by customer_id;

#3. What was the first item from the menu purchased by each customer?							
select customer_id,order_date,product_name from (
select *,row_number()
over(partition by customer_id order by order_date asc) as rn
from sales inner join menu using(product_id)) as t where rn = 1;

#4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select * from(
select product_name,count(*) as no_of_times,
rank() over(order by count(product_name) desc) as rn
from sales inner join menu using(product_id) group by product_name) as t where rn=1;

#5. Which item was the most popular for each customer?		
#without using CTE	
select * from (
select sales.customer_id,menu.product_name,count(*) as no_of_Orders,
rank() over(partition by customer_id order by count(*) desc) as rnk
from sales inner join menu using(product_id) group by customer_id,product_name) as t where rnk = 1;	

#Using CTE
with most_popular_items as (
select *,rank() over(partition by customer_id order by no_of_orders desc) rnk from (
select customer_id,product_name,count(*) as no_of_orders from 
sales inner join menu using(product_id) group by customer_id,product_name) as t)
select * from most_popular_items where rnk = 1;

#6. Which item was purchased first by the customer after they became a member?		
with first_purchased as (
select s.customer_id,order_date,product_name,
row_number() over(partition by s.customer_id order by order_date asc) as rn
from sales s inner join members mb on s.customer_id=mb.customer_id and
s.order_date>mb.join_date inner join menu m using(product_id))
select * from first_purchased where rn = 1;

#7. Which item was purchased just before the customer became a member?
with first_purchased as (
select s.customer_id,order_date,product_name,
row_number() over(partition by s.customer_id order by order_date asc) as rn
from sales s inner join members mb on s.customer_id=mb.customer_id and
s.order_date<mb.join_date inner join menu m using(product_id))
select * from first_purchased where rn = 1;

#8. What is the total items and amount spent for each member before they became a member?		
select s.customer_id,count(*) as Total_Items,sum(price) as Total_amount from sales as s
inner join members as mb on s.customer_id=mb.customer_id and s.order_date < mb.join_date 
inner join menu m using(product_id) group by s.customer_id order by s.customer_id;

#9. If each person $1 spent equates to 10 points and sushi has a 2x points multiplier 
#how many points would each customer have?
select customer_id,sum(case when product_name = 'sushi' then price * 20 else price * 10 end) as Total_points
from sales s inner join menu m using(product_id) group by customer_id;

/*10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
not just sushi - how many points do customer A and B have at the end of January?*/
select s.customer_id,sum(case when order_date between mb.join_date and date_add(join_date,interval 7 day)
then price * 20 when product_name= 'sushi' then price * 20 else price * 10 end ) as Total_Points
from sales s inner join members mb using(customer_id) inner join menu m using(product_id)
where order_date <= '2021-01-31'
group by s.customer_id order by customer_id;

#assignment
#1. How many unique customers are there?
select COUNT(DISTINCT customer_id) as unique_customers from Members;

#2. What is the total number of sales recorded?
select COUNT(*) as total_sales from Sales;

#3. What is the name and price of the most expensive item on the menu?
select product_name, price from Menu order by price desc limit 1;
 
#4. Which customer made the most purchases?
select customer_id, COUNT(*) as purchase_count from Sales group by customer_id
order by purchase_count desc limit 1;

#5. How many times was each product sold?
select M.product_name, COUNT(S.product_id) as sales_count from Sales S
join Menu M on S.product_id = M.product_id group by M.product_name;

#6. On which date was the highest number of orders placed?
select order_date, COUNT(*) as order_count from Sales
group by order_date order by order_count desc limit 1;

#7. How many customers joined after 2021-01-10?
select COUNT(*) as customers_joined_after from Members where join_date > '2021-01-10';

#8. How many orders were placed on each date?
select order_date, COUNT(*) as total_orders from Sales group by order_date
order by order_date;

#9. What is the total number of orders for each product?
select M.product_name, COUNT(*) as total_orders from Sales S join Menu M on S.product_id = M.product_id
group by M.product_name order by total_orders desc;

#10. Which product was never ordered?
select product_name from Menu where product_id not in (select DISTINCT product_id from Sales);



							




				






