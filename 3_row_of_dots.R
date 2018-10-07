source("1_setup.R")
source("2_data_wrangling.R")


p <-  ggplot(plot_data,aes(Movement15,Movement_15_SEQNO, colour = Movement_Type)) 
#p
p <- p +  geom_point(alpha = 0.8)
#p
p <- p +  scale_colour_manual(values = plot_colours)
#p
p <- p +  facet_grid(Staging_Post~., switch = "y") 
#p
## at this point , we have a pretty decent,functional  plot.
# apart from the default grey background, perhaps
# lets tweak the formatting

p <- p +  scale_x_datetime(date_labels = "%H:%M",date_breaks = "1 hour",
                           limits = lims,
                           timezone = "GMT",
                           expand = c(0,0)) 
#p

p <- p +  ggExtra::rotateTextX()

#p

p <- p +  ggtitle(label = "Anytown General Hospital | Wednesday 3rd September 2014 00:00 to 23:59\n",
                  subtitle = "A&E AND INPATIENT ARRIVALS, DEPARTURES AND TRANSFERS") 
#p 

p <- p + labs(x = NULL, y = NULL) 
#p

p <- p + theme_minimal(base_size = 11)  
#p

p <- p +  theme(axis.text.y = element_blank(),
                axis.ticks.y = element_blank()) 
#p

p <- p +  theme(axis.text.x = element_text(size = 7)) 
#p

p <- p +  theme(axis.ticks.x = element_blank()) 
#p

p <- p + theme(panel.grid.minor = element_blank(),
               panel.grid.major = element_blank()) 
#p

p <- p + theme(strip.text.y = element_text(angle = 180))
#p

p <- p + theme(legend.position = "bottom") 
#p

p <- p + guides(color = guide_legend("Movement Type"))


p

dir.create(here("img"))
setwd(here("img"))

ggsave("row_of_dots.png", height = 5.99, width = 9.46)

# go back to root of the project
setwd(here())

# zoom and expand

## use plotly for animation

ggplotly(p)
## this needs some work..


## let's do it purely in plotly:


p1 <- plot_ly(subset(plot_data, Movement_Type == "Arrival"), x = ~ Movement15, y = ~ Movement_15_SEQNO ) %>% 
  add_markers(alpha = 0.8,  text = ~ Ward_Dept, hoverinfo = "text", name = "Arrival", color = I("orange")) 


p2 <- plot_ly(subset(plot_data, Movement_Type == "Transfer"), x = ~ Movement15, y = ~ Movement_15_SEQNO ) %>% 
  add_markers(alpha = 0.8,  text = ~ Ward_Dept, hoverinfo = "text",  name = "Transfer", color = I("grey"))

p3 <- plot_ly(subset(plot_data, Movement_Type == "Departure"), x = ~ Movement15, y = ~ Movement_15_SEQNO ) %>% 
  add_markers(alpha = 0.8,  text = ~ Ward_Dept, hoverinfo = "text", name = "Departure",color = I("royalblue"))


subplot(p1,p2,p3, nrows = 3, shareX = TRUE, shareY = TRUE, titleX = FALSE,titleY = FALSE)


######################not working #################

##  try an animated version 

temp_plot <- plot_data %>% 
  mutate(Hour = lubridate::hour(Movement15))

p1 <- plot_ly(subset(temp_plot,Movement_Type == "Arrival"), x = ~ Movement15, y = ~ Movement_15_SEQNO ) %>% 
  add_markers(alpha = 0.8,  name = "Arrival", color = I("orange"), 
              frame = ~ hour(Movement15),ids = ~ Movement_Type) 


p2 <- plot_ly(subset(temp_plot,Movement_Type == "Transfer"), x = ~ Movement15, y = ~ Movement_15_SEQNO ) %>% 
  add_markers(alpha = 0.8,  name = "Transfer", color = I("grey"),frame = ~ hour(Movement15), ids = ~ Movement_Type)

p3 <- plot_ly(subset(temp_plot,Movement_Type == "Departure"), x = ~ Movement15, y = ~ Movement_15_SEQNO ) %>% 
  add_markers(alpha = 0.8, name = "Departure",color = I("royalblue"),frame = ~ hour(Movement15), ids = ~ Movement_Type)


subplot(p1,p2,p3, nrows = 3, shareX = TRUE, shareY = TRUE, titleX = FALSE,titleY = FALSE)

# does't work

# another version based on the docs..still doesn't work
base <- plot_data %>%
  plot_ly(x = ~ Movement15, y = ~ Movement_15_SEQNO, 
          text = ~ Ward_Dept, hoverinfo = "text") 

base %>%
  add_markers(color = ~ Movement_Type, frame = ~ hour(Movement15), ids = ~ Movement_Type) %>%
  animation_opts(1000, easing = "elastic", redraw = FALSE) %>%
  animation_button(
    x = 1, xanchor = "right", y = 0, yanchor = "bottom"
  ) %>%
  animation_slider(
    currentvalue = list(prefix = "Hour", font = list(color = "red"))
  )


library(metricsgraphics)

mjs_plot(plot_data, x = Movement15, y = Movement_15_SEQNO) %>%
  mjs_point(color_accessor = Movement_Type,
            color_type = "category",
            color_range = plot_colours) %>%
  mjs_labs(x = "Time", y = "IN/ OUT")
  
