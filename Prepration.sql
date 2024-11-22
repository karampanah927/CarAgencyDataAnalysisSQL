

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


--##########################Preparationstep2: Remove Duplicates##########################################################
create procedure data_cleansing3
as
begin

--test
select COUNT(*) from car_ads -- 78319
select ad_id, count(*) recordNum   --16
from car_ads
group by ad_id
having count(*) >1


;with dup_id_cte as (
	select ROW_NUMBER() over(Partition by ad_id order by ad_id) rn,ad_id
	from car_ads
)
delete
from dup_id_cte
where rn>1

--test
select ad_id, count(*) recordNum
from car_ads
group by ad_id
having count(*) >1select COUNT(*) from car_ads -- 78303

select * from car_ads  where ad_id=360768624

end


--###################### Checking the Number of Null Values in Data Set###################################
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

create procedure data_cleansing5
as
begin


			--Finding Views outliers
			-- Step 1: Calculate Q1, Q3, and IQR for the price
			with Quartiles_views_cte as (
				select
				ad_id,car_brand,views,
					PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY views) over (partition BY car_brand) AS Q1,
					PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY views) over (partition BY car_brand) AS Q3
				from car_ads
			),
			IQR_Calculation as (
				select
					ad_id,
					Q1,
					Q3,
					(Q3 - Q1) AS IQR
				from Quartiles_views_cte
			)

			-- Step 2: Identify outliers
			select  
				car_brand,
				count(case when qc.views < (qc.Q1 - 5 * ic.IQR) then 1 end) as 'Lower Outlier',
				count(case when qc.views > (qc.Q3 + 5 * ic.IQR) then 1 end) as 'Upper Outlier',
				count(case when qc.views >= (qc.Q1 - 5 * ic.IQR) and qc.views <= (qc.Q3 + 5 * ic.IQR) then 1 end) as 'Not an Outlier'
			from 
				Quartiles_views_cte qc 
			inner join
				IQR_Calculation ic
			on qc.ad_id = ic.ad_id
			group by qc.car_brand
			order by qc.car_brand




end

--#################### Recalculating Stock Days 6 #################################
create procedure data_cleansing6
as
begin
-------------------------------- chceck
	if exists(select * from car_ads where created_date>deleted_date)
		delete car_ads where created_date>deleted_date
	update car_ads
	set stock_days = datediff(day, created_date, 
				case when deleted_date is null then getdate() else deleted_date end);


	--select count(*)NegativStockDaysNum from car_ads where stock_days<0

end

