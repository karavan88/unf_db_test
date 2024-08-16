# UNICEF Database Management Assessment

This repository is part of the UNICEF Database Management Assessment and contains all the necessary scripts, data, and documentation required to perform the assessment.

## Repository Structure

The repository is organized into the following directories:

### 1. `00_info/`

-   **Purpose**: This directory is reserved for storing project documentation and metadata. Currently, it is empty but can be populated with relevant project details, instructions, or README files that provide an overview of the assessment.

### 2. `01_input_data/`

-   **Purpose**: This folder contains all the raw data files used in the analysis. These files are typically in CSV format and include the datasets necessary for calculating various indicators as part of the assessment tasks.
-   **Contents**: CSV files that serve as the input data for the scripts.

### 3. `02_codes/`

-   **Purpose**: This is the core directory containing all the scripts required to calculate indicators and perform the analysis.
-   **Subdirectories**:
    -   `01_task1/`: Scripts related to Task 1 of the assessment.
    -   `02_task2/`: Scripts related to Task 2 of the assessment.
-   **Key Script**:
    -   `00_user_functions.R`: This script contains essential libraries and user-defined functions that are required for executing the analysis scripts in `01_task1/` and `02_task2/`.

### 4. `03_output_data/`

-   **Purpose**: This directory contains all the data files produced based on the input data files and as a result of the scripts in `02_codes/`.

### 5. Main Directory

-   **Contents**: The main directory includes essential files and scripts necessary for setting up and executing the project:
    -   **Rproj File**: The R project file (`.Rproj`) helps in managing the project within RStudio, ensuring that the working directory is set correctly and the project environment is consistent.
    -   **QMD File**: The Quarto markdown (`.qmd`) file is used to generate the final report. This file sources various scripts and produces a PDF document as the final output.
    -   **PDF File**: This is the generated report based on the Quarto file, which includes all the analysis, visualizations, and results from the assessment.
    -   **user_profile.R Script**: This script sets up the user environment by configuring directory paths based on the user's profile. It must be manually updated with the correct username for the paths to work properly.
    -   **run_project.R Script**: This script executes the analysis by sourcing the necessary scripts in `02_codes/` and generating the final report in PDF format.
    -   **Final PDF Output**: The final output of the assessment, generated from the QMD file, which contains all the results and documentation from the analysis.

## Setup Instructions

To run the scripts successfully, follow these steps:

1.  **Set Up User Profile**:
    -   Before running any scripts, you need to execute the `user_profile.R` script located in the main directory. This script sets up the user profile, including all necessary directories and environment settings.
    -   **Important**: You must manually update the `user_profile.R` script with your username for the directory paths to be correctly configured.
2.  **Execution**:
    -   Once the user profile is set up, you can proceed to execute the scripts in `run_project.R`. The last command of the script generates the final report in PDF format. You need to make sure that you have latex installed.
    -   Alternatively, you can proceed to execute the scripts in `02_codes/` and run them sequantially with the proposed numbering.
    -   Please make sure gt package in R, used to generate tables, works well and can be installed into your environment. The `user_functions.R` script installs it automatically, but different operation systems may require different configurations to make it work properly.
3.  **Running the Quarto File**:
    -   The `run_project.R` allows you to generate the final PDF report. However, you can also have the same output by running `.qmd` file in RStudio. In order to run it in VSCode or other IDE, make sure you have Quarto installed in your environment.
    -   The `.qmd` file in the main directory is used to generate the final report in PDF format. To execute this file, ensure that [Quarto](https://quarto.org/) is installed. In the latest versions of RStudio, Quarto is installed by default.
    -   To generate the report, open the `.qmd` file in RStudio and render it by clicking the "Render" button or by running the following command in the R console: `quarto::quarto_render("test_results.qmd")`
    -   Sometimes problems with rendering Quarto files may occur to the lack of tinytex. Quarto generates the error in this case and running a simple command in the R terminal (not to confuse with console) will solve the problem. The command is `quarto install tinytex`.
    -   This will produce a PDF document that includes all the analyses and results.

## License

This project is licensed under the Apache License. Please see the LICENSE file for more details.
