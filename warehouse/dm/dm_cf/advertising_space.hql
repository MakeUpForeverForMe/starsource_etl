with base as (
  select
  query_water.id                                                                            as id,
  substring(if(query_water.reqtime is null,query_water.createtime,query_water.reqtime),1,8) as report_date,
  action_water.status                                                                       as report_status,
  if(query_water.reqtime is null,'action','query')                                          as req_type,
  action_water.createtime                                                                   as action_ctime,
  case
  when query_water.tagid = exchange_info.audit_adver_id then exchange_info.apply_app_id
  when query_water.tagid = exchange_info.apply_adver_id then exchange_info.audit_app_id
  else null end                                                                             as plan_app_id,
  case
  when query_water.tagid = exchange_info.audit_adver_id then exchange_info.apply_user_id
  when query_water.tagid = exchange_info.apply_adver_id then exchange_info.audit_user_id
  else if(plan_info.user_id is null,null,plan_info.user_id) end                             as plan_user_id,
  if(query_water.acquisitionid is null,0,query_water.acquisitionid)                         as plan_id,
  query_water.extagid                                                                       as plan_adv_id,
  query_water.tagid                                                                         as adv_id,
  case
  when query_water.tagid = exchange_info.audit_adver_id then exchange_info.audit_app_id
  when query_water.tagid = exchange_info.apply_adver_id then exchange_info.apply_app_id
  else if(adv_info.app_id is null,null,adv_info.app_id) end                                 as adv_app_id,
  case
  when query_water.tagid = exchange_info.audit_adver_id then exchange_info.audit_user_id
  when query_water.tagid = exchange_info.apply_adver_id then exchange_info.apply_user_id
  else if(app_info.user_id is null,null,app_info.user_id) end                               as adv_user_id,
  if(adv_info.ad_type is null,0,adv_info.ad_type)                                           as ad_type,
  action_water.display                                                                      as action_display,
  action_water.isclick                                                                      as action_isclick
  from (
    select distinct id,reqtime,createtime,tagid,acquisitionid,extagid,year_month,day_of_month
    from ods_wefix.t_ad_query_water_json
    -- where year_month = '201911' and day_of_month = '29' and (test = 0 or test is null)
    where year_month = '${year_month}' and day_of_month = '${day_of_month}' and (test = 0 or test is null)
  ) as query_water
  left join (
    select distinct waterid,createtime,status,display,isclick,year_month,day_of_month from ods_wefix.t_ad_action_water_json
  ) as action_water
  on query_water.id = action_water.waterid
  left join (
    select distinct exchange_id,
    audit_adver_id,audit_plan_id,audit_app_id,audit_user_id,
    apply_adver_id,apply_plan_id,apply_app_id,apply_user_id
    from ods_wefix.exchange_info_tsv
    where audit_app_id != 'NULL' and audit_user_id != 'NULL' and apply_app_id != 'NULL' and apply_user_id != 'NULL' and status > 6
  ) as exchange_info
  on (query_water.tagid = exchange_info.audit_adver_id and query_water.extagid = exchange_info.apply_adver_id and query_water.acquisitionid = exchange_info.apply_plan_id)
  or (query_water.tagid = exchange_info.apply_adver_id and query_water.extagid = exchange_info.audit_adver_id and query_water.acquisitionid = exchange_info.audit_plan_id)
  left join (
    select distinct acquisition_id,user_id from ods_wefix.acquisition_plan_tsv
  ) as plan_info on query_water.acquisitionid = plan_info.acquisition_id
  left join (
    select distinct advertise_id,app_id,ad_type from ods_wefix.advertisement_info_tsv
  ) as adv_info on query_water.tagid = adv_info.advertise_id
  left join (
    select distinct app_id,user_id from ods_wefix.app_info_tsv
  ) as app_info on adv_info.app_id = app_info.app_id
)
INSERT OVERWRITE TABLE dm_cf.advertising_space PARTITION(year_month,day_of_month)
select
req.report_date                             as report_date,
req.plan_user_id                            as plan_user_id,
req.plan_app_id                             as plan_app_id,
req.plan_id                                 as plan_id,
req.plan_adv_id                             as plan_adv_id,
req.adv_user_id                             as adv_user_id,
req.adv_app_id                              as adv_app_id,
req.adv_id                                  as adv_id,
req.ad_type                                 as ad_type,
if(adv_req_num is null,0,adv_req_num)       as adv_req_num,
if(adv_iss_num is null,0,adv_iss_num)       as adv_iss_num,
cast(if(if(adv_req_num is null, 0, adv_req_num) = 0,0,if(adv_iss_num  is null,0, adv_iss_num)/adv_req_num) as decimal(13,5)) as iss_req_rate,
if(adv_show_num is null,0,adv_show_num)     as adv_show_num,
if(adv_show_fail is null,0,adv_show_fail)   as adv_show_fail,
cast(if(if(adv_iss_num is null, 0, adv_iss_num) = 0,0,if(adv_show_num is null,0,adv_show_num)/adv_iss_num) as decimal(13,5)) as show_iss_rate,
if(adv_cli_num is null,0,adv_cli_num)       as adv_cli_num,
cast(if(if(adv_show_num is null,0,adv_show_num) = 0,0,if(adv_cli_num  is null,0,adv_cli_num)/adv_show_num) as decimal(13,5)) as cli_show_rate
,'${year_month}'  as  year_month,'${day_of_month}'  as  day_of_month
from (
  select report_date,plan_user_id,plan_app_id,plan_id,plan_adv_id,adv_user_id,adv_app_id,adv_id,ad_type,
  count(distinct id) as adv_req_num
  from base
  group by report_date,plan_user_id,plan_app_id,plan_id,plan_adv_id,adv_user_id,adv_app_id,adv_id,ad_type
) as req
left join (
  select report_date,plan_user_id,plan_app_id,plan_id,plan_adv_id,adv_user_id,adv_app_id,adv_id,ad_type,
  count(distinct id) as adv_iss_num
  from base where req_type = 'action'
  group by report_date,plan_user_id,plan_app_id,plan_id,plan_adv_id,adv_user_id,adv_app_id,adv_id,ad_type
) as iss
on  req.report_date   = iss.report_date
and req.adv_id        = iss.adv_id          and req.plan_id       = iss.plan_id
and req.ad_type       = iss.ad_type         and req.plan_adv_id   = iss.plan_adv_id
and req.adv_app_id    = iss.adv_app_id      and req.plan_app_id   = iss.plan_app_id
and req.adv_user_id   = iss.adv_user_id     and req.plan_user_id  = iss.plan_user_id
left join (
  select report_date,plan_user_id,plan_app_id,plan_id,plan_adv_id,adv_user_id,adv_app_id,adv_id,ad_type,
  count(distinct if(report_status = 0 and action_display = 1,id,null)) as adv_show_num,
  count(distinct if(report_status = 1 and action_display = 1,id,null)) as adv_show_fail,
  count(distinct if(action_isclick = 1,id,null)) as adv_cli_num
  from base where req_type = 'action'
  group by report_date,plan_user_id,plan_app_id,plan_id,plan_adv_id,adv_user_id,adv_app_id,adv_id,ad_type
) as show_cli
on  req.report_date   = show_cli.report_date
and req.adv_id        = show_cli.adv_id       and req.plan_id       = show_cli.plan_id
and req.ad_type       = show_cli.ad_type      and req.plan_adv_id   = show_cli.plan_adv_id
and req.adv_app_id    = show_cli.adv_app_id   and req.plan_app_id   = show_cli.plan_app_id
and req.adv_user_id   = show_cli.adv_user_id  and req.plan_user_id  = show_cli.plan_user_id
order by report_date,plan_user_id,plan_app_id,plan_user_id,plan_id,plan_adv_id,adv_user_id,adv_app_id,adv_id,ad_type;
