#-------------------------------------------------------------------
# Project: UNICEF P3 DB Manager Assessment
# Objective: Analyze the dataset for task 2
# Date: August 2024
#-------------------------------------------------------------------

### !!! BEFORE EXECUTING THIS FILE, PLEASE READ USER PROFILE STORED IN THE MAIN REPOSITORY  ###

# this command reads the file for you in case if the user profile has been already set
source("user_profile.R")

# Now we need to install the packages needed to carry out the work
source(file.path(rCodes, "00_user_functions.R"))

zwe_mics1 <- 
  read_csv(file.path(output, "task2_master_data.csv")) %>%
  drop_na(ecdi)

# we wanna check how many observations are per each months by creating a barchart

zwe_mics1 %>%
  count(age_in_months) %>%
  ggplot(aes(x = age_in_months, y = n)) +
  geom_col(fill = "blue", col = "black") +
  labs(
    title = "Number of observations by age in months",
    x = "Age in months",
    y = "Number of observations"
  ) +
  theme_minimal()

summary(zwe_mics$ecdi)

# Assuming zwe_mics1 contains your data with age_in_months and ecdi
ggplot(zwe_mics1, aes(x = age_in_months, y = ecdi)) +
  geom_point(color = "red", alpha = 0.5) +  # Original data points
  geom_smooth(method = "loess", color = "blue", se = TRUE) +  # LOESS smoothing
  labs(title = "LOESS Fit of ECDI by Age in Months",
       x = "Age in Months",
       y = "ECDI") +
  theme_minimal()


