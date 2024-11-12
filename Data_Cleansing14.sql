/*
alter table car_ads
	add car_status nvarchar(50)
*/
	go
------------------------------- Car Status -----------------------------
-- categorization of Car based on
--their Age or the first registration year



	Create Procedure Data_Cleansing13
	as
	begin
	--begin tran
		update car_ads
		set car_status =
			case
			when first_registration_year < 2000
			then 'Seasoned'
			when first_registration_year>2000 
			and first_registration_year<2019 
			then 'Standard'
			else 'Modern'
			end
			from car_ads
		--select * from car_ads
	--rollback
	end



