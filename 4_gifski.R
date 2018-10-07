source("1_setup.R")
source("2_data_wrangling.R")


#convert Movement Type to factor, as the first sequence of dots turns red instead of green
plot_data$Movement_Type <- as_factor(plot_data$Movement_Type)

#check the levels
levels(plot_data$Movement_Type)

plot_data$Movement_Type <- forcats::fct_rev(plot_data$Movement_Type)

levels(plot_data$Movement_Type)


# create some folders using your "here" : location as base


dir.create(here("gifski"))

setwd(here("gifski"))


my_folder <- getwd()

minuteplot <- function(movement15){
  
  ggplot(plot_data,aes(Movement15, Movement_15_SEQNO,colour = Movement_Type)) +
    geom_point(alpha = 0) +
    geom_point(data = plot_data[plot_data$Movement15 <= movement15,],aes(Movement15,Movement_15_SEQNO,colour = Movement_Type), na.rm = FALSE) +
    scale_colour_manual(values = plot_colours,drop = FALSE) +
    facet_grid(Staging_Post~.,switch = "y",scales = "fixed", drop = FALSE,shrink = FALSE) +
    scale_x_datetime(date_labels = "%H:%M",date_breaks = "3 hours",
                     limits = lims,
                     timezone = "GMT",
                     expand = c(0,0)) +
    #scale_y_continuous(breaks = seq(-15,15, by = 1), limits = c(-15,15)) +
    expand_limits(y = c(-15, 15)) +
    ggtitle(label = "Anytown General Hospital | Wednesday 3rd September 2014 00:00 to 23:59\n",
            subtitle = "A&E AND INPATIENT ARRIVALS, DEPARTURES AND TRANSFERS") +
    labs(x = NULL, y = NULL,
         caption = "NHS-R Conference 2018 ") +
    theme_minimal(base_size = 11) +
    theme(axis.text.y = element_blank(),
          axis.ticks.y = element_blank()) +
    theme(axis.text.x = element_text(size = 7)) +
    theme(axis.ticks.x = element_blank()) +
    theme(legend.position = "bottom") +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank()) +
    theme(strip.text.y = element_text(angle = 180)) +
    guides(color =  guide_legend("Movement Type"))
  ggsave(filename = paste0(as.numeric(movement15),".png"),
         width = 10,height = 8)  
  
}

movement15 <- unique(plot_data$Movement15) %>% 
  purrr::walk(minuteplot)

png_files <- dir(my_folder)

gifski(png_files, gif_file = "animation.gif", width = 800, height = 600,
       delay = 1, loop = TRUE, progress = TRUE)

utils::browseURL("animation.gif")

setwd(here::here())


