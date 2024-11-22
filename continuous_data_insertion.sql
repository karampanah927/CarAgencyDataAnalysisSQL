-- Inserting new records after comparison our data warehouse and the source
create procedure usp_insertdata
as
begin
    set nocount on;

    -- insert into dimdate
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

    -- insert into dimcar
    merge dimcar as b
    using (select distinct car_brand, pricerange, car_status, demand_category from car_ads) as a
    on b.car_brand = a.car_brand
    when matched then
        update set b.pricerange = a.pricerange, b.car_status = a.car_status, b.demand_category = a.demand_category
    when not matched then
        insert (car_brand, pricerange, car_status, demand_category)
        values (a.car_brand, a.pricerange, a.car_status, a.demand_category);

    -- insert into dimad
    merge dimad as b
    using (select distinct ad_id, dc.car_id, product_type, first_zip_digit, first_registration_year, created_date, deleted_date
           from car_ads ca
           inner join dimcar dc on ca.car_brand = dc.car_brand) as a
    on b.ad_id = a.ad_id
    when matched then
        update set b.car_id = a.car_id, b.product_type = a.product_type, b.first_zip_digit = a.first_zip_digit,
                   b.first_registration_year = a.first_registration_year, b.created_date = a.created_date,
                   b.deleted_date = a.deleted_date
    when not matched then
        insert (ad_id, car_id, product_type, first_zip_digit, first_registration_year, created_date, deleted_date)
        values (a.ad_id, a.car_id, a.product_type, a.first_zip_digit, a.first_registration_year, a.created_date, a.deleted_date);

    -- insert into dimbrand
    merge dimbrand as b
    using (select distinct car_brand, brand_category from car_ads) as a
    on b.car_brand = a.car_brand
    when matched then
        update set b.brand_category = a.brand_category
    when not matched then
        insert (car_brand, brand_category)
        values (a.car_brand, a.brand_category);

    -- insert into dimgeography
    merge dimgeography as b
    using (select distinct first_zip_digit, geographic_region from car_ads) as a
    on b.first_zip_digit = a.first_zip_digit
    when matched then
        update set b.geographic_region = a.geographic_region
    when not matched then
        insert (first_zip_digit, geographic_region)
        values (a.first_zip_digit, a.geographic_region);

    -- insert into factmarketing
    insert into factmarketing (ad_key, geo_key, created_date_key, deleted_date_key, stock_days, ctr, views, clicks,
                                sale_velocity, click_per_stock_day, ctr_rank_over_category, ctr_rank_over_brand,
                                stock_days_rank_over_category, stock_days_rank_over_brand)
    select distinct da.ad_key,
                    dg.geo_key,
                    ddc.date_key as created_date_key,
                    ddd.date_key as deleted_date_key,
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
    join dimad da on ca.ad_id = da.ad_id
    join dimgeography dg on ca.first_zip_digit = dg.first_zip_digit
    join dimdate ddc on ca.created_date = ddc.dt
    join dimdate ddd on ca.deleted_date = ddd.dt;

end;

go 
exec maindatacleansing;
print 'maindatacleansing is executed';
go
exec usp_insertdata;
print 'usp_insertdata is executed'