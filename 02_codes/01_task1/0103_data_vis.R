#-------------------------------------------------------------------
# Project: UNICEF P3 DB Manager Assessment
# Objective: Produces the outputs (tables and visuals) for task 1
# Date: August 2024
#-------------------------------------------------------------------

### !!! BEFORE EXECUTING THIS FILE, PLEASE READ USER PROFILE STORED IN THE MAIN REPOSITORY  ###

### !!! Script #1 and #2 should also be run before this one to create the dataset and aggregate the values  ###

source(file.path(rCodes, "00_user_functions.R"))

# Load the data
t1_aggr <- 
  read_csv(file.path(output, "task1_aggregates.csv")) %>%
  select(-c(pop_covered, total_pop)) %>%
  mutate(indicator = ifelse(str_detect(indicator, "SAB"), 
                            "Skilled birth attendant", "Antenatal care 4+ visits")) 


# Plotting 
p <-
  ggplot(t1_aggr, aes(x = Status.U5MR, y = mean, fill = Status.U5MR)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(aes(ymin = mean_low, ymax = mean_upp), width = 0.2, position = position_dodge(0.9)) +
  facet_wrap(~ indicator) +
  labs(
    title = "Mean Values by Indicator and U5MR Status with Error Bars",
    x = "U5MR Status",
    y = "Mean Value"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplotly(p)