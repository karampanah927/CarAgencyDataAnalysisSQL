use CarAdsDB;
--################Perprationstep 1 :clicks and views format#########################################################

select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= 'car_ads_backup3'
create proc data_cleansing2
as
begin

declare @t table(
ad_id nvarchar(50),
    product_type nvarchar(50),
    car_brand nvarchar(100),
    price nvarchar(50),
    first_zip_digit nvarchar(50),
    first_registration_year nvarchar(50),
    created_date nvarchar(50),
    deleted_date nvarchar(50),
    views nvarchar(50),
    clicks nvarchar(50),
    stock_days nvarchar(50),
    ctr nvarchar(50)

		)

	insert into @t
		select * from car_ads_backup3 --where views is null or views = ''
select * from @t where views is null or views = ''

		update @t
		set views=0
		where views is null or views =''

		update @t
		set clicks = 0
		where clicks is null or clicks = ''
		
		-- we can not alter the table variable like @t
		alter table car_ads alter column views bigint
		alter table car_ads alter column clicks bigint

		update a 
		set views = t.views, clicks=t.clicks
		from car_ads a
		inner join @t t
		on a.ad_id = t.ad_id

		update @t
		set ctr = case views=0 then 0 else decimal(clicks/views,2)
