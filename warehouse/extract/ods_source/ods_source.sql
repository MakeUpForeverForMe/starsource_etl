select * from table where (startDate <= DATE_FORMAT(create_time,"%Y%m%d%k%i%s") and DATE_FORMAT(create_time,"%Y%m%d%k%i%s") < endDate) or (startDate <= DATE_FORMAT(update_time,"%Y%m%d%k%i%s") and DATE_FORMAT(update_time,"%Y%m%d%k%i%s") < endDate)

