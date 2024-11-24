-------------------------------------
insert into DimBrand (brandAlterKey  ,  
    car_brand ,
    brand_category)
select distinct ROW_NUMBER()over(order by car_brand),car_brand, 
                brand_category
from car_ads;
-------------------------------------
insert into DimCar (carAlterKey  ,   brandKey ,
    PriceRange,
    car_status)
select distinct ROW_NUMBER()over(order by car_brand),car_brand ,
				PriceRange,
				car_status
from car_ads;
--------------------------------------
insert into DimAd(
    adAlter ,
    carKey ,
    product_type,
    first_zip_digit,
    first_registration_year,
	demand_category
	, stock_days
				)
select distinct ad_id,
				carKey,
				product_type,
				first_zip_digit,
				first_registration_year
				demand_category
				, stock_days
from car_ads ca
	inner join DimCar dc on ca.car_brand = dc.car_brand;

--------------------------------

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

--================
select *,format(created_date,'YYYYMMDD') from car_ads


alter table car_ads alter column created_date date
alter table car_ads alter column deleted_date date

