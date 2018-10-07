library(ggalluvial)

source("1_setup.R")
source("2_data_wrangling.R")


plot_data_temp <- plot_data %>% mutate(patient = paste(LastName,FirstName,sep = "_"))

flow_data <- plot_data_temp %>%
  mutate(patient = paste(LastName,FirstName,sep = "_")) %>% 
  select(patient,Movement_Type, Movement15, Staging_Post, Ward_Dept,IN_OUT) %>% 
  group_by(Ward_Dept,Staging_Post,Movement_Type, Movement15, IN_OUT) %>% 
  summarise(Frequency = n()) %>% 
  mutate(hour = lubridate::floor_date(Movement15,"1 hour"))


#alluvial

ggplot(as.data.frame(flow_data),
       aes(y = Frequency, axis1 = Movement_Type, axis2 = Staging_Post, axis3 = Ward_Dept)) +
  geom_alluvium(aes(fill = IN_OUT), width = 1/12) +
  geom_stratum(width = 1/12, fill = "black", color = "grey") +
  geom_label(stat = "stratum", label.strata = TRUE) +
  scale_x_discrete(limits = c("Type","Staging_Post","Location"), expand = c(.05, .05)) +
  scale_fill_brewer(type = "qual", palette = "Set1") +
  #scale_fill_viridis_d(option = "C") +
  ggtitle("Patient Flow - Alternative View") +
  theme_minimal(base_family = "Arial Narrow") +
  theme(legend.position = "bottom") +
  theme(panel.grid.minor = element_blank())



ggplot(as.data.frame(flow_data),
       aes(y = Frequency, axis1 = Ward_Dept, axis2 = Movement_Type)) +
  geom_alluvium(aes(fill = IN_OUT), width = 1/12) +
  geom_stratum(width = 1/12, fill = "black", color = "grey") +
  geom_label(stat = "stratum", label.strata = TRUE) +
  scale_x_discrete(limits = c("Location", "Type"), expand = c(.05, .05)) +
  scale_fill_brewer(type = "qual", palette = "Set1") +
  #scale_fill_viridis_d(option = "C") +
  ggtitle("Patient Flow - Alternative View") +
  theme_minimal(base_family = "Arial Narrow") +
  theme(legend.position = "bottom") +
  theme(panel.grid.minor = element_blank())



# faceted by frequency of grouping occurrence
ggplot(as.data.frame(flow_data),
       aes(y = Frequency,axis1 = Staging_Post, axis2 = Movement_Type, axis3 = Ward_Dept)) +
  geom_alluvium(aes(fill = IN_OUT), width = 1/12) +
  geom_stratum(width = 1/12, fill = "black", color = "grey") +
  geom_label(stat = "stratum", label.strata = TRUE) +
  scale_x_discrete(limits = c("Post","Type","Location"), expand = c(.05, .05)) +
  scale_fill_brewer(type = "qual", palette = "Set1") +
  #scale_fill_viridis_d(option = "C") +
  ggtitle("Patient Flow - By Frequency") +
  theme_minimal(base_family = "Arial Narrow") +
  theme(legend.position = "bottom") +
  facet_wrap(vars(Frequency),scales = "free") +
  theme(panel.grid.minor = element_blank())



flow_data_filtered <- flow_data %>% 
  filter(Staging_Post != "A&E")

#alluvial

ggplot(as.data.frame(flow_data_filtered),
       aes(y = Frequency, axis1 = Movement_Type, axis2 = Staging_Post, axis3 = Ward_Dept)) +
  geom_alluvium(aes(fill = IN_OUT), width = 1/12) +
  geom_stratum(width = 1/12, fill = "black", color = "grey") +
  geom_label(stat = "stratum", label.strata = TRUE) +
  scale_x_discrete(limits = c("Type","Staging_Post","Location"), expand = c(.05, .05)) +
  scale_fill_brewer(type = "qual", palette = "Set1") +
  #scale_fill_viridis_d(option = "C") +
  ggtitle("Patient Flow - Alternative View") +
  theme_minimal(base_family = "Arial Narrow") +
  theme(legend.position = "bottom") +
  theme(panel.grid.minor = element_blank()) +
  facet_wrap(vars(Staging_Post), scales = "free_y")



ggplot(as.data.frame(flow_data_filtered),
       aes(y = Frequency, axis1 = Ward_Dept, axis2 = Movement_Type)) +
  geom_alluvium(aes(fill = IN_OUT), width = 1/12) +
  geom_stratum(width = 1/12, fill = "black", color = "grey") +
  geom_label(stat = "stratum", label.strata = TRUE) +
  scale_x_discrete(limits = c("Location", "Type"), expand = c(.05, .05)) +
  scale_fill_brewer(type = "qual", palette = "Set1") +
  #scale_fill_viridis_d(option = "C") +
  ggtitle("Patient Flow - Alternative View") +
  theme_minimal(base_family = "Arial Narrow") +
  theme(legend.position = "bottom") +
  theme(panel.grid.minor = element_blank()) +
  facet_wrap(vars(Staging_Post), scales = "free_y")




