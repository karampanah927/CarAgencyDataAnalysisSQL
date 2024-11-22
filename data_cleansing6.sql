--#################### Recalculating Stock Days 6#################################
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

