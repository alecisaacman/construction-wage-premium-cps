# scripts/04_prep_zhvi.R
# Prepare state-year housing variables (ZHVI) for merging with CPS data.

zhvi_state <- zhvi_raw |>
  dplyr::mutate(
    year  = as.integer(year),
    state = as.integer(statefip),
    zhvi  = as.numeric(zhvi_home_value)
  ) |>
  dplyr::arrange(state, year) |>
  dplyr::group_by(state) |>
  dplyr::mutate(
    # year-over-year home value growth by state
    zhvi_lag     = dplyr::lag(zhvi),
    zhvi_growth  = (zhvi - zhvi_lag) / zhvi_lag,
    zhvi_growth  = dplyr::if_else(
      is.infinite(zhvi_growth) | is.na(zhvi_growth),
      NA_real_,
      zhvi_growth
    ),
    # housing boom indicator: 1 if ZHVI growth > 2%, else 0
    good_market  = dplyr::if_else(zhvi_growth > 0.02, 1L, 0L)
  ) |>
  dplyr::ungroup()

saveRDS(zhvi_state, "data_work/zhvi_state.rds")
cat("\nZHVI state-year prepared:", nrow(zhvi_state), "rows x", ncol(zhvi_state), "cols\n")
