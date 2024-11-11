/*
alter table car_ads add sale_velocity decimal(9,3);
*/
	go
	---------------- PRICE RANGE---------------------
	/*****  Price Class  *****/
-- Determine the sales velocity
--based on stock_days and views using
--the formula
--Num of Opportunites/ length of sales duration
--(views/stock_days):

	Create Procedure Data_Cleansing10
	as
	begin
	--begin tran
---------------------------- sale_velocity-------------------------------------
		

	
		update car_ads
		set sale_velocity = case when stock_days = 0	then 0
							else views/cast(stock_days	as decimal(15,6))
						end;
		
	--rollback
	end



