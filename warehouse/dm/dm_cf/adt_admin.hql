with base as (
  select
  report_date,
  waterid,
  if(exchange_info.apply_app_id = appid,app_audit.app_name,app_apply.app_name)  as  login_appname,
  if(exchange_info.apply_app_id = appid,adv_audit.adv_name,adv_apply.adv_name)  as  login_advname,
  if(exchange_info.apply_app_id = appid,app_apply.app_name,app_audit.app_name)  as  viewer_appname,
  if(exchange_info.apply_app_id = appid,adv_apply.adv_name,adv_audit.adv_name)  as  viewer_advname,
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
  left join (select distinct exchange_id,audit_adver_id,audit_plan_id,audit_app_id,audit_user_id,apply_adver_id,apply_plan_id,apply_app_id,apply_user_id
    from ods_wefix.exchange_info_tsv
    where audit_app_id != 'null' and audit_user_id != 'null' and apply_app_id != 'null' and apply_user_id != 'null' and status > 6
  ) as exchange_info on adt.exid = exchange_info.exchange_id
  left join (select distinct app_id,app_name from ods_wefix.app_info_tsv) as app_audit on exchange_info.audit_app_id = app_audit.app_id
  left join (select distinct app_id,app_name from ods_wefix.app_info_tsv) as app_apply on exchange_info.apply_app_id = app_apply.app_id
  left join (select distinct advertise_id,advertise_name as adv_name from ods_wefix.advertisement_info_tsv) as adv_audit on exchange_info.audit_adver_id = adv_audit.advertise_id
  left join (select distinct advertise_id,advertise_name as adv_name from ods_wefix.advertisement_info_tsv) as adv_apply on exchange_info.apply_adver_id = adv_apply.advertise_id
)
INSERT OVERWRITE TABLE dm_cf.adt_admin PARTITION(year_month,day_of_month)
SELECT distinct
report_date,
login_appname,
login_advname,
viewer_appname,
viewer_advname,
status_b,
flevel_b,
fstatus_b,
inblacklist,
count(if(fstatus_b is null,null,waterid)) over(partition by report_date,login_appname,login_advname,viewer_appname,viewer_advname,status_b,flevel_b,fstatus_b,inblacklist
) as cnt_b,
status_d,
flevel_d,
fstatus_d,
quality_d,
count(if(fstatus_d is null,null,waterid)) over(partition by report_date,login_appname,login_advname,viewer_appname,viewer_advname,status_d,flevel_d,fstatus_d,quality_d
) as cnt_d,
status_i,
flevel_i,
fstatus_i,
quality_i,
count(if(fstatus_i is null,null,waterid)) over(partition by report_date,login_appname,login_advname,viewer_appname,viewer_advname,status_i,flevel_i,fstatus_i,quality_i
) as cnt_i
,'${year_month}','${day_of_month}'
from base
;
