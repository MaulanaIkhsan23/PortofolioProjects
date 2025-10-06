select *
from PortofolioProject..Sales


-- All the company revenue and profit 

select sum(revenue) as total_revenue, sum(profit) as total_profit
from PortofolioProject..Sales





-- 5 product with the highest revenue

select top 5 Product, Revenue
from PortofolioProject..Sales
order by Revenue desc





-- 5 product with the highest profit

select top 5 Product, Profit
from PortofolioProject..Sales
order by Profit desc





-- Average order quantity per transaction

select *
from PortofolioProject..Sales

select Product, AVG (order_quantity) as avg_quantity
from PortofolioProject..Sales
group by Product
order by avg_quantity desc





-- transaction per country

select *
from PortofolioProject..Sales

select Country, count(Order_Quantity) as transaction_per_country
from PortofolioProject..Sales
group by country
order by transaction_per_country desc





-- distribute costumer based on age group

select *
from PortofolioProject..Sales

select age_group, count(age_group) as total_costumers
from PortofolioProject..Sales
group by Age_Group
order by total_group desc






-- Difference between M and F revenue

select *
from PortofolioProject..Sales

SELECT Customer_Gender, SUM(Revenue) AS Total_Revenue
FROM PortofolioProject..Sales
GROUP BY Customer_Gender






-- Countries with the youngest average customer age

select *
from PortofolioProject..Sales

SELECT top 1 Country, avg(Customer_Age) as avg_age
FROM PortofolioProject..Sales
where Customer_Age < 25
GROUP BY Country
order by avg_age asc






-- 5 countries with the highest revenue

select *
from PortofolioProject..Sales

SELECT top 5 Country, sum(Revenue) as total_revenue
FROM PortofolioProject..Sales
GROUP BY Country
order by total_revenue desc






-- customers under 25 y.o total transaction

select *
from PortofolioProject..Sales

SELECT Customer_Age, count(Order_Quantity) as transaction_under25
FROM PortofolioProject..Sales
where Customer_Age < 25
GROUP BY Customer_Age
order by transaction_under25 asc





-- product with the most sales

select *
from PortofolioProject..Sales

SELECT top 10 Product, sum(Order_Quantity) as total_sales
FROM PortofolioProject..Sales
GROUP BY Product
order by total_sales desc





-- Sub-category with the most profit

select *
from PortofolioProject..Sales

SELECT top 1 Sub_Category, sum(Profit) as most_profit
FROM PortofolioProject..Sales
GROUP BY Sub_Category
order by most_profit desc





-- Top 3 product per category based on revenue

select *
from PortofolioProject..Sales

SELECT Product_Category, Product, best_product
FROM (select Product_Category, Product, sum(revenue) as best_product,
	ROW_NUMBER () over (partition by product_category order by sum(revenue) desc) as rn
	FROM PortofolioProject..Sales
	group by Product_Category, Product) t
where rn <= 3





-- Average margin profit per category

select *
from PortofolioProject..Sales

SELECT Product_Category, AVG(cast(profit as float)/ nullif(revenue, 0)) as avg_margin
FROM PortofolioProject..Sales
GROUP BY Product_Category
order by avg_margin desc





-- Negative Profit

select *
from PortofolioProject..Sales

select *
FROM PortofolioProject..Sales
where Profit < 0
order by Profit asc





-- Revenue tren per years

select *
from PortofolioProject..Sales

select Year, sum(revenue) as revenue_per_year
FROM PortofolioProject..Sales
group by Year
order by year asc





-- Month with the highest sales

select *
from PortofolioProject..Sales

select top 1 Month, sum(Revenue) as highest_sales
FROM PortofolioProject..Sales
group by Month
order by highest_sales





-- Difference revenue Weekend vs Weekdays

select *
from PortofolioProject..Sales

select
 case when DATENAME(WEEKDAY, date)  in ('saturday', 'sunday') then 'Weekend'
	  else 'Weekdays'
	  end as DayType,
 sum(revenue) as week_revenue
FROM PortofolioProject..Sales
group by  case when DATENAME(WEEKDAY, date)  in ('saturday', 'sunday') then 'Weekend'
	  else 'Weekdays' end
order by week_revenue desc





-- Average profit per month in 2015

select *
from PortofolioProject..Sales

select Month, avg(Profit) as avg_profit
FROM PortofolioProject..Sales
where year = 2015
group by Month
order by avg_profit desc





-- Is the revenue increase in 2013 t0 2016?

select *
from PortofolioProject..Sales

select Year, sum(Revenue) as sum_revenue
FROM PortofolioProject..Sales
where year between 2013 and 2016
group by Year
order by Year asc





-- Country with the highest profit and margin 

select *
from PortofolioProject..Sales

SELECT top 1 Country, SUM(Profit)/ SUM(Revenue) AS Profit_Margin
FROM PortofolioProject..Sales
GROUP BY Country
ORDER BY Profit_Margin DESC





-- Top 5 countries with highest revenue

select *
from PortofolioProject..Sales

SELECT top 5 Country, SUM(Revenue) AS sum_Margin
FROM PortofolioProject..Sales
GROUP BY Country
ORDER BY sum_Margin DESC





-- Product with order quantity > 10 

select *
from PortofolioProject..Sales

SELECT distinct Product
FROM PortofolioProject..Sales
where Order_Quantity > 10






-- Contribute percentage category product to total revenue

select *
from PortofolioProject..Sales

SELECT Product_Category,
		sum(revenue) as Category_Revenue,
		sum(revenue) * 100 / (select sum(Revenue) from PortofolioProject..Sales) as Percentage_revenue
FROM PortofolioProject..Sales
group by Product_Category
order by Percentage_revenue desc






-- The most ideal customer with highest revenue

select *
from PortofolioProject..Sales

SELECT top 1 Country, Customer_Age, Customer_Gender, sum(revenue) Ideal_Cust_Revenue
FROM PortofolioProject..Sales
group by Country, Customer_Age, Customer_Gender
order by Ideal_Cust_Revenue desc
