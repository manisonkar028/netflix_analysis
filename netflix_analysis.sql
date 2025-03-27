-- Analysis 1. Count no of Movies vs TV shows

select 
count (case when type='Movie' then 1 end) as movie_count,
count(case when type='TV Show' then 1 end) as TVShow_count
from netflix

select type,count(*) as total_count
from netflix
group by type


-- Analysis 2. most common rating for movies and tv show

select type, rating
from(
select type,
	rating,
	count(*),
	rank() over(partition by type order by count(*) desc) as ranking
	from netflix
	
	group by 1,2) as t1
	where ranking = 1


-- Analysis 3. List all movies released in a specific year (e.g. 2020)

select * from netflix
where type='Movie' and (release_year)= 2020


--Analysis 4. find top 5 countries with most content on Netflix


select 
	unnest(string_to_array(country,',')) as new_country,
	count(show_id) as total_content 
from netflix
group by 1
order by total_content desc limit 5

-- Analysis 5. Identify the longest movie

select duration from netflix
where type='Movie'
and duration=(select max(duration) from netflix)

--Analysis 6. Find content added in last 5 years

select * from netflix
where 
to_date(date_added,'Month DD, YYYY')>= current_date - interval '5 years'


--Analysis 7. Find all movies by director 'Rajiv Chilaka'


select * from netflix
where
director like '%Rajiv Chilaka%'
and
type='Movie'

--Analysis 8. List all TV shows with more than 5 seasons


select * from netflix
where type='TV Show'
and
split_part(duration,' ',1):: numeric>5

--Analysis 9.count no. of content item in each genre
select 
unnest(string_to_array(listed_in,','))as genre,
count(show_id) as total_content
from netflix
group by 1

--Analysis 10. FInd each year and number of content release by India on Netflix
-- return top5 year with highest avg content release:


select
	extract(Year from to_date(date_added,'Month,DD,YYYY')) as Year,
	count(*),
	Round(count(*)::numeric/(select count(*) from netflix where country='India')*100,2) as Average_content
from netflix
where country = 'India'
group by 1

-- Analysis 11. List all movies that are documentries

select * from netflix
where type='Movie' 
and
listed_in like '%Documentaries%'

--Analysis 12. Find all content without a director

select * from netflix
where director is null



--Analysis 13. find how many movies actor 'salman khan' appeared in last 10 years

select * from netflix
where casts ilike '%Salman Khan%'
and release_year>extract(year from current_date) - 10

--Analysis 14. top 10 actors appeared in the highest number of movies produces in india.

select 
	unnest(string_to_array(casts,','))as Actors,
	count(*) as total_content
	from netflix
	where country ilike '%India%'
	group by 1
	order by 2 desc limit 10

--Analysis 15. categorize content based on the presence of keyword 'kill' and 'violence' in the description field.
--Label content containing the keyword as 'bad' and all other as 'Good'.
-- count how many fall in each category

with my_cte as(
select * ,
	case 
	when 
		description ilike '%kill%' or
		description ilike'%violence%' then 'Bad'
		else 'Good'
	end category
from netflix
)
select category,count(*) from my_cte
group by category




