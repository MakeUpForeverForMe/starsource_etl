INSERT OVERWRITE TABLE dm_cf.data_preference PARTITION(year_month,day_of_month)
select
if(action_water.report_date is null,eict.report_date,action_water.report_date)          as report_date,
if(action_water.app_name_apply is null,eict.app_name_apply,action_water.app_name_apply) as app_name_apply,
if(action_water.app_name_audit is null,eict.app_name_audit,action_water.app_name_audit) as app_name_audit,
if(apply_cnt is null,0,apply_cnt)                                                       as apply_cnt,
if(change_cnt is null,0,change_cnt)                                                     as change_cnt
,'${year_month}'  as  year_month,'${day_of_month}'  as  day_of_month
from (
  select
  report_date,
  if(app_apply.app_name is null,sourceid,app_apply.app_name) as app_name_apply,
  if(app_audit.app_name is null,ex_adv_id,app_audit.app_name) as app_name_audit,
  change_cnt
  from
  (
    select substring(createtime,1,8) as report_date,sourceid,ex_adv_id,count(distinct waterid) as change_cnt
    from (
      select distinct waterid,createtime,sourceid,extagid,year_month,day_of_month from ods_wefix.t_ad_action_water_json
      where display = 1 and (status = 0 or status is null)
      and year_month = '${year_month}' and day_of_month = '${day_of_month}'
    ) as action_water
    join (
      SELECT id,year_month,day_of_month from ods_wefix.t_ad_query_water_json WHERE (test = 0 or test is null)
    ) as query_water
    on action_water.year_month = query_water.year_month AND action_water.day_of_month = query_water.day_of_month AND action_water.waterid = query_water.id
    left join (
      select distinct advertise_id,app_id as ex_adv_id from ods_wefix.advertisement_info_tsv
    ) as adv_info on action_water.extagid = adv_info.advertise_id
    group by substring(createtime,1,8),sourceid,ex_adv_id
  ) as action_water
  left join (
    select distinct app_id,app_name from ods_wefix.app_info_tsv
  ) as app_apply on action_water.sourceid = app_apply.app_id
  left join (
    select distinct app_id,app_name from ods_wefix.app_info_tsv
  ) as app_audit on action_water.ex_adv_id = app_audit.app_id
) as action_water
full join (
  select
  report_date,
  if(app_apply.app_name is null,apply_app_id,app_apply.app_name) as app_name_apply,
  if(app_audit.app_name is null,apply_app_id,app_audit.app_name) as app_name_audit,
  apply_cnt
  from
  (
    select substring(create_time,1,8) as report_date,apply_app_id,audit_app_id,count(distinct exchange_child_id) as apply_cnt
    from ods_wefix.exchange_info_child_tsv
    where status = 2
    and substring(create_time,1,6) = '${year_month}' and substring(create_time,7,2) = '${day_of_month}'
    group by substring(create_time,1,8),apply_app_id,audit_app_id
  ) as eict
  left join (
    select distinct app_id,app_name from ods_wefix.app_info_tsv
  ) as app_apply on eict.apply_app_id = app_apply.app_id
  left join (
    select distinct app_id,app_name from ods_wefix.app_info_tsv
  ) as app_audit on eict.audit_app_id = app_audit.app_id
) as eict on action_water.report_date = eict.report_date and action_water.app_name_apply = eict.app_name_apply and action_water.app_name_audit = eict.app_name_audit
order by report_date,app_name_apply,app_name_audit
;
