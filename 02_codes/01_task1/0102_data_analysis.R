#-------------------------------------------------------------------
# Project: UNICEF P3 DB Manager Assessment
# Objective: Do the aggregates for task 1
# Date: August 2024
#-------------------------------------------------------------------

### !!! BEFORE EXECUTING THIS FILE, PLEASE READ USER PROFILE STORED IN THE MAIN REPOSITORY  ###

### !!! Script #1 should also be run before this one to create the dataset  ###

# Now we need to install the packages needed to carry out the work
source(file.path(rCodes, "00_user_functions.R"))

# Read the dataset created in the previous script

task1_dta <- 
  read_csv(file.path(output, "task1_master_data.csv")) %>%
  # no birth data for kosovo so we remove it 
  drop_na(total_birth) %>%
  # we also remove rows without indicator 
  drop_na(indicator) %>%
  filter(residence == "_T: Total") %>%
  filter(wealth_quintile == "_T: Total") %>%
  filter(age == "Y15T49: 15 to 49 years old")

# View(task1_dta)

# we wanna see the population covered
total_pop <-
  pop_data %>%
  summarise(total_pop = sum(total_birth)) %>%
  pull()

pop_covered <-
  task1_dta %>%
  group_by(indicator) %>%
  summarise(pop_covered = sum(total_birth)) %>%
  mutate(total_pop = total_pop) %>%
  mutate(share_covered = pop_covered / total_pop)

# View(pop_covered)

# Now we aggregate the data
aggregates <-
  task1_dta %>%
  as_survey(weight = total_birth) %>%
  group_by(indicator, Status.U5MR) %>%
  summarise(mean = survey_mean(value, vartype = "ci")) %>%
  left_join(pop_covered, by = "indicator")

# View(aggregates)

write_csv(aggregates, file.path(output, "task1_aggregates.csv"))






