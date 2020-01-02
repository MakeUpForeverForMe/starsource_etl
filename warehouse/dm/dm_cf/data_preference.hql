INSERT OVERWRITE TABLE dm_cf.data_preference PARTITION(year_month,day_of_month)
select
if(action_water.report_date is null,eict.report_date,action_water.report_date) as report_date,
if(action_water.app_name is null,eict.app_name,action_water.app_name) as app_name,
if(apply_cnt is null,0,apply_cnt) as apply_cnt,
if(change_cnt is null,0,change_cnt) as change_cnt
,'${year_month}'  as  year_month,'${day_of_month}'  as  day_of_month
from (
  select report_date,if(app_name is null,sourceid,app_name) as app_name,change_cnt
  from
  (
    select substring(createtime,1,8) as report_date,sourceid,count(distinct waterid) as change_cnt
    from ods_wefix.t_ad_action_water_json
    where display = 1 and (status = 0 or status is null)
    and year_month = '${year_month}' and day_of_month = '${day_of_month}'
    -- and year_month = '202001' and day_of_month = '02'
    group by substring(createtime,1,8),sourceid
  ) as action_water
  left join (
    select distinct app_id,app_name from ods_wefix.app_info_tsv
  ) as app on action_water.sourceid = app.app_id
) as action_water
full join (
  select report_date,if(app_name is null,apply_app_id,app_name) as app_name,apply_cnt
  from
  (
    select substring(create_time,1,8) as report_date,apply_app_id,count(distinct exchange_child_id) as apply_cnt
    from ods_wefix.exchange_info_child_tsv
    where status = 2
    and substring(create_time,1,6) = '${year_month}' and substring(create_time,7,2) = '${day_of_month}'
    -- and substring(create_time,1,6) = '202001' and substring(create_time,7,2) = '02'
    group by substring(create_time,1,8),apply_app_id
  ) as eict
  left join (
    select distinct app_id,app_name from ods_wefix.app_info_tsv
  ) as app on eict.apply_app_id = app.app_id
) as eict on action_water.report_date = eict.report_date and action_water.app_name = eict.app_name
order by report_date,app_name
;
