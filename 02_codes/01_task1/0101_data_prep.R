#-------------------------------------------------------------------
# Project: UNICEF P3 DB Manager Assessment
# Objective: Create a dataset for task 1
# Date: August 2024
#-------------------------------------------------------------------

### !!! BEFORE EXECUTING THIS FILE, PLEASE READ USER PROFILE STORED IN THE MAIN REPOSITORY  ###

# this command reads the file for you in case if the user profile has been already set
source("user_profile.R")

# Now we need to install the packages needed to carry out the work
source(file.path(rCodes, "00_user_functions.R"))

### Read the input files  ####

# U5MR Status data
u5mr_status <- 
  read_csv(file.path(inputData, "u5mr_status.csv")) %>%
  rename(iso3 = ISO3Code)

# View(u5mr_status)

# create a list of unicef countries 
unicef_iso3 <- unique(u5mr_status$iso3)

# Indicator files downloaded from data warehouse
dw_inds <- 
  read_csv(file.path(inputData, "dw_inds.csv")) %>%
  # create a new var by substracting the ALL symbols before ":" in the REF_AREA var
  mutate(iso3 = str_extract(`REF_AREA:Geographic area`, "^[^:]+")) %>%
  # get rid of the aggregated units asd the task evolves only countries
  filter(iso3 %in% unicef_iso3) %>%
  rename(indicator = `INDICATOR:Indicator`,
         year = `TIME_PERIOD:Time period`,
         value = `OBS_VALUE:Observation Value`,
         wealth_quintile = `WEALTH_QUINTILE:Wealth Quintile`,
         residence = `RESIDENCE:Residence`,
         age = `AGE:Current age`) %>%
  select(iso3, indicator, year, age, residence, wealth_quintile, value) %>%
  # filter latest available year
  group_by(iso3, indicator, age, residence, wealth_quintile) %>%
  filter(year == max(year)) %>%
  ungroup()
  
# View(dw_inds)



# Population data (we read the file and skip the top header)
pop_data <- 
  read_csv(file.path(inputData, "wpp_proj.csv"), skip = 1) %>%
  rename(iso3 = `ISO3 Alpha-code`,
         total_birth = `Births (thousands)`) %>%
  # select 2022 as this is the year we need for weighting 
  filter(Year == 2022) %>%
  # we also wanna keep unicef countries only 
  filter(iso3 %in% unicef_iso3) %>%
  # select only the columns we need - iso and projected birth
  select(iso3, total_birth) %>%
  # birth data is character so we need to convert
  # we need to eliminate spaces between numbers first 
  mutate(total_birth = str_replace_all(total_birth, " ", "")) %>%
  mutate(total_birth = as.numeric(total_birth))
  

# View(pop_data)

#pop_data$total_birth[pop_data$iso3 == "SMR"]

### Merge the data  ####

task1_master <-
  dw_inds %>%
  full_join(u5mr_status) %>%
  full_join(pop_data) 


# View(task1_master)

### Save the data  ####
write_csv(task1_master, file.path(output, "task1_master_data.csv"))

