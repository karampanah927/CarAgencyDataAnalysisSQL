

--################Perprationstep 1 :clicks and views format#########################################################
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
		ctr nvarchar(50),
		ctr2 decimal(3,2)
		


		)

	insert into @t(ad_id ,
		product_type,
		car_brand,
		price,
		first_zip_digit,
		first_registration_year ,
		created_date,
		deleted_date ,
		views ,
		clicks ,
		stock_days ,
		ctr )
		select ad_id ,
		product_type,
		car_brand,
		price,
		first_zip_digit,
		first_registration_year ,
		created_date,
		deleted_date ,
		views ,
		clicks ,
		stock_days ,
		ctr  from car_ads
	
		update @t
		set views=0
		where views is null or views=''

		update @t
		set  clicks=0
		where clicks is null or clicks=''

		alter table car_ads alter column views bigint
		alter table car_ads alter column clicks bigint


		update a
		set views=b.views,clicks=b.clicks
		from car_ads a
			inner join @t b on a.ad_id=b.ad_id
		
		select cast(clicks as bigint)/cast(views as bigint),* from @t
		update @t
		set  ctr2=case when views=0 then 0 else cast(clicks as bigint)/cast(views as bigint) end
			select * from @t
		update  car_ads set ctr=0



	
	select ISNUMERIC(views),ISNUMERIC(clicks),* from car_ads
		update car_ads
		set ctr=case when views=0 then 0 else clicks/views end
				--alter table car_ads alter column ctr decimal(3,2)
			select * from car_ads

		


end