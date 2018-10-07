source("1_setup.R")
source("2_data_wrangling.R") 

library(gganimate) # needs installation via github, out of scope for this session

# Change "Tranfer In"  or "Transfer Out" to "Transfer"
plot_data$Movement_Type <- gsub("Transfer.*","Transfer",x = plot_data$Movement_Type)


#convert Movement Type to factor, as the first sequence of dots turns red instead of green
plot_data$Movement_Type <- as_factor(plot_data$Movement_Type)

#check the levels
levels(plot_data$Movement_Type)

plot_data$Movement_Type <- forcats::fct_rev(plot_data$Movement_Type)

levels(plot_data$Movement_Type)

lims <- as.POSIXct(strptime(c("2014-09-03 00:00","2014-09-04 01:00")
                            , format = "%Y-%m-%d %H:%M"))  


p <- ggplot(plot_data,aes(Movement15,Movement_15_SEQNO, colour = Movement_Type)) +
  geom_jitter(width = 0.10) +
  scale_colour_manual(values = plot_colours) +
  facet_grid(Staging_Post~.,switch = "y") +
  # facet_wrap(vars(Staging_Post), ncol = 1) +
  scale_x_datetime(date_labels = "%H:%M",date_breaks = "3 hours",
                   limits = lims,
                   timezone = "GMT",
                   expand = c(0,0)) +
  ggtitle(label = "Anytown General Hospital | Wednesday 3rd September 2014 00:00 to 23:59\n",
          subtitle = "A&E AND INPATIENT ARRIVALS, DEPARTURES AND TRANSFERS") +
  labs(x = NULL, y = NULL,
       caption = "@_johnmackintosh | johnmackintosh.com  Source: Neil Pettinger | @kurtstat | kurtosis.co.uk") +
  theme_minimal(base_size = 11) +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
  theme(axis.text.x = element_text(size = 7)) +
  theme(axis.ticks.x = element_blank()) +
  theme(legend.position = "bottom") +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_blank()) +
  theme(strip.text.y = element_text(angle = 180)) +
  guides(color = guide_legend("Movement Type")) +
  ggExtra::removeGrid() 

p <- p +
  labs(title = 'Time: {frame_time}', x = 'Time In/ Out', y = NULL) +
  transition_time(MovementDateTime) + 
  shadow_wake(wake_length = 1, exclude_phase = NULL) + 
  shadow_trail() + 
  shadow_mark(past = TRUE, future = FALSE) +
  ease_aes('linear') 
animate(p, fps = 5, width = 1000, height = 600)


anim_save("newgganimate.gif")