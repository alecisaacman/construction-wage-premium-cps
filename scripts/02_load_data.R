# scripts/02_load_data.R
# Load raw IPUMS CPS and ZHVI data.

path_cps  <- "data_raw/ipums_cps.csv.gz"
path_zhvi <- "data_raw/housing_data_state_by_year.csv"

# Create required folders
dir.create("data_raw",  showWarnings = FALSE)
dir.create("data_work", showWarnings = FALSE)
dir.create("outputs",   showWarnings = FALSE)

# Load CPS microdata
cps_raw <- data.table::fread(path_cps) |>
  janitor::clean_names()

cat("\nCPS raw dimensions:", dim(cps_raw)[1], "rows x", dim(cps_raw)[2], "cols\n")

# Load housing (ZHVI) data
zhvi_raw <- data.table::fread(path_zhvi) |>
  janitor::clean_names()

cat("Housing raw dimensions:", dim(zhvi_raw)[1], "rows x", dim(zhvi_raw)[2], "cols\n")
