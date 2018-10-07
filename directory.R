library(here)

# where am I ?  (in my computer, not "Birmingham")
here()

# create a folder
dir.create(here("img"))


dir.create(here("img","png"))

#move to the outputs folder by setting the 'working directory' using setwd()
setwd(here("img"))

# check this worked - get the current working directory with  getwd()
getwd()



# go back to the root of the project
setwd(here())

#check you are back where you started
getwd()


#final test
# current working directory is the same as the 'here' directory
getwd() == here()

#set here

#set_here()
