source("1_setup.R")
source("2_data_wrangling.R")

# make faceted plot by actual MovementDateTime

# similar code to last time 
# we just change the facet wrap call and the titles etc 
ggplot(plot_data,aes(MovementDateTime,Movement_15_SEQNO, colour = Movement_Type)) +
  geom_point(alpha = 0.8) +
  scale_colour_manual(values = plot_colours) +
  facet_wrap(~ Ward_Dept, ncol = 3) +
  scale_x_datetime(date_labels = "%H:%M",date_breaks = "3 hours",
                   limits = lims,
                   timezone = "GMT",
                   expand = c(0,0)) +
  ggtitle(label = "Anytown General Hospital | Wednesday 3rd September 2014 00:00 to 23:59",
          subtitle = "A&E AND INPATIENT ARRIVALS, DEPARTURES AND TRANSFERS") +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 11) +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
  theme(axis.text.x = element_text(size = 7)) +
  theme(axis.ticks.x = element_blank()) +
  theme(legend.position = "bottom") +
  ggExtra::removeGrid() +
  ggExtra::rotateTextX()

ggsave("By-MovementDateTime-faceted-by-ward.png", width = 18.7,height = 10.4)


# now do the same plot but change the y variable
# by 15 min segment , rather than individual movement time

# we are only changing one variable
# do we really want to type all this code again?

#No - I've set up a function

source("fn_facet_plot.R")


## now we just call the function and just plug in the variables:

p <- facet_plot(df = plot_data,
                x = Movement15,
                y = Movement_15_SEQNO,
                point_colours = Movement_Type,
                n_columns = 6,Ward_Dept) # this tells the function how to facet the plot


p

ggsave("By-Movement15-faceted-by-ward.png", width = 18.7,height = 10.4)







