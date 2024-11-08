create procedure data_cleansing5
as
begin


			--Finding Views outliers
			-- Step 1: Calculate Q1, Q3, and IQR for the price
			with Quartiles_views_cte as (
				select
				ad_id,car_brand,views,
					PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY views) over (partition BY car_brand) AS Q1,
					PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY views) over (partition BY car_brand) AS Q3
				from car_ads
			),
			IQR_Calculation as (
				select
					ad_id,
					Q1,
					Q3,
					(Q3 - Q1) AS IQR
				from Quartiles_views_cte
			)

			-- Step 2: Identify outliers
			select  
				car_brand,
				count(case when qc.views < (qc.Q1 - 5 * ic.IQR) then 1 end) as 'Lower Outlier',
				count(case when qc.views > (qc.Q3 + 5 * ic.IQR) then 1 end) as 'Upper Outlier',
				count(case when qc.views >= (qc.Q1 - 5 * ic.IQR) and qc.views <= (qc.Q3 + 5 * ic.IQR) then 1 end) as 'Not an Outlier'
			from 
				Quartiles_views_cte qc 
			inner join
				IQR_Calculation ic
			on qc.ad_id = ic.ad_id
			group by qc.car_brand
			order by qc.car_brand




end