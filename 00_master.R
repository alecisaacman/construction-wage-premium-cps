# --------------------------------------------------
# 00_master.R
# Running this file executes the entire pipeline:
#   1. Load required packages
#   2. Load raw data (IPUMS CPS + ZHVI housing)
#   3. Clean CPS microdata
#   4. Prepare state-year housing data
#   5. Merge CPS workers to housing data
#   6. Define regression samples
#   7. Estimate core regression models
#   8. Generate tables and figures
# --------------------------------------------------

# Clean environment and set display options
rm(list = ls())
options(scipen = 999, digits = 4)

# Load analysis scripts
source("scripts/01_load_packages.R")
source("scripts/02_load_data.R")
source("scripts/03_clean_cps.R")
source("scripts/04_prep_zhvi.R")
source("scripts/05_merge_cps_zhvi.R")
source("scripts/06_define_samples.R")
source("scripts/07_regressions.R")
source("scripts/08_tables_figures.R")
#source("scripts/09_export_working_data.R") #will submit .rds instead of .csv... (uncomment and run for .csv)


cat("\n--- Master script complete: all analysis and tables generated. ---\n")

