
create procedure data_cleansing7
as
begin
	--alter table car_ads
	--	add brand_category char(1)


------------------- update brand_category of table car_ads

---------------------------------------------------------------------------------- should add a control on car_brand




	update car_ads
	set car_ads.brand_category = b.brand_category
	from car_ads c
	inner join brandcategories b
	on c.car_brand = b.car_brand



-------------checking the table
	if exists(select * from car_ads where brand_category is null or brand_category='')
		
select count(*)rowNum  , car_brand as brandsWithNoCategory
from car_ads
where brand_category is null
group by car_brand




--setting the brand_category to Not Assigned for null brand_categories

update car_ads
set brand_category = 'Not Assigned'
where car_brand in ('Caravans-Wohnm','Others')



select  car_brand,brand_category
from car_ads


end