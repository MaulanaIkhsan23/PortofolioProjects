select *
from PortofolioProject.dbo.AmazonBestSeller


-- 10 product with the highest price

select top 10 product_title, product_price
from PortofolioProject.dbo.AmazonBestSeller
where product_price is not null
order by product_price desc




-- 10 product with the lowest rating

select top 10 product_title, product_star_rating
from PortofolioProject.dbo.AmazonBestSeller
where product_star_rating > 0
order by product_star_rating asc



-- Average product price per country

select *
from PortofolioProject.dbo.AmazonBestSeller

select country, avg(product_price) as Avg_Price
from PortofolioProject.dbo.AmazonBestSeller
where product_price is not null
group by country
order by Avg_Price desc



-- product rating > 4.5

select *
from PortofolioProject.dbo.AmazonBestSeller

select count(*) as High_Rating_Product
from PortofolioProject.dbo.AmazonBestSeller
where product_star_rating > 4.5



-- product with the highest number of ratings

select *
from PortofolioProject.dbo.AmazonBestSeller


select top 1 product_title, product_num_ratings
from PortofolioProject.dbo.AmazonBestSeller
order by product_num_ratings desc



-- product with the highest number of ratings and highest rating


select top 10 product_title, product_star_rating, product_num_ratings
from PortofolioProject.dbo.AmazonBestSeller
order by product_star_rating desc, product_num_ratings desc




-- product per page every country

select *
from PortofolioProject.dbo.AmazonBestSeller


select country, page, count(*) as Total_Product
from PortofolioProject.dbo.AmazonBestSeller
group by country, page
order by country, page




-- The highest different price 

select *
from PortofolioProject.dbo.AmazonBestSeller

select product_title, max(product_price) as High_Price
, min(product_price) as Lower_Price
, max(product_price) - min(product_price) as Different_price
from PortofolioProject.dbo.AmazonBestSeller
where product_price is not null
group by product_title
order by Different_price desc




-- top 3 product based on rating

select *
from PortofolioProject.dbo.AmazonBestSeller

select country, product_title, product_num_ratings
from (
	select country, product_title, product_num_ratings,
		ROW_NUMBER() over (partition by country order by product_num_ratings desc) as rn
from PortofolioProject.dbo.AmazonBestSeller
) t
where rn <= 3




-- distribution rating (bucket 1–2, 2–3, 3–4, 4–5)

select 
	case
		when product_star_rating between 1 and 2 then '1-2'
		when product_star_rating > 2 and product_star_rating <= 3 then '2-3'
		when product_star_rating > 3 and product_star_rating <= 4 then '3-4'
		when product_star_rating > 4 and product_star_rating <= 5 then '4-5'
	end as rating_bucket,
	count (product_star_rating) as total_product
from PortofolioProject.dbo.AmazonBestSeller
where product_star_rating > 0
group by product_star_rating
order by product_star_rating




-- Average rating per page

select *
from PortofolioProject.dbo.AmazonBestSeller

select page, avg(product_star_rating) as avg_rating
from PortofolioProject.dbo.AmazonBestSeller
where product_star_rating is not null
group by page
order by page asc




-- Average rating per page for the best product

select *
from PortofolioProject.dbo.AmazonBestSeller

select top 10 product_title, product_star_rating, product_num_ratings, product_star_rating * log(1+product_num_ratings) as score
from PortofolioProject.dbo.AmazonBestSeller
where product_star_rating is not null and product_num_ratings is not null
order by score desc