library(dplyr)
library(DBI)
library(odbc)
library(dplyr)

con <- DBI::dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "SERVERNAME", 
                      Database = "nhsr", UID = rstudioapi::askForPassword("Database user"), 
                      PWD = rstudioapi::askForPassword("Database password"), Port = 1433)


rowofdots <- dplyr::tbl(con, "nhsr")
rowofdots

  
data <-  select(rowofdots,MovementDateTime,FirstName,LastName,Ward_Dept,Staging_Post,Movement_Type,
                             IN_OUT) 

dplyr::show_query(data)

plot_data <- data %>% collect()
               
# plot_data <- plot_data %>% 
# mutate(Movement15 = lubridate::floor_date(MovementDateTime,"15 minutes")) %>% 
#   group_by(IN_OUT, Movement_Type,Staging_Post,Movement15) %>% 
#   arrange(MovementDateTime) %>% 
#   mutate(counter = case_when(
#     IN_OUT == 'IN' ~ 1,
#     IN_OUT == 'OUT' ~ -1)) %>% 
#   mutate(Movement_15_SEQNO = cumsum(counter)) %>% 
#   ungroup() 
