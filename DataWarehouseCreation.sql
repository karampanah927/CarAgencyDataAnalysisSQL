-- DimCar  --> categoryCar 

use DBTest1
select * from car_ads
--============================
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


create table DimBrand (
	brandKey int identity(1,1) not null primary key,
    brandAlterKey int ,  -- bussiness key 
    car_brand nvarchar(50) not null,
    brand_category nvarchar(3)
);
---
create table DimCar (
	carKey int identity(1,1) not null primary key
    carAlterKey int,  -- bussiness key 
    brandKey int,
    PriceRange nvarchar(20),
    car_status nvarchar(20),
);
-----------------------------
create table DimAd (
    ad_key int identity(1,1) not null primary key,
    adAlter int not null,
    carKey int not null,
    product_type nvarchar(20),
    first_zip_digit tinyint,
    first_registration_year int,
    --created_date date,
    --deleted_date date,
	demand_category nvarchar(30)
	, stock_days bigint,

,
    constraint fk_DimAd_DimCar foreign key (carkey) references DimCar (carkey)
);
-----------------------------
create table DimDate (
    date_key int  primary key,
	FullDateAlterKey date not null,
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

------------------------------
create table FactMarketing (
	FactMarketingKey int,
    ad_key int not null, 
    geo_key tinyint, 
    created_date_key int,
	created_date_FullDate date,
    deleted_date_key int,
	deleted_date_FullDate date,
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
    constraint fk_FactMarketing_DimGeography foreign key (geo_key) references DimGeography (geo_key),
    constraint fk_FactMarketing_CreatedDate foreign key (created_date_key) references DimDate (date_key),
    constraint fk_FactMarketing_DeletedDate foreign key (deleted_date_key) references DimDate (date_key)
);
