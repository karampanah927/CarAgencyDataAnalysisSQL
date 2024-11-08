create proc data_cleansing8
as 
begin
		select car_brand, count(*) from BrandCategories
		group by car_brand
		having count(*) >1
		;with carBrandNo_cte
			as
			(
			select ROW_NUMBER() over(partition by car_brand order by car_brand) rn,car_brand
			from
			BrandCategories
			)
		delete
		from carBrandNo_cte
		where rn > 1
		
end


exec data_cleansing8