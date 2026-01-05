# scripts/05_merge_cps_zhvi.R

cps_clean  <- readRDS("data_work/cps_clean.rds")
zhvi_state <- readRDS("data_work/zhvi_state.rds")

cps_merged <- cps_clean |>
  dplyr::left_join(
    zhvi_state |>
      dplyr::select(state, year, zhvi, zhvi_growth, good_market),
    by = c("state", "year")
  ) |>
  dplyr::filter(!is.na(zhvi))   # keep only state-years with housing data

saveRDS(cps_merged, "data_work/cps_merged.rds")
cat("\nCPS merged dimensions:", nrow(cps_merged), "rows x", ncol(cps_merged), "cols\n")
