with base as (
  select
  query_water.id as id,
  substring(if(query_water.reqtime is null,query_water.createtime,query_water.reqtime),1,8) as report_date,
  if(query_water.reqtime is null,'action','query') as req_type,
  action_water.createtime as action_ctime,
  if(plan_info.acquisition_id is null,query_water.acquisitionid,plan_info.acquisition_id) as plan_id,
  if(exchange_info.app_id is null,plan_info.app_id,exchange_info.app_id) as plan_app_id,
  plan_info.user_id as plan_user_id,
  if(adv_info.advertise_id is null,query_water.tagid,adv_info.advertise_id) as adv_id,
  if(app_info.app_id is null,adv_info.app_id,app_info.app_id) as adv_app_id,
  app_info.user_id as adv_user_id,
  adv_info.ad_type as ad_type,
  action_water.display as action_display,
  action_water.isclick as action_isclick
  from (
    select distinct id,reqtime,createtime,tagid,acquisitionid,year_month,day_of_month from ods_wefix.t_ad_query_water_json
    where year_month = '${year_month}' and day_of_month = '${day_of_month}'
  ) as query_water
  left join (
    select distinct waterid,createtime,display,isclick,year_month,day_of_month from ods_wefix.t_ad_action_water_json
  ) as action_water
  on query_water.id = action_water.waterid
  left join (
    select distinct acquisition_id,user_id,user_name,app_id from ods_wefix.acquisition_plan_tsv
  ) as plan_info
  on query_water.acquisitionid = plan_info.acquisition_id
  left join (
    select distinct audit_plan_id,audit_app_id as app_id from ods_wefix.exchange_info_tsv
  ) as exchange_info
  on plan_info.acquisition_id = exchange_info.audit_plan_id
  left join (
    select distinct advertise_id,app_id,ad_type from ods_wefix.advertisement_info_tsv
  ) as adv_info
  on query_water.tagid = adv_info.advertise_id
  left join (
    select distinct app_id,user_id from ods_wefix.app_info_tsv
  ) as app_info
  on adv_info.app_id = app_info.app_id
)
INSERT OVERWRITE TABLE dm_cf.advertising_space PARTITION(year_month,day_of_month)
select
date_format(from_utc_timestamp(current_timestamp,'GMT+8'),'yyyyMMddHHmmss') as create_date,
report_date,
plan_user_id,
plan_app_id,
plan_id,
adv_user_id,
adv_app_id,
adv_id,
ad_type,
adv_req_num,
adv_iss_num,
if(adv_iss_num = 0,0,adv_iss_num/adv_req_num) as iss_req_rate,
adv_show_num,
if(adv_show_num = 0,0,adv_show_num/adv_iss_num) as show_iss_rate,
adv_cli_num,
if(adv_cli_num = 0,0,adv_cli_num/adv_show_num) as cli_show_rate,
'${year_month}','${day_of_month}'
from (
  select
  req.report_date as report_date,
  if(adv_req_num is null,0,adv_req_num) as adv_req_num,
  if(adv_iss_num is null,0,adv_iss_num) as adv_iss_num,
  if(adv_show_num is null,0,adv_show_num) as adv_show_num,
  if(adv_cli_num is null,0,adv_cli_num) as adv_cli_num,
  req.plan_user_id as plan_user_id,
  req.plan_app_id as plan_app_id,
  req.plan_id as plan_id,
  req.adv_user_id as adv_user_id,
  req.adv_app_id as adv_app_id,
  req.adv_id as adv_id,
  req.ad_type as ad_type
  from (
    select report_date,plan_user_id,plan_app_id,plan_id,adv_user_id,adv_app_id,adv_id,ad_type,count(distinct id) as adv_req_num
    from base
    group by report_date,plan_user_id,plan_app_id,plan_id,adv_user_id,adv_app_id,adv_id,ad_type
  ) as req
  left join (
    select report_date,plan_user_id,plan_app_id,plan_id,adv_user_id,adv_app_id,adv_id,ad_type,count(distinct id) as adv_iss_num
    from base where req_type = 'action'
    group by report_date,plan_user_id,plan_app_id,plan_id,adv_user_id,adv_app_id,adv_id,ad_type
  ) as iss
  on req.report_date = iss.report_date and req.plan_user_id = iss.plan_user_id and req.plan_id = iss.plan_id and req.adv_user_id = iss.adv_user_id and req.adv_app_id = iss.adv_app_id and req.adv_id = iss.adv_id and req.ad_type = iss.ad_type and req.plan_app_id = iss.plan_app_id
  left join (
    select report_date,plan_user_id,plan_app_id,plan_id,adv_user_id,adv_app_id,adv_id,ad_type,sum(action_display) as adv_show_num,sum(action_isclick) as adv_cli_num
    from base where req_type = 'action'
    group by report_date,plan_user_id,plan_app_id,plan_id,adv_user_id,adv_app_id,adv_id,ad_type
  ) as show_cli
  on req.report_date = show_cli.report_date and req.plan_user_id = show_cli.plan_user_id and req.plan_id = show_cli.plan_id and req.adv_user_id = show_cli.adv_user_id and req.adv_app_id = show_cli.adv_app_id and req.adv_id = show_cli.adv_id and req.ad_type = show_cli.ad_type and req.plan_app_id = show_cli.plan_app_id
) as a
order by report_date,plan_user_id,plan_app_id,plan_user_id,plan_id,adv_user_id,adv_app_id,adv_id,ad_type;
