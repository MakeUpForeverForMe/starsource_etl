select * from table where (startDate <= create_time and create_time < endDate) or (startDate <= update_time and update_time < endDate) or (startDate <= login_time and login_time < endDate)
