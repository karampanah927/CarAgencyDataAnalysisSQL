/*alter table car_ads
add view_rank_over_region int
---- add the new column to the table*/
	go
--------------------------- views rank over Region -----------------------
--select * from car_ads


-- create a common table expression (cte)
--to rank views within 
--each geographic region

	Create Procedure Data_Cleansing19
	as
	begin
	--begin tran
		;with ranked_view_region_cte as (
		select 
			ad_id,
			geographic_region,
			views,
			dense_rank() over  	(partition by geographic_region order by views desc) 	as view_rank_over_region
		from car_ads
		)
		update a
		set view_rank_over_region=b.view_rank_over_region
		from car_ads a 
			inner join ranked_view_region_cte b on a.ad_id=b.ad_id
	
	--	select * from car_ads
	--rollback

	end



