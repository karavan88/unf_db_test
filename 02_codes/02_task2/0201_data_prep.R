#-------------------------------------------------------------------
# Project: UNICEF P3 DB Manager Assessment
# Objective: Create a dataset for task 2
# Date: August 2024
#-------------------------------------------------------------------

### !!! BEFORE EXECUTING THIS FILE, PLEASE READ USER PROFILE STORED IN THE MAIN REPOSITORY  ###

# this command reads the file for you in case if the user profile has been already set
source("user_profile.R")

# Now we need to install the packages needed to carry out the work
source(file.path(rCodes, "00_user_functions.R"))

### Read the input file  ####

# positive scoring vars 
ec_positive <- c("EC6", "EC7", "EC8", "EC9", "EC11", "EC12", "EC13")
ec_negative <- c("EC10", "EC14", "EC15")

zwe_mics <- 
  read_csv(file.path(inputData, "Zimbabwe_children_under5_interview.csv")) %>%
  # Recode all variables that start with "EC" using across
  mutate(across(starts_with(ec_positive), ~ case_when(
    . == 1 ~ 1,
    . == 2 ~ 0,
    TRUE ~ NA_real_
  ))) %>%
  mutate(across(starts_with(ec_negative), ~ case_when(
    . == 1 ~ 0,
    . == 2 ~ 1,
    TRUE ~ NA_real_
  ))) %>%
  # Calculate the child's age in months
  mutate(age_in_months = interval(ymd(child_birthday), ymd(interview_date)) %/% months(1)) %>%
  # drop_na(age_in_months) %>%
  # create ecdi subcomponent and scores following the established methodology
  mutate(
    literacy = case_when(EC6 + EC7 == 2 ~ 1, TRUE ~ 0),
    numeracy = case_when(EC8 == 1 ~ 1, TRUE ~ 0),
    # lit_num = case_when( (literacy + numeracy) %in% c(1, 2) ~ 1, TRUE ~ 0),
    lit_num = case_when( (EC6 + EC7 + EC8) %in% c(2, 3) ~ 1, TRUE ~ 0),
    physical = case_when(EC9 == 1 | EC10 == 1  ~ 1, TRUE ~ 0),
    socio_emot = case_when((EC13 + EC14 + EC15) %in% c(2, 3) ~ 1, TRUE ~ 0),
    learn = case_when(EC11 == 1 | EC12 == 1 ~ 1, TRUE ~ 0),
    ecdi = case_when((lit_num + physical + socio_emot + learn) %in% c(3, 4) ~ 1, TRUE ~ 0)
  )
  
# View(zwe_mics)

# summary(zwe_mics$lit_num)
# summary(zwe_mics$ecdi)

# write down a prepared file
write_csv(zwe_mics, file.path(output, "task2_master_data.csv"))

