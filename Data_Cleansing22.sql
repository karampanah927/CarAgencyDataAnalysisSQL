
	go
----------------------- check dates -------------------------------------




	Create Procedure Data_Cleansing22
	as
	begin
	--begin tran

	
		if exists(select * /*count(*) as out_of_range_deleted_date */  from car_ads	 where deleted_date> getdate() )
		 update car_ads	set deleted_date=getdate()  where deleted_date> getdate()
		 if exists(select * /*count(*) as out_of_range_created_date*/	 from car_ads 	 where created_date> getdate() )
			update car_ads 	set created_date=getdate() where created_date> getdate()
		if exists(select * /* out_of_range_registration_year */	 from car_ads 	 where first_registration_year> year(getdate()) )
			update car_ads 	set first_registration_year=1900 where first_registration_year> year(getdate())
	
	--	select deleted_date,* from car_ads --where deleted_date is null
	--rollback

	end





