INSERT OVERWRITE TABLE dm_cf.unfraud_recommend_wefix PARTITION(year_month,day_of_month)
select
if(atd_black.report_date is null,if(atd_device.report_date is null,atd_ip.report_date,atd_device.report_date),atd_black.report_date) as report_date,
if(atd_black.appid is null,if(atd_device.appid is null,atd_ip.appid,atd_device.appid),atd_black.appid) as appid,
blacklist,request_sum,
device_exce,device_good,device_gene,device_diff,device_erro,
iprate_exce,iprate_gene,iprate_diff,iprate_erro,
'${year_month}','${day_of_month}'
from
( select
  substring(`time`,0,8) as report_date,
  appid,
  count(distinct if(inblacklist = true,id,null)) as blacklist,
  count(id) as request_sum
  from ods_wefix.atd_black_json
  where year_month = ${year_month} and day_of_month = ${day_of_month}
  group by substring(`time`,0,8),appid
) as atd_black
full join
( select
  report_date,
  appid,
  sum(device_exce) as device_exce,
  sum(device_good) as device_good,
  sum(device_gene) as device_gene,
  sum(device_diff) as device_diff,
  sum(device_erro) as device_erro
  from
  ( select
    report_date,
    appid,
    case quality when '优' then quality_count_device else 0 end device_exce,
    case quality when '良' then quality_count_device else 0 end device_good,
    case quality when '一般' then quality_count_device else 0 end device_gene,
    case quality when '差' then quality_count_device else 0 end device_diff,
    case when quality is null then quality_count_device else 0 end device_erro
    from
    ( select
      substring(`time`,0,8) as report_date,
      appid,
      if(quality not in ('优','良','一般','差'),null,quality) as quality,
      count(id) as quality_count_device
      from ods_wefix.atd_device_json
      where year_month = ${year_month} and day_of_month = ${day_of_month}
      group by substring(`time`,0,8),appid,quality
    ) as tmp
  ) as tmp
  group by report_date,appid
) as atd_device
on atd_black.report_date = atd_device.report_date and atd_black.appid = atd_device.appid
full join
( select
  report_date,
  appid,
  sum(iprate_exce) as iprate_exce,
  sum(iprate_gene) as iprate_gene,
  sum(iprate_diff) as iprate_diff,
  sum(iprate_erro) as iprate_erro
  from
  ( select
    report_date,
    appid,
    case quality when '正常' then quality_count_ip else 0 end iprate_exce,
    case quality when '一般' then quality_count_ip else 0 end iprate_gene,
    case quality when '可疑' then quality_count_ip else 0 end iprate_diff,
    case when quality is null then quality_count_ip else 0 end iprate_erro
    from
    ( select
      substring(`time`,0,8) as report_date,
      appid,
      if(quality not in ('正常','一般','可疑'),null,quality) as quality,
      count(ip) as quality_count_ip
      from ods_wefix.atd_ip_json
      where year_month = ${year_month} and day_of_month = ${day_of_month}
      group by substring(`time`,0,8),appid,quality
    ) as tmp
  ) as tmp
  group by report_date,appid
) as atd_ip
on atd_black.report_date = atd_ip.report_date and atd_black.appid = atd_ip.appid
order by report_date,appid;
