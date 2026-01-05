# scripts/03_clean_cps.R
# Clean IPUMS CPS and construct core variables (men only).

cps_clean <- cps_raw |>
  # keep years that match ZHVI (2008–2022)
  dplyr::filter(year >= 2008, year <= 2022) |>
  dplyr::mutate(
    # 1. Hourly wage: prefer HOURWAGE, else EARNWEEK / UHRSWORKT
    hourly_wage = dplyr::case_when(
      !is.na(hourwage) & hourwage > 0 ~ as.numeric(hourwage),
      !is.na(earnweek) & !is.na(uhrsworkt) &
        earnweek > 0 & uhrsworkt > 0 ~ as.numeric(earnweek) / as.numeric(uhrsworkt),
      TRUE ~ NA_real_
    ),
    log_hourly_wage = log(hourly_wage),
    
    # 2. Construction worker indicator (IND 770)
    construction_worker = dplyr::if_else(ind == 770, 1L, 0L),
    
    # 3. Age squared
    age2 = age^2,
    
    # 4. Full-time: usual hours >= 35
    fulltime = dplyr::if_else(!is.na(uhrsworkt) & uhrsworkt >= 35, 1L, 0L)
  ) |>
  # baseline sample: men 25–64, employed, wage
  dplyr::filter(
    sex == 1,                   
    !is.na(log_hourly_wage),
    log_hourly_wage > 0,
    age >= 25, age <= 64,
    empstat %in% c(10, 12)      # employed-at-work / has-job-not-at-work
  ) |>
  # drop most self-employed
  dplyr::filter(!(classwkr %in% c(13, 14))) |>
  dplyr::mutate(educ_num = as.numeric(educ))

# Education bins: HS Grad as reference
cps_clean <- cps_clean |>
  dplyr::mutate(
    educ_bin = dplyr::case_when(
      educ_num < 73 ~ "Less than HS",
      educ_num == 73 ~ "HS Grad",
      educ_num > 73 & educ_num < 111 ~ "Some College/AA",
      educ_num >= 111 ~ "BA+",
      TRUE ~ NA_character_
    ),
    educ_bin = factor(
      educ_bin,
      levels = c("HS Grad", "Less than HS", "Some College/AA", "BA+")
    ),
    state = as.integer(statefip),
    year  = as.integer(year)
  ) |>
  dplyr::filter(!is.na(educ_bin))

saveRDS(cps_clean, "data_work/cps_clean.rds")
cat("\nCPS clean dimensions:", nrow(cps_clean), "rows x", ncol(cps_clean), "cols\n")
