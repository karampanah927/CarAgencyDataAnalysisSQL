/*alter table car_ads
add click_rank_over_region int*/
	go
---------------------- clicks rank over Region ---------------------------------------
--select * from car_ads


-- create a common table expression (cte)
--to rank clicks within each geographic region


	Create Procedure Data_Cleansing18
	as
	begin
	--begin tran
		;with ranked_click_region_cte as (
		select 
			ad_id,
			geographic_region,
			clicks,
			dense_rank() over (partition by geographic_region order by clicks desc) 	as click_rank_over_region
		from car_ads
	)

		update a
		set click_rank_over_region=b.click_rank_over_region
		from car_ads a 
			inner join ranked_click_region_cte b on a.ad_id=b.ad_id
	
		--select * from car_ads
	--rollback

		


	end



