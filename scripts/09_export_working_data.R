# scripts/09_export_working_data.R
# Export working datasets as CSV for submission.

sample_all        <- readRDS("data_work/sample_all.rds")
sample_bluecollar <- readRDS("data_work/sample_bluecollar.rds")

# These CSVs match the samples used in 07_regressions.R
readr::write_csv(sample_all,        "data_work/sample_all_men_only.csv")
readr::write_csv(sample_bluecollar, "data_work/sample_bluecollar_men_only.csv")

cat("\nWorking datasets exported to data_work/ as CSV files.\n")
