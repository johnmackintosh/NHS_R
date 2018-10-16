facet_plot <- function(df = plot_data, x = NULL, y = NULL, 
                       point_colours = NULL, n_columns = NULL, ...) {
  
  x_quo <- enquo(x)
  
  y_quo <- enquo(y)
  
  z_quo <- enquo(point_colours)
  
  groupvars <- quos(...) ## multiple groups
  
  plot_colours <- c("orangered1","royalblue1","grey60")
  
  
  
  p <- ggplot(df,aes(x = !!x_quo, y = !!y_quo, colour = !!z_quo)) +
    geom_point(alpha = 0.8) +
    scale_colour_manual(values = plot_colours) +
    facet_wrap(groupvars, ncol = n_columns) +
    scale_x_datetime(date_labels = "%H:%M",date_breaks = "3 hours",
                     limits = lims,
                     timezone = "GMT",
                     expand = c(0,0)) +
    ggtitle(label = "Anytown General Hospital | Wednesday 3rd September 2014 00:00 to 23:59",
            subtitle = "A&E AND INPATIENT ARRIVALS, DEPARTURES AND TRANSFERS") +
    labs(x = NULL, y = NULL, caption = "NHS-R Conference 2018") +
    theme_minimal(base_size = 11) +
    theme(axis.text.y = element_blank(),
          axis.ticks.y = element_blank()) +
    theme(axis.text.x = element_text(size = 7)) +
    theme(axis.ticks.x = element_blank()) +
    theme(legend.position = "bottom") +
    ggExtra::removeGrid() +
    ggExtra::rotateTextX()
  p
  
}
