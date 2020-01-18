INSERT OVERWRITE TABLE dm_cf.retention_overview
select
create_date,
login_date,
email,
mobile,
str_to_map(concat_ws(' | ',collect_set(concat(app_name,':',cast(status as string)))))  as  apps
,'${year_month}'  as  year_month,'${day_of_month}'  as  day_of_month
from (
  select login_date,user_id,email,mobile,create_date
  from (
    select
    substring(login_time,1,8) as login_date,
    user_id,
    email,
    mobile,
    substring(create_time,1,8) as create_date,
    row_number() over(partition by user_id,substring(login_time,1,8) order by update_time desc) as od
    from ods_wefix.user_info_tsv
    where user_id not in ('87d787dc-ddaa-4dd9-b5f1-4e980177a376','2f25c429-1598-43e0-8f63-ba16ea3b1c73','dbfd22ac-9fe4-43f9-9e88-8ac0af92e52e')
  ) as tmp
  where od = 1
) as usr
left join (
  select distinct user_id,app_name,
  case status
  when 1    then '上线'
  when 2    then '下线'
  when 3    then '审核中'
  when 999  then '删除'
  else '未知' end as status
  from ods_wefix.app_info_tsv
) as app on usr.user_id = app.user_id
group by create_date,login_date,email,mobile
;
