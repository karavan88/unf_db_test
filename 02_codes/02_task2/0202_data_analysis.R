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
  drop_na(ecdi) %>%
  drop_na(age_in_months)

# View(zwe_mics1)

# Variables and labels
y_vars <- c("ecdi", "lit_num", "physical", "socio_emot", "learn")
y_labels <- c("ECDI", "Literacy and Numeracy", "Physical", "Socio-Emotional", "Learning")

# Create a table with the descriptive info for y_vars and add labels
desc_table <- map2_dfr(y_vars, y_labels, ~{
  stats <- as.data.frame(describe(zwe_mics1[[.x]]))
  stats$Variable <- .y
  return(stats)
})

# Reorder columns to have "Variable" as the first column
desc_table1 <- desc_table %>%
  select(Variable, everything()) %>%
  as_tibble() %>%
  select(Variable, n, mean, min, max) %>%
  # round all numeric vars to 2 digits
  mutate_if(is.numeric, ~round(., 2))


# Rename columns to more descriptive names, handling only the first 13 columns
colnames(desc_table1) <- c("Variable", "n", "Mean",  
                          "Min", "Max")


# create a nice gt table
ecdi_desc_table <-
  gt(desc_table1) %>%
  tab_header(
    title = "Descriptive Statistics",
    subtitle = "Early Childhood Development Index and Subcomponents"
  ) %>%
  cols_label(
    Variable = "Variable",
    n = "Number of Observations",
    Mean = "Mean",
    # `Standard Deviation` = "Standard Deviation",
    # Median = "Median",
    Min = "Minimum",
    Max = "Maximum"
    # Range = "Range",
    # SE = "Standard Error"
  ) %>%
  tab_options(
    table.width = pct(100)
  )

### Basic psychometric checks ####

# Let's see the basic correlation between the index and its key domains
# Select the relevant binary variables
binary_vars <- zwe_mics1 %>% select(ecdi, lit_num, physical, socio_emot, learn)

# Compute the Phi correlation matrix as the most appropriate measuere for binary variables
# Get the names of the binary variables
var_names <- colnames(binary_vars)

# Initialize an empty matrix to store the correlations
cor_matrix <- matrix(NA, nrow = length(var_names), ncol = length(var_names))
rownames(cor_matrix) <- var_names
colnames(cor_matrix) <- var_names

# Loop through pairs of variables to calculate the Phi correlation
for (i in seq_along(var_names)) {
  for (j in seq_along(var_names)) {
    if (i <= j) {
      cor_matrix[i, j] <- phi_correlation(binary_vars[[i]], binary_vars[[j]])
    } else {
      cor_matrix[i, j] <- cor_matrix[j, i]  # Matrix is symmetric
    }
  }
}

# Convert the matrix to a data frame for easier manipulation
cor_df <- as.data.frame(cor_matrix)

# Display the correlation matrix
#print(cor_df)


# Convert the matrix to a long format for ggplot
cor_df_long <- as.data.frame(as.table(cor_matrix))
colnames(cor_df_long) <- c("Var1", "Var2", "Correlation")


# Plot the correlation matrix with rounded values
cor_plot_ecdi <-
  ggplot(cor_df_long, aes(x = Var1, y = Var2, fill = Correlation)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name = "Phi Correlation") +
  geom_text(aes(label = round(Correlation, 2)), color = "black", size = 3.5) +  # Add rounded correlation values
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  coord_fixed() +
  labs(
    title = "Correlation Matrix (Phi Coefficient)",
    x = "",
    y = ""
  )


### Descriptive analysis ####

# first we wanna check how many observations are per each months by creating a barchart
ecdi_obs <-
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

# summary(zwe_mics$ecdi)

### calculate the averages by month
ecdi_avg <-
  zwe_mics1 %>%
  mutate(weight = 1) %>%
  # we need it to calculate CIs, not for actual weighting
  as_survey_design(weights = weight) %>%
  group_by(age_in_months) %>%
  summarise(lit_num_avg = survey_mean(lit_num, vartype = "ci"),
            physical_avg = survey_mean(physical, vartype = "ci"),
            socio_emot_avg = survey_mean(socio_emot, vartype = "ci"),
            learn_avg = survey_mean(learn, vartype = "ci"),
            ecdi_avg = survey_mean(ecdi, vartype = "ci"))

# Generate plots using user written functions
p_ecdi <- create_plot(ecdi_avg, "ecdi_avg", "ECDI")
p_litnum <- create_plot(ecdi_avg, "lit_num_avg", "Literacy and Numeracy")
p_physical <- create_plot(ecdi_avg, "physical_avg", "Physical Development")
p_socemot <- create_plot(ecdi_avg, "socio_emot_avg", "Socio-Emotional Development")
p_learn <- create_plot(ecdi_avg, "learn_avg", "Learning")

# Arrange the plots in a grid
# arranged_desc_ecdi <- grid.arrange(p_ecdi, p_litnum, p_physical, p_socemot, p_learn, ncol = 2)


### Regression analysis ####

# Run the glm model for the index and subcomponents 


# Generate a list of plots
regplots <- map2(y_vars, y_labels, run_glm_and_plot)

# Arrange the plots in a grid
# model_plots <- grid.arrange(grobs = regplots, ncol = 2)

# create the table output for the models
# Run models and combine tidy outputs
model_outputs <- map_df(y_vars, run_glm_and_tidy)

# Select and arrange columns for the final table
model_outputs <- model_outputs %>%
  select(Outcome, term, estimate, std.error, statistic, p.value)


# Create a gt table
gt_table <- 
  model_outputs %>%
  gt() %>%
  tab_header(
    title = "GLM Model Summary",
    subtitle = "Effect of Age in Months on Various Outcomes"
  ) %>%
  fmt_number(
    columns = vars(estimate, std.error, statistic, p.value),
    decimals = 3
  ) %>%
  cols_label(
    Outcome = "Outcome Variable",
    term = "Term",
    estimate = "Estimate (Logit)",
    std.error = "Std. Error",
    statistic = "z-value",
    p.value = "p-value"
  ) %>%
  data_color(
    columns = vars(p.value),
    colors = scales::col_numeric(
      palette = c("white", "lightblue", "blue"),
      domain = c(0, 0.05)
    )
  ) %>%
  tab_options(
    table.width = pct(100)
  )



