-- Initial Data Insertion

exec maindatacleansing;
print 'maindatacleansing is executed';

go
insert into DimCar (car_brand ,
					PriceRange,
					car_status,
					demand_category)
select distinct car_brand ,
				PriceRange,
				car_status,
				demand_category
from car_ads;
--------------------------------------
insert into DimAd(ad_id,
				car_id,
				product_type,
				first_zip_digit,
				first_registration_year,
				created_date,
				deleted_date)
select distinct ad_id,
				car_id,
				prodduct_type,
				first_zip_digit,
				first_registration_year,
				created_date,
				deleted_date
from car_ads ca
inner join DimCar dc on ca.car_brand = dc.car_brand;

--------------------------------
insert into DimBrand (car_brand,
						brand_category)
select distinct car_brand, 
                brand_category
from car_ads;
---------------------------------
insert into FactMarketing (ad_key, 
							geo_key, 
							created_date_key, 
							deleted_date_key, 
							stock_days, 
							ctr, 
							views, 
							clicks, 
							sale_velocity, 
							click_per_stock_day, 
							ctr_rank_over_category, 
							ctr_rank_over_brand, 
							stock_days_rank_over_category, 
							stock_days_rank_over_brand
)
select distinct da.ad_key,
                dg.geo_key,
                ddc.date_key AS created_date_key,
                ddd.date_key AS deleted_date_key,
                ca.stock_days,
                ca.ctr,
                ca.views,
                ca.clicks,
                ca.sale_velocity,
                ca.click_per_stock_day,
                ca.ctr_rank_over_category,
                ca.ctr_rank_over_brand,
                ca.stock_days_rank_over_category,
                ca.stock_days_rank_over_brand
from car_ads ca
join DimAd da on ca.ad_id = da.ad_id
join DimGeography dg on ca.first_zip_digit = dg.first_zip_digit
join DimDate ddc on ca.created_date = ddc.dt
join DimDate ddd on ca.deleted_date = ddd.dt;

--------------------

insert into dimdate (full_date, year, quarter, month, day, week, day_of_week)
select distinct created_date as full_date,
year(created_date) as year,
ceiling(month(created_date) / 3.0) as quarter,
month(created_date) as month,
day(created_date) as day,
datepart(week, created_date) as week,
datename(weekday, created_date) as day_of_week
from car_ads
where created_date is not null

union

select distinct deleted_date as full_date,
year(deleted_date) as year,
ceiling(month(deleted_date) / 3.0) as quarter,
month(deleted_date) as month,
day(deleted_date) as day,
datepart(week, deleted_date) as week,
datename(weekday, deleted_date) as day_of_week
from car_ads
where deleted_date is not null;




