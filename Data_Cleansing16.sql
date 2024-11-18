/*alter table car_ads
add stock_days_rank_over_category int;*/
	go
---------------------stock days over brand_category-----------------------------
--select * from car_ads





	Create Procedure Data_Cleansing16
	as
	begin
	--begin tran
		;with ranked_stock_days_brandcat_cte as (
		select 
			ad_id,
			brand_category,
			stock_days,
			dense_rank() over (partition by brand_category order by stock_days desc) as stock_days_rank_over_category
		from car_ads
	)
	
	update a
	set stock_days_rank_over_category=b.stock_days_rank_over_category
	from car_ads a 
		inner join ranked_stock_days_brandcat_cte b on a.ad_id=b.ad_id
	
	--	select * from car_ads
	--rollback

		


	end



