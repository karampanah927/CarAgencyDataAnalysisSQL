

--################Perprationstep 1 :clicks and views format#########################################################
--alter table car_ads alter column ctr decimal(4,3)
create proc data_cleansing2
as
begin
------------------------------------declare @t
	declare @t table(
		ad_id nvarchar(50),
		product_type nvarchar(50),
		car_brand nvarchar(100),
		price nvarchar(50),
		first_zip_digit nvarchar(50),
		first_registration_year nvarchar(50),
		created_date nvarchar(50),
		deleted_date nvarchar(50),
		views bigint,
		clicks bigint,
		stock_days nvarchar(50),
		ctr nvarchar(50)
		)
----------------------------------  insert into @t

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
			ctr  
			from car_ads
	
	
	------------------------------------------------------------------manage null & ''


	if exists(select * from @t where  views is null or views='')
		update @t
		set views=0
		where views is null or views=''
	if exists(select * from @t where  clicks is null or clicks='')
		update @t
		set  clicks=0
		where clicks is null or clicks=''
	
		alter table car_ads alter column views bigint
		alter table car_ads alter column clicks bigint

---------------------------------------------------------------------- wrong data
		--if exists(select * from car_ads where clicks >views )
		--	delete car_ads where clicks >views

---------------------------------- recalc ctr
		update  @t set ctr=0
		update  car_ads set ctr=0

	
----------------style1
		update @t
		set ctr=case when clicks>views then 0
					when views=0 then 0 
					else cast(clicks as decimal(10,0))/cast(views as decimal(10,0))
					end
-----------------style2
	--update @t
	--	set ctr=cast(clicks as decimal)/cast(views as decimal)
	--	where clicks<views
---------------------------------- end of recalc ctr

--test @t
				select * from @t

------------------- update main table

		update a
		set clicks=b.clicks,views=b.views,ctr=b.ctr
		from car_ads a
		inner join @t b on a.ad_id=b.ad_id
		

		--test
			--select * from car_ads

		


end