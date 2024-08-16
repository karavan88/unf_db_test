#-------------------------------------------------------------------
# Project: UNICEF P3 DB Manager Assessment
# Objective: Analyze the dataset for task 2
# Date: August 2024
#-------------------------------------------------------------------

### !!! BEFORE EXECUTING THIS FILE, PLEASE READ USER PROFILE STORED IN THE MAIN REPOSITORY  ###

# this command reads the file for you in case if the user profile has been already set
# source("user_profile.R")

# Now we need to install the packages needed to carry out the work
source(file.path(rCodes, "00_user_functions.R"))

zwe_mics1 <- 
  read_csv(file.path(output, "task2_master_data.csv")) %>%
  drop_na(ecdi) %>%
  drop_na(age_in_months)

# View(zwe_mics1)

### 1. Let's create a descriptive stats of all input variables starting with ED
desc_vars <- zwe_mics1 %>% select(starts_with("EC")) %>% select(-contains("ecdi"))

idx_input_descr <-
  describe(desc_vars) %>%
  as.data.frame() %>%
  # convert row names to a column
  rownames_to_column(var = "Variable") %>%
  select(Variable, n, min, mean, median, sd, max) %>%
  # round all numeric vars to 2 digits
  mutate_if(is.numeric, ~round(., 2))




#### Variables and labels
y_vars <- c("lit_num", "physical", "socio_emot", "learn", "ecdi")
# vector of alternatively calculated vars
y_vars.alt <- c("lit_num.alt", "physical.alt", "socio_emot.alt", "learn.alt", "ecdi.alt")
y_labels <- c("Literacy and Numeracy", "Physical", "Socio-Emotional", "Learning", "ECDI")

# Create a table with the descriptive info for y_vars and add labels
desc_table <- map2_dfr(y_vars.alt, y_labels, ~{
  stats <- as.data.frame(describe(zwe_mics1[[.x]]))
  stats$Variable <- .y
  return(stats)
})

# Reorder columns to have "Variable" as the first column
desc_table1 <- desc_table %>%
  select(Variable, everything()) %>%
  as_tibble() %>%
  select(Variable, n, min, mean, median, sd, max) %>%
  # round all numeric vars to 2 digits
  mutate_if(is.numeric, ~round(., 2))

desc_tab_master <-
  idx_input_descr %>%
  bind_rows(desc_table1) 
  

# Rename columns to more descriptive names, handling only the first 13 columns
colnames(desc_tab_master) <- c("Variable", "n", "Min", "Mean", "Median", "SD",  "Max")


# create a nice gt table
ecdi_desc_table <-
  gt(desc_tab_master) %>%
  tab_header(
    title = "Descriptive Statistics",
    subtitle = "Early Childhood Development Index and Subcomponents"
  ) %>%
  cols_label(
    Variable = "Variable",
    n = "N",
    Min = "Min",
    Mean = "Mean",
    Median = "Median",
    SD = "SD",
    Max = "Max"
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


cronbach.data <-
  zwe_mics1 %>%
  select(lit_num.alt, physical.alt, socio_emot.alt, learn.alt) 

alpha_result = alpha(cronbach.data)


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
  summarise(lit_num_avg = survey_mean(lit_num.alt, vartype = "ci"),
            physical_avg = survey_mean(physical.alt, vartype = "ci"),
            socio_emot_avg = survey_mean(socio_emot.alt, vartype = "ci"),
            learn_avg = survey_mean(learn.alt, vartype = "ci"),
            ecdi_avg = survey_mean(ecdi.alt, vartype = "ci"))

# Generate plots using user written functions
p_ecdi <- create_plot(ecdi_avg, "ecdi_avg", "ECDI")
p_litnum <- create_plot(ecdi_avg, "lit_num_avg", "Literacy and Numeracy")
p_physical <- create_plot(ecdi_avg, "physical_avg", "Physical")
p_socemot <- create_plot(ecdi_avg, "socio_emot_avg", "Socio-Emotional")
p_learn <- create_plot(ecdi_avg, "learn_avg", "Learning")

# Arrange the plots in a grid
# arranged_desc_ecdi <- grid.arrange(p_ecdi, p_litnum, p_physical, p_socemot, p_learn, ncol = 2)
# arranged_desc_ecdi <- grid.arrange(p_litnum, p_physical, p_socemot, p_learn, p_ecdi, ncol = 2)

### Regression analysis ####

# Run the glm model for the index and subcomponents 


# Generate a list of plots
regplots <- map2(y_vars.alt, y_labels, run_lm_and_plot) 

# Arrange the plots in a grid
# model_plots <- grid.arrange(grobs = regplots, ncol = 2)

# create the table output for the models

# Apply the function to each variable and combine the results
reg_results <- 
  bind_rows(lapply(y_vars.alt, run_lm_and_tidy)) %>%
  mutate(Outcome = y_labels,
         p.value = round(p.value, 2)) %>%
  # put outcome first
  select(Outcome, everything())


# Create a gt table
gt_lm_table <- 
  reg_results %>%
  gt() %>%
  tab_header(
    title = "Regression Results",
    subtitle = "Effect of Age in Months on ECDI Subcomponents"
  ) %>%
  cols_label(
    Outcome = "Outcome",
    #term = "Term",
    Coefficient = "Beta",
    `Standard Error` = "SE",
    p.value = "P-Value",
    r.squared = "R-Squared",
    nobs = "N"
  ) %>%
  fmt_number(
    columns = vars(Coefficient, `Standard Error`, r.squared),
    decimals = 3
  ) %>%
  tab_options(
    table.font.size = "medium",
    table.width = pct(100),
    heading.title.font.size = "large",
    heading.subtitle.font.size = "medium"
  )



