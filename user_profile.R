#-------------------------------------------------------------------
# Project: UNICEF P3 DB Manager Assessment
# Objective: Set up the working directories for the project
# Date: August 2024
#-------------------------------------------------------------------

# This is the profile for the P# DB Manager Assessment project
# it set working directories and all directories 

# !!! this profile should be loaded before running any other script !!!

USERNAME    <- Sys.getenv("USERNAME")
USERPROFILE <- Sys.getenv("USERPROFILE")

# for Mac users
USER        <- Sys.getenv("USER")

# Set up the project folder

# This is for Windows users

#if (USERNAME == " <insert your user name here> ") {
  
  # Please insert here the path to the project folder - below is the example
  # projectFolder  <- file.path("Documents/GitHub/P3_Assessment")
  
  # !!! PREFFERED OPTION: or just set up by getting a working directory  !!!
  # projectFolder  <- getwd()
  
#} 

# This is for Mac users
if (USER == "karavan88") {
  # Please insert here the path to the project folder
  projectFolder  <- getwd()
  
  } 


# confirm that the main directory is correct
# check if the folder exists
stopifnot(dir.exists(projectFolder))


# set the project folders
info                  <-  file.path(projectFolder, "00_info")
inputData             <-  file.path(projectFolder, "01_input_data")
rCodes                <-  file.path(projectFolder, "02_codes")
codesTask1            <-  file.path(rCodes, "01_task1")
codesTask2            <-  file.path(rCodes, "02_task2")
output                <-  file.path(projectFolder, "03_outputs")

# check if directories exist
stopifnot(dir.exists(info))
stopifnot(dir.exists(inputData))
stopifnot(dir.exists(rCodes))
stopifnot(dir.exists(codesTask1))
stopifnot(dir.exists(codesTask2))
stopifnot(dir.exists(output))