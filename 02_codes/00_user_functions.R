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
                       "ggeffects",
                       "gt",
                       "psych",
                       "broom",
                       "gridExtra",
                       "quarto",
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


# Function to create a bar chart with error bars
create_plot <- function(data, y_var, y_label) {
  ggplot(data, aes_string(x = "age_in_months", y = y_var)) +
    geom_col(fill = "blue", col = "black") +
    geom_errorbar(aes_string(ymin = paste0(y_var, "_low"), ymax = paste0(y_var, "_upp")), width = 0.2) +
    labs(
      x = "Age in Months",
      y = y_label
    ) +
    theme_minimal()
}

run_lm_and_plot <- function(y_var, y_label) {
  # Run the GLM model
  lm_model <- lm(as.formula(paste(y_var, "~ age_in_months")), 
                   data = zwe_mics1)
  
  # Generate predictions and plot
  plot <- plot(ggeffect(lm_model, terms = "age_in_months")) +
    theme_minimal() +
    labs(
      title = "",
      x = "Age in Months",
      y = y_label
    ) +
    ylim(0, 1)
  
  return(plot)
}

run_lm_and_tidy <- function(y_var) {
  # Run the GLM model
  lm_model <- lm(as.formula(paste(y_var, "~ age_in_months")), 
                 data = zwe_mics1)
  
  # Extract coefficient, standard error, pvalue and R-squared
  tidy_output <- tidy(lm_model) %>%
    filter(term == "age_in_months") %>%
    select(estimate, std.error, p.value) %>%
    rename(
      Coefficient = estimate,
      `Standard Error` = std.error
    )
  
  # Add R-squared and number of observations
  model_stats <- glance(lm_model) %>%
    select(r.squared, nobs)
  
  tidy_output <- tidy_output %>%
    bind_cols(model_stats) %>%
    mutate(Outcome = y_var)
  
  return(tidy_output)
}


phi_correlation <- function(x, y) {
  table_data <- table(x, y)
  phi_value <- psych::phi(table_data)
  return(phi_value)
}

