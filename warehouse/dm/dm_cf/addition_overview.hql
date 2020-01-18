INSERT OVERWRITE TABLE dm_cf.addition_overview
select
if(create_date_usr is null,
  if(create_date_app is null,
    if(create_date_adv is null,
      create_date_pln,
      create_date_adv),
    create_date_app),
  create_date_usr)                as  create_date,
if(cnt_usr is null,0,cnt_usr)     as  cnt_usr,
if(cnt_app is null,0,cnt_app)     as  cnt_app,
if(cnt_adv is null,0,cnt_adv)     as  cnt_adv,
if(cnt_pln is null,0,cnt_pln)     as  cnt_pln
,'${year_month}'  as  year_month,'${day_of_month}'  as  day_of_month
from (
  select
  substring(create_time,1,8)      as  create_date_usr,
  count(distinct user_id)         as  cnt_usr
  from ods_wefix.user_info_tsv
  group by substring(create_time,1,8)
) as usr
full join (
  select
  substring(create_time,1,8)      as  create_date_app,
  count(distinct app_id)          as  cnt_app
  from ods_wefix.app_info_tsv
  group by substring(create_time,1,8)
) as app on create_date_usr = create_date_app
full join (
  select
  substring(create_time,1,8)      as  create_date_adv,
  count(distinct advertise_id)    as  cnt_adv
  from ods_wefix.advertisement_info_tsv
  group by substring(create_time,1,8)
) as adv on create_date_usr = create_date_adv or create_date_app = create_date_adv
full join (
  select
  substring(create_time,1,8)      as  create_date_pln,
  count(distinct acquisition_id)  as  cnt_pln
  from ods_wefix.acquisition_plan_tsv
  group by substring(create_time,1,8)
) as pln on create_date_usr = create_date_pln or create_date_app = create_date_pln or create_date_adv = create_date_pln
order by create_date
;
