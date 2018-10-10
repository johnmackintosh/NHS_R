library(shiny)
library(ggplot2)
setwd(here::here())
source(here::here("1_setup.R"))
source(here::here("2_data_wrangling.R"))

setwd(here::here("Flow"))

plot_colours <- c("orangered1","royalblue2","grey60")

places <- plot_data %>%  distinct(Ward_Dept) %>% 
  rename(Location = Ward_Dept)


# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "LocInput", 
                  label = "Location:",
                  choices = places, 
                  selected = "A&E")
    ),

    # Outputs
    mainPanel(
      plotOutput(outputId = "flowplot")
    )
  )
)


# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$flowplot <- renderPlot({
    
    var1 <- input$LocInput
    
    tempdf <- plot_data %>% 
      filter(Ward_Dept == var1) 
    
    ggplot(plot_data,aes(Movement15, Movement_15_SEQNO,colour = Movement_Type)) +
      geom_point(alpha = 0) +
      geom_point(data = tempdf,aes(Movement15,Movement_15_SEQNO,colour = Movement_Type), na.rm = FALSE) +
      scale_colour_manual(values = plot_colours,drop = FALSE) +
      scale_x_datetime(date_labels = "%H:%M",date_breaks = "3 hours",
                       limits = lims,
                       timezone = "GMT",
                       expand = c(0,0)) +
      scale_y_continuous(breaks = seq(-15,15, by = 5), limits = c(-15,15)) +
      expand_limits(y = c(-15, 15)) +
      ggtitle(label = "Anytown General Hospital | Wednesday 3rd September 2014 00:00 to 23:59\n",
              subtitle = paste0(var1," ARRIVALS, DEPARTURES AND TRANSFERS")) +
      labs(x = NULL, y = NULL,caption = "NHS-R conference") +
      theme_minimal() +
      theme(legend.position = "bottom") +
      theme(panel.grid.minor = element_blank()) +
      theme(strip.text.y = element_text(angle = 180)) +
      guides(color =  guide_legend("Movement Type"))
    
  })
}

# Create the Shiny app object
shinyApp(ui = ui, server = server)
