/*
alter table car_ads add PriceRange varchar(20);
alter table car_ads alter column  Price decimal(15,0)
alter table car_ads alter column  Price bigint
*/
	go
	---------------- PRICE RANGE---------------------
	/*****  Price Class  *****/
	Create Procedure Data_Cleansing9
	as
	begin
	--begin tran
 ---------------------------- check isnumeric
		if exists(select * from car_ads where ISNUMERIC(price)=0 )
				update car_ads
				set price=case when isnumeric(cast(price as bigint))=1 then cast(price as bigint)
							   when isnumeric(cast(price as bigint))=0 then 77777 end
				where ISNUMERIC(price)=0

	
		update car_ads
		set PriceRange = case when price < 10000  	then 'Economic'
							  when price between 10000 AND 50000 then'MidRange'
							  else 'Premium'
						 end;
		

	--rollback
	end



