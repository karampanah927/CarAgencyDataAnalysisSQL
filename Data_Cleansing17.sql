/*alter table car_ads
add stock_days_rank_over_brand int;*/
	go
---------------- stock days over car_brand ---------------------------------------
--select * from car_ads





	Create Procedure Data_Cleansing17
	as
	begin
	--begin tran
		;with ranked_stock_days_brand_cte as (
    select 
        ad_id,
        car_brand,
        stock_days,
        dense_rank() over (partition by car_brand order by stock_days desc) as stock_days_rank_over_brand
    from car_ads
)

	update a
	set stock_days_rank_over_brand=b.stock_days_rank_over_brand
	from car_ads a 
		inner join ranked_stock_days_brand_cte b on a.ad_id=b.ad_id
	
	--	select * from car_ads
	--rollback

		


	end



