# the faceted plot was a bit meh...
# what else could we do..
# make individual plots per ward/Dept?
# some wards have very few movements, but how many?

source("1_setup.R")
source("2_data_wrangling.R")

library(officer)
library(magrittr)


setwd(here::here())

# how many obs per group?

# base R:
table(data$Ward_Dept)

# succinct, but the output is not great..how it looks, structure etc


# using dplyr we get a tibble, which is a more useful output

plot_data %>% 
  group_by(Ward_Dept) %>% 
  count() %>% 
  #arrange in descending order
  arrange(desc(n))



## create a list of distinct ward names

places <- plot_data %>%  distinct(Ward_Dept) %>% 
  rename(Location = Ward_Dept)


#create plot function 

png_plot <- function(Location) {
  
  plot_colours <- c("orangered1","royalblue2","grey60")
  
  tempdf <- plot_data %>% 
    filter(Ward_Dept == Location) 
  
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
            subtitle = paste0(Location," ARRIVALS, DEPARTURES AND TRANSFERS")) +
    labs(x = NULL, y = NULL,caption = "NHS-R conference") +
    theme_minimal(base_size = 11) +
    theme(legend.position = "bottom") +
    theme(panel.grid.minor = element_blank()) +
    theme(strip.text.y = element_text(angle = 180)) +
    guides(color =  guide_legend("Movement Type"))
  
  ggsave(filename = paste0(Location,".png"),
         width = 10, height = 8)  
  
}



# create a folder to store .png files

dir.create(here::here("png"))

setwd(here::here("png"))

## any errors here -  did you create the folder in the first place?


# now use the walk function from purrr to create an image per location
walk(places$Location,png_plot)

#check your ".png" folder

#now copy a blank powerpoint template from home directory to current "png" directory
# file.copy(where from, what, where to)
file.copy(file.path(here::here(),"blank.pptx"), getwd())


############## automating powerpoint slides using officer ###############


# Set a footer
set_ftr <- "NHS_R Conference Oct 2018"
set_pres <- read_pptx("blank.pptx") %>% # Load template Add a slide
  add_slide(layout = "Title Slide", master = "Office Theme") %>% # Add some text to the title (ctrTitle)
  ph_with_text(type = "ctrTitle", str = "Drill Down to Individual Location") %>% # Add some text to the subtitle (subTitle)
  ph_with_text(type = "subTitle", str = "Individual Location Plots") %>% 
  ph_with_text(type = "ftr", str = set_ftr)



slidef <- function(places, pres = set_pres) {
  set_pres %>% 
    add_slide(layout = "Title and Content", master = "Office Theme") %>%
    ph_with_text(type = "ftr", str = set_ftr) %>% 
    ph_with_img(type = "body", index = 1, 
                src = paste0(places, ".png")) -> set_pres  # get images 
}



walk(places$Location, slidef)
set_pres %>% print(target = "All Wards.pptx") %>% invisible()

## hooray

# move the powerpoints elsewhere, then delete them from current folder
filestomove <- c("All Wards.pptx","blank.pptx")


file.copy(file.path(getwd(),filestomove), here::here())


file.remove(filestomove)


#make sure you are still in the png folder
getwd()

filenames <- dir()


library(gifski)
gifski(png_files = filenames, gif_file = "Location_animation.gif", width = 800, height = 600,
       delay = 1, loop = TRUE, progress = TRUE)

utils::browseURL("Location_animation.gif")

# stick this in a powerpoint too?

file.copy(file.path(here::here(),"blank.pptx"), getwd())

# Set a footer
set_ftr <- "NHS_R Conference Oct 2018"
set_pres <- read_pptx("blank.pptx") %>% # Load template Add a slide
  add_slide(layout = "Title Slide", master = "Office Theme") %>% # Add some text to the title (ctrTitle)
  ph_with_text(type = "ctrTitle", str = "Individual Location Animation") %>% # Add some text to the subtitle (subTitle)
  ph_with_text(type = "subTitle", str = "Individual Location Plots gif") %>% 
  ph_with_text(type = "ftr", str = set_ftr)




set_pres %>% 
  add_slide(layout = "Title and Content", master = "Office Theme") %>%
  ph_with_text(type = "ftr", str = set_ftr) %>% 
  ph_with_img(type = "body", index = 1, 
              src = "Location_animation.gif") -> set_pres  # get images 

set_pres %>% print(target = "Animation.pptx") %>% invisible()


# move the powerpoints to the root of the folder, then delete them from current folder
filestomove <- c("Animation.pptx","Location_animation.gif","blank.pptx")


file.copy(file.path(getwd(),filestomove), here::here())
file.remove(filestomove)

#go back home
setwd(here::here())










