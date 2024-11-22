/*
Dataware : Snowflake
	1- DimBrandCategory
	2- DimCar
	2- DimAd()
	2- Dimdate
	3- DimGeography
	4-DimBrand
	5- FactMarketing
	*/

select * from car_ads

create table DimBrandCategory (
    brand_id int identity(1,1) not null primary key,
    car_brand nvarchar(50) not null,
    brand_category nvarchar(3)
);
------------------------------
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
