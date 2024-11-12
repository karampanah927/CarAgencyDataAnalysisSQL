/*
alter table car_ads 
	add geographic_region nvarchar(75)
*/
	go
-----------------------------Geographical Region --------------------------
-- adding the geographical region 
--based on the first_zip_digit. 
--Assumption: all the clients 
--are based in Germany



	Create Procedure Data_Cleansing12
	as
	begin
	--begin tran
		update car_ads
		set geographic_region = 
			case first_zip_digit
				when 1 then 
				'Northeast,(Berlin-Brandenburg)'
				when 2 then 
				'Northwest,(Hamburg-Schleswig-Holstein-Bremen-Lower Saxony)'
				when 3 then 'Central North,(Lower Saxony,Saxony-Anhalt)'
				when 4 then 'West,(North Rhine-Westphalia)'
				when 5 then 'Central West,(Hesse-Rhineland-Palatinate-Saarland)'
				when 6 then 'Central South,(Hesse-Baden-Württemberg-Bavaria)'
				when 7 then 'Southwest,(Baden-Württemberg )'
				when 8 then 'Southeast,(Bavaria)'
				when 9 then 	'East,(Thuringia-Saxony-Northern Bavaria)'
				else 'Unknown Region'
			
			  end
		from car_ads;
		select * from car_ads
	--rollback
	end



