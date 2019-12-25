with base as (
  select
  report_date,
  waterid,
  if(exchange_info.apply_app_id = appid,exchange_info.apply_user_id,exchange_info.audit_user_id)    as  login_userid,
  if(exchange_info.apply_app_id = appid,exchange_info.apply_app_id,exchange_info.audit_app_id)      as  login_appid,
  if(exchange_info.apply_app_id = appid,exchange_info.apply_adver_id,exchange_info.audit_adver_id)  as  login_advid,
  if(exchange_info.apply_app_id = appid,exchange_info.audit_app_id,exchange_info.apply_app_id)      as  viewer_appid,
  if(exchange_info.apply_app_id = appid,exchange_info.audit_adver_id,exchange_info.apply_adver_id)  as  viewer_advid,
  device_type,
  device_id,
  status_b,
  flevel_b,
  fstatus_b,
  inblacklist,
  status_d,
  flevel_d,
  fstatus_d,
  quality_d,
  status_i,
  flevel_i,
  fstatus_i,
  ip,
  quality_i
  from
  ( select
    if(atd_black.report_date is null,if(atd_device.report_date is null,atd_ip.report_date,atd_device.report_date),atd_black.report_date) as report_date,
    if(atd_black.waterid is null,if(atd_device.waterid is null,atd_ip.waterid,atd_device.waterid),atd_black.waterid) as waterid,
    if(atd_black.appid is null,if(atd_device.appid is null,atd_ip.appid,atd_device.appid),atd_black.appid) as appid,
    if(atd_black.exid is null,if(atd_device.exid is null,atd_ip.exid,atd_device.exid),atd_black.exid) as exid,
    if(atd_black.type is null,atd_device.type,atd_black.type) as device_type,
    if(atd_black.id is null,atd_device.id,atd_black.id) as device_id,
    atd_black.status        as  status_b,
    atd_black.flevel        as  flevel_b,
    atd_black.fstatus       as  fstatus_b,
    atd_black.inblacklist   as  inblacklist,
    atd_device.status       as  status_d,
    atd_device.flevel       as  flevel_d,
    atd_device.fstatus      as  fstatus_d,
    atd_device.quality      as  quality_d,
    atd_ip.status           as  status_i,
    atd_ip.flevel           as  flevel_i,
    atd_ip.fstatus          as  fstatus_i,
    atd_ip.ip               as  ip,
    atd_ip.quality          as  quality_i
    from
    ( select substring(`time`,0,8) as report_date,waterid,type,id,appid,exid,status,flevel,fstatus,inblacklist
      from ods_wefix.atd_black_json
      where year_month = '${year_month}' and day_of_month = '${day_of_month}'
    ) as atd_black
    full join
    ( select substring(`time`,0,8) as report_date,waterid,type,id,appid,exid,status,flevel,fstatus,quality
      from ods_wefix.atd_device_json
      where year_month = '${year_month}' and day_of_month = '${day_of_month}'
    ) as atd_device on atd_black.waterid = atd_device.waterid and atd_black.appid = atd_device.appid and atd_black.exid = atd_device.exid
    full join
    ( select substring(`time`,0,8) as report_date,waterid,ip,appid,exid,status,flevel,fstatus,quality
      from ods_wefix.atd_ip_json
      where year_month = '${year_month}' and day_of_month = '${day_of_month}'
    ) as atd_ip on (atd_black.waterid = atd_ip.waterid and atd_black.appid = atd_ip.appid and atd_black.exid = atd_ip.exid)
      or (atd_device.waterid = atd_ip.waterid and atd_device.appid = atd_ip.appid and atd_device.exid = atd_ip.exid)
  ) as adt
  left join (select distinct exchange_id,
      audit_adver_id,audit_plan_id,audit_app_id,audit_user_id,apply_adver_id,apply_plan_id,apply_app_id,apply_user_id
    from ods_wefix.exchange_info_tsv
    where audit_app_id != 'null' and audit_user_id != 'null' and apply_app_id != 'null' and apply_user_id != 'null' and status > 6
  ) as exchange_info on adt.exid = exchange_info.exchange_id
)
INSERT OVERWRITE TABLE dm_cf.adt_data PARTITION(year_month,day_of_month)
select
  report_date,
  login_userid,
  login_appid,
  login_advid,
  viewer_appid,
  viewer_advid,
  count(waterid) as  req_sum,
  sum(if(fstatus_b = 1 and fstatus_d != 1 and fstatus_i != 1,1,0))  as  blacklist_sum,
  sum(if(fstatus_b != 1 and fstatus_d = 1 and fstatus_i != 1,1,0))  as  sus_device_sum,
  sum(if(fstatus_b != 1 and fstatus_d != 1 and fstatus_i = 1,1,0))  as  sus_ip_sum,
  sum(if(fstatus_b = 1 and fstatus_d = 1 and fstatus_i != 1,1,0))   as  bl_device_sum,
  sum(if(fstatus_b = 1 and fstatus_d != 1 and fstatus_i = 1,1,0))   as  bl_ip_sum,
  sum(if(fstatus_b != 1 and fstatus_d = 1 and fstatus_i = 1,1,0))   as  dvi_ip_sum,
  sum(if(fstatus_b = 1 and fstatus_d = 1 and fstatus_i = 1,1,0))    as  bl_dvi_ip_sum
  ,'${year_month}','${day_of_month}'
from base group by report_date,login_userid,login_appid,login_advid,viewer_appid,viewer_advid;
