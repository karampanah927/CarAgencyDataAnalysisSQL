/*
Dataware : Star
	1- DimAd()
	2- Dimdate
	3- DimGeography
	4-DimBrand
	5- FactMarketing
	
	declare @d date='2024-11-12'
	select FORMAT(@d,'yyyyMMdd')

	update dimdate set datekey=FORMAT(fulldate,'yyyyMMdd')
	*/

select * from car_ads

create table DimCar (
    car_id int identity(1,1) not null primary key,
    car_brand nvarchar(50),
    PriceRange nvarchar(20),
    car_status nvarchar(20),
    demand_category nvarchar(30)
);
-----------------------------
create table DimAd (
    ad_key int identity(1,1) not null primary key,
    ad_id int not null,
    car_id int not null,
    product_type nvarchar(20),
    first_zip_digit tinyint,
    first_registration_year int,
    created_date date,
    deleted_date date,
    constraint fk_DimAd_DimCar foreign key (car_id) references DimCar (car_id)
);
-----------------------------
create table DimDate (
    date_key int identity(1,1) primary key,
    dt date not null,
    year int,
    quarter int,
    month int,
    day int,
    week int,
    day_of_week nvarchar(10)
);
----------------------------
create table DimGeography (
	geo_key tinyint identity(1,1) primary key,
    first_zip_digit tinyint,
    geographic_region nvarchar(100)
);
----------------------------
create table DimBrand (
    brand_id int identity(1,1) not null primary key,
    car_brand nvarchar(50) not null,
    brand_category nvarchar(3)
);
------------------------------
create table FactMarketing (
    ad_key int not null, 
    geo_key tinyint, 
    created_date_key int,
    deleted_date_key int,
    stock_days bigint,
    ctr float,
    views bigint,
    clicks bigint,
    sale_velocity float,
    click_per_stock_day float,
    ctr_rank_over_category bigint,
    ctr_rank_over_brand bigint,
    stock_days_rank_over_category bigint,
    stock_days_rank_over_brand bigint,
    constraint fk_FactMarketing_DimAd foreign key (ad_key) references DimAd (ad_key),
    constraint fk_FactMarketing_DimGeography foreign key (geo_key) references DimGeography (first_zip_digit),
    constraint fk_FactMarketing_CreatedDate foreign key (created_date) references DimDate (dt),
    constraint fk_FactMarketing_DeletedDate foreign key (deleted_date) references DimDate (dt)
);
-------------------------------------
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

