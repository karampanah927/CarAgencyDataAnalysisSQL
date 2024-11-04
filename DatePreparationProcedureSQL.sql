use CarAdsDB;
--step 1: Creating new columns
ALTER TABLE car_ads ADD proper_created_date DATE;
ALTER TABLE car_ads ADD proper_deleted_date DATE;
--step 2: assigning values to the new columns
UPDATE car_ads
SET proper_created_date = 
    CASE 
        WHEN RIGHT(created_date, 2) >= '25' THEN 
            CONVERT(DATE, 
                CONCAT('19', RIGHT(created_date, 2), '-', 
                    SUBSTRING(created_date, 4, 2), 
                    '-', LEFT(created_date, 2)), 120)
        ELSE
            CONVERT(DATE, 
                CONCAT('20', RIGHT(created_date, 2), '-', 
                    SUBSTRING(created_date, 4, 2),

					go
					create function fn_validdate(@date nvarchar(20))
					returns int
					as
					begin
						if ISDATE(@date)=0
							return 0

					end
--step 3: dropping the previous columns
ALTER TABLE car_ads DROP COLUMN created_date, deleted_date;

--step 4: renaming the new columns as the original
EXEC sp_rename 'car_ads.proper_created_date', 'created_date', 'COLUMN';
EXEC sp_rename 'car_ads.proper_deleted_date', 'deleted_date', 'COLUMN';
mqy-nkhx-kzz


--===========================================================================
--Create Staging Table
create table car_ads (
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
);

	--insert into car_ads([ad_id], [product_type], [car_brand], [price], [first_zip_digit], [first_registration_year], [created_date], [deleted_date], [views], [clicks], [stock_days], [ctr])
	--select [ad_id], [prodduct_type], [car_brand], [price], [first_zip_digit], [first_registration_year], [created_date], [deleted_date], [views], [clicks], [stock_days], [ctr] from adtable


--step 0 : Backup the data
--SELECT * INTO #t FROM car_ads;

create proc data cleansing1
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
	created_date2 date

	)

	insert into @t
		select * from car_ads

		--select *
		--from @t
		--where ISDATE(created_date)=0

		update a
					set created_date= CASE 
					WHEN RIGHT(created_date, 2) >= '25' THEN 
						CONVERT(DATE, 
							CONCAT('19', RIGHT(created_date, 2), '-', 
								SUBSTRING(created_date, 4, 2), 
								'-', LEFT(created_date, 2)), 120)
					ELSE
						
							convert(date, concat('20',right(deleted_date,2),'-',substring(deleted_date,4,2),'-',Left(deleted_date,2)),120)
					end
		from @t a
		where ISDATE(created_date)=0


		--select *
		--from @t
		--where ISDATE(created_date)=0

		--alter table @t alter column created_date date
		update @t
		set created_date2=FORMAT(convert(date,created_date),'yyyy-mm-dd')
		--select FORMAT(convert(date,created_date),'yyyy-mm-dd') new_createddate,* from @t


		update b
		set created_date=a.created_date2
		from @t a
			inner join car_ads b on a.ad_id=b.ad_id
		where ISDATE(b.created_date)=0
end
















		--merge into car_ads
		--using @t
		--	on car_ads.ad_id=@t.ad_id
		--when matched then
		--	print 'ok'

		--when not matched then
		--update b
		--set created_date=a.created_date2
		--from @t a 
		--inner join car_ads b on a.ad_id=b.ad_id

		--when not matched by source then
		--insert into car_ads(ad_id,    product_type,    car_brand ,    price ,    first_zip_digit,    first_registration_year,    created_date ,    deleted_date ,    views ,    clicks ,    stock_days ,    ctr )
		-- select ad_id,    product_type,    car_brand ,    price ,    first_zip_digit,    first_registration_year,    created_date2 ,    deleted_date ,    views ,    clicks ,    stock_days ,    ctr  
		-- from @t
			
		


/*	
use DB2
select * from tblsource
select * from tbldestination
merge into tbldestination
using tblsource
on tbldestination.id=tblsource.id
when matched then
	update set 
	tbldestination.fname=tblsource.fname,
	tbldestination.lname=tblsource.lname,
	tbldestination.age=tblsource.age
when not matched then
	insert values(fname,lname,age)
when not matched by source then
	delete;

select * from tblsource
select * from tbldestination
*/