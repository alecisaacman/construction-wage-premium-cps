# scripts/06_define_samples.R

cps_merged <- readRDS("data_work/cps_merged.rds")

# Sample A: all workers
sample_all <- cps_merged

# Sample B: "comparable" blue-collar industries
blue_collar_inds <- c(
  770,  # Construction
  170, 180, 190,  # Natural Resources / manufacturing
  270, 280, 290,  
  370, 380, 390,  # Mining
  570, 580, 590   # Utilities Sector
)

sample_bluecollar <- cps_merged |>
  dplyr::mutate(
    blue_collar = dplyr::if_else(ind %in% blue_collar_inds, 1L, 0L)
  ) |>
  dplyr::filter(blue_collar == 1L)

saveRDS(sample_all,       "data_work/sample_all.rds")
saveRDS(sample_bluecollar,"data_work/sample_bluecollar.rds")

cat("\nSample ALL dimensions:", nrow(sample_all), "rows\n")
cat("Sample BLUE-COLLAR dimensions:", nrow(sample_bluecollar), "rows\n")
