/*
alter table car_ads
	add click_per_stock_day decimal(9,3);
*/
	go
--------------------------- clicks per day----------------------------------
-- calculating the rate of the clicks
-- per day of the stock


	Create Procedure Data_Cleansing11
	as
	begin
	--begin tran
		update car_ads
		set click_per_stock_day =
					case
					when  stock_days = 0 THEN 0
					else (clicks / cast(stock_days	as decimal(9,3)))
					end;
		select * from car_ads
	--rollback
	end



