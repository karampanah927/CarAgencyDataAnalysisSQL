create procedure data_cleansing4
as
begin
	select
		sum(case when ad_id is null then 1 else 0 end) as Null_ad_id,
		sum(case when product_type is null then 1 else 0 end) as Null_product_type,
		sum(case when car_brand is null then 1 else 0 end) as Null_car_brand,
		sum(case when price is null then 1 else 0 end) as Null_price,
		sum(case when first_zip_digit is null then 1 else 0 end) as Null_first_zip_digit,
		sum(case when first_registration_year is null then 1 else 0 end) as Null_first_registration_year,
		sum(case when created_date is null then 1 else 0 end) as Null_created_date,
		sum(case when deleted_date is null then 1 else 0 end) as Null_deleted_date,
		sum(case when views is null then 1 else 0 end) as Null_views,
		sum(case when clicks is null then 1 else 0 end) as Null_clicks,
		sum(case when stock_days is null then 1 else 0 end) as Null_stock_days,
		sum(case when ctr is null then 1 else 0 end) as Null_ctr
	from 
		car_ads;

end