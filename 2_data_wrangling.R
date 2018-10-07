plot_data <- data %>% 
  mutate(Movement15 = lubridate::floor_date(MovementDateTime,"15 minutes")) %>% 
  group_by(IN_OUT, Movement_Type,Staging_Post,Movement15) %>% 
  mutate( counter = if_else(IN_OUT == 'IN',1,-1),
          Movement_15_SEQNO = cumsum(counter)) %>% 
  ungroup() 



# Change "Tranfer In"  or "Transfer Out" to "Transfer"
plot_data$Movement_Type <- gsub("Transfer.*","Transfer",x = plot_data$Movement_Type)

# Set limits for plotting
lims <- as.POSIXct(strptime(c("2014-09-03 00:00","2014-09-04 01:00")
                            , format = "%Y-%m-%d %H:%M"))  

#set colours for points

plot_colours <-  c("orangered1","royalblue2","grey60")