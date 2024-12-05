/*
alter table car_ads
	add ctr_rank_over_category int
*/
	go
------------------- ctr rank over brand_category------------------------------



	Create Procedure Data_Cleansing13
	as
	begin
	--begin tran
		;with ranked_ctr_brandcat_cte as (
			select 
				ad_id,
				brand_category,
				ctr,
				dense_rank() over (partition by brand_category 	order by ctr desc) 	as ctr_rank_over_category
			from car_ads
		)
				update a
				set ctr_rank_over_category=b.ctr_rank_over_category
				from car_ads  a
				inner join ranked_ctr_brandcat_cte b  on a.ad_id =b.ad_id

		--select * from car_ads
	--rollback
	end



