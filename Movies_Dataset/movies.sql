drop database if exists movies;
create database movies;
use movies;
show tables;
select * from actor;
select * from cast;
select * from director;
select * from genres;
select * from movie;
select * from movie_direction;
select * from movie_genres;
select * from ratings;
select * from reviewer;



#i. Write a SQL query to find when the movie 'American Beauty' released. Return movie release year.
select * from movie;
select mov_title,mov_year from movie where mov_title = 'American Beauty';

#ii. Write a SQL query to find those movies, which were released before 1998. Return movie title.
select mov_year,mov_title from movie where mov_year < '1998';

/*iii. Write a query where it should contain all the data of the movies which were 
released after 1995 and their movie duration was greater than 120. */
select * from movie where mov_year > '1995' and mov_time > '120';

#i. Write a SQL query to find when the movie 'American Beauty' released. Return movie release year.
select mov_title,mov_year from movie where mov_title =  'American Beauty';

#ii. Write a SQL query to find those movies, which were released before 1998. Return movie title.
select mov_title,mov_year from movie where mov_year < '1998';

/*iii. Write a query where it should contain all the data of the movies which were 
released after 1995 and their movie duration was greater than 120. */
select * from movie where mov_year > '1995' and mov_time> '120';

/*iv. Write a query to determine the Top 7 movies which were released in United 
Kingdom. Sort the data in ascending order of the movie year.*/
select * from movie order by mov_rel_country = 'UK' asc limit 7;

/*iv. Write a query to determine the Top 7 movies which were released in United 
Kingdom. Sort the data in ascending order of the movie year.*/
select * from movie order by mov_rel_country = 'uk' asc limit 7;

/*v. Set the language of movie language as 'Chinese' for the movie which has its 
existing language as Japanese and the movie year was 2001.*/
update movie set mov_lang = 'chinese' where mov_lang = 'Japanese' and mov_year ='1958';

select * from movie;
update movie set mov_lang = 'chinese'where mov_lang='Japanese' and mov_year = '2001';

#vi. Write a SQL query to find name of all the reviewers who rated the movie 'Slumdog Millionaire'.
select * from movie m inner join ratings r using (mov_id) inner join reviewer re using (rev_id) where 
mov_title = 'Slumdog Millionaire';

/*vii. Write a query which fetch the first name, last name & role played by the 
actor where output should all exclude Male actors.*/
#select act_fname,act_lname,role (
select actor.act_fname,actor.act_lname,cast.role from actor inner join 
cast on actor.act_id = cast.act_id 
where actor.act_gender != 'M';

/*viii. Write a SQL query to find the actors who played a role in the movie 'Annie Hall'.
Fetch all the fields of actor table. (Hint: Use the IN operator)*/
select * from actor where act_id in
(select act_id from cast inner join movie on
 cast.mov_id = movie.mov_id where movie.mov_title = 'Annie Hall');
 
/*ix. Write a SQL query to find those movies that have been released in countries other 
than the United Kingdom. Return movie title, movie year, movie time, and date of 
release, releasing country.*/
select mov_title,mov_year,mov_time,mov_dt_rel,mov_rel_country from movie where mov_rel_country != 'UK';

/*x. Print genre title, maximum movie duration and the count the number of 
movies in each genre. (HINT: By using inner join)*/
select genres.gen_title,
max(movie.mov_time) as max_mov_dur,count(movie.mov_id) as no_of_mov
from genres
 inner join movie_genres on genres.gen_id = movie_genres.gen_id group by movie.mov_id;
 
 -- doubt
 
 
select genres.gen_title,
max(movie.mov_time) as max_mov_dur,count(movie.mov_id) as no_of_mov
from genres inner join movie_genres using(gen_id) inner join movie using(mov_id)
 group by genres.gen_title;

/*xi. Create a view which should contain the first name, last name, title of the 
movie & role played by particular actor.*/
create view view1 as
select actor.act_fname,actor.act_lname,movie.mov_title ,cast.role from actor
inner join cast using(act_id)
inner join movie using(mov_id);

select * from view1;
 
select * from genres;
select * from movie;
select * from movie_genres;
select * from rat;


#xii. Write a SQL query to find the movies with the lowest ratings
select * from(
select *,dense_rank() over(order by num_o_ratings asc) as drnk from(
select * from movie inner join ratings using(mov_id)
where num_o_ratings !='') as t) where drnk = 1;
   
 #write a query to replace the shelf 5 with blank values
 
#sql query to print the movie details who has third highest number of ratings also display the actors details
select * from(
select movie.*,actor.act_fname,ratings.num_o_ratings, dense_rank() 
over(order by ratings.num_o_ratings desc) rnk 
from movie inner join ratings using (mov_id) inner join cast using(mov_id) join actor using(act_id))
as t where rnk = 3;

select * from(
select concat(act_fname,act_lname) as actor_name,
movie.*,ratings.num_o_ratings, dense_rank() 
over(order by ratings.num_o_ratings desc) rnk 
from movie inner join ratings using (mov_id) inner join cast using(mov_id) join actor using(act_id))
as t where rnk = 3;


select * from movie;
select * from cast;
select * from actor;