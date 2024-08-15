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

## Setup Instructions

To run the scripts successfully, follow these steps:

1.  **Set Up User Profile**:
    -   Before running any scripts, you need to execute the `user_profile.R` script located in the main directory. This script sets up the user profile, including all necessary directories and environment settings.
    -   **Important**: You must manually update the `user_profile.R` script with your username for the directory paths to be correctly configured.
2.  **Execution**:
    -   Once the user profile is set up, you can proceed to execute the scripts in `02_codes/`. Ensure that the required input data is available in the `01_input_data/` directory.

## License

This project is licensed under the Apache License. Please see the LICENSE file for more details.
