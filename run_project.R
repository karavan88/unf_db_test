#-------------------------------------------------------------------
# Project: UNICEF P3 DB Manager Assessment
# Objective: Run all the scripts
# Date: August 2024
#-------------------------------------------------------------------

### !!! BEFORE EXECUTING THIS FILE, PLEASE SET UP USER PROFILE STORED IN THE MAIN REPOSITORY (user_profile.R) ###

# Read the user functions script 
source(file.path(rCodes, "00_user_functions.R"))

# Read the scripts for task 1
source(file.path(codesTask1, "0101_data_prep.R"))
source(file.path(codesTask1, "0102_data_analysis.R"))
source(file.path(codesTask1, "0103_data_vis.R"))

# Read the scripts for task 2
source(file.path(codesTask2, "0201_data_prep.R"))
source(file.path(codesTask2, "0202_data_analysis.R"))

# Render the Quarto/Markdown file and save the output in pdf
quarto_render("test_results.qmd")
