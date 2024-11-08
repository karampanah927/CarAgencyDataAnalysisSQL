--##########################Preparationstep2: Remove Duplicates##########################################################
create procedure data_cleansing3
as
begin

--test
select COUNT(*) from car_ads -- 78319
select ad_id, count(*) recordNum   --16
from car_ads
group by ad_id
having count(*) >1


;with dup_id_cte as (
	select ROW_NUMBER() over(Partition by ad_id order by ad_id) rn,ad_id
	from car_ads
)
delete
from dup_id_cte
where rn>1

--test
select ad_id, count(*) recordNum
from car_ads
group by ad_id
having count(*) >1select COUNT(*) from car_ads -- 78303

select * from car_ads  where ad_id=360768624

end