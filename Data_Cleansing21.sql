/*alter table car_ads
add MoM_ctr_change decimal(10,2)*/
	go
----------------------- CTR MOM Percentage -------------------------------------
-- use carsAdsdb;
/*alter table car_ads
add MoM_ctr_change decimal(10,2)
*/



	Create Procedure Data_Cleansing21
	as
	begin
	--begin tran

		;with cte_mom as (
		select
			ad_id,
			year(isnull(deleted_date,getdate())) as year, 
			month(isnull(deleted_date,getdate())) as month,
			sum(ctr) as total_ctr,
			lag(sum(ctr)) over (order by year(isnull(deleted_date,getdate())), month(isnull(deleted_date,getdate())) ) as prev_month_ctr
		from
			car_ads
		group by
			year(isnull(deleted_date,getdate())),
			month(isnull(deleted_date,getdate())), 
			ad_id
	)
	--select * from cte_mom
		update a
	set mom_ctr_change=case     when b.prev_month_ctr = 0 then null -- handle division by zero
								else isnull((b.total_ctr - b.prev_month_ctr) * 100.0 / b.prev_month_ctr,0)
						end
	from car_ads a
	inner join cte_mom b on a.ad_id=b.ad_id
	


	--	select deleted_date,* from car_ads --where deleted_date is null
	--rollback

	end





