#-------------------------------------------------------------------
# Project: UNICEF P3 DB Manager Assessment
# Objective: User functions (library upload )
# Date: August 2024
#-------------------------------------------------------------------

# This script contains user-written functions needed to execute the other codes
# First, checks if a specific library is installed, and if not, installs it.
# On the next step all the necessary packages are loaded in the system at once. 


# List of required packages
required_packages <- c("readr", 
                       "tidyverse", 
                       "srvyr",
                       "data.table", 
                       "countrycode",
                       "readxl",
                       "plotly",
                       "lubridate",
                       "mgcv",
                       "haven")

# Function to check and install packages
check_and_install_packages <- function(packages) {
  for (package in packages) {
    if (!requireNamespace(package, quietly = TRUE)) {
      install.packages(package)
    }
    library(package, character.only = TRUE)
  }
}

# Call the function with the list of required packages
check_and_install_packages(required_packages)