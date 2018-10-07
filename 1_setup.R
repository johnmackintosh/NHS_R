library(magrittr)
library(tidyverse)
library(lubridate)
library(scales)
library(readxl)
library(gifski)
library(plotly)
library(ggExtra)
library(here)
#library(officer)

setwd(here::here())


data <- readxl::read_xlsx("RedGreenGreyDots.xlsx", sheet = 1) #read raw data from Excel


# Note use of  readxl:: ....
# explictly identifying to use the readxl package version of this function
# otherwise this line would fail due to namespace errors
# (If a package has the same function names as another package, the last
# loaded package takes priority)
# in this case, officer would over-ride readxl, and do something 
# completely different to what is intended
# 




