# scripts/07_regressions.R
# Run core OLS regressions (men only).

sample_all        <- readRDS("data_work/sample_all.rds")
sample_bluecollar <- readRDS("data_work/sample_bluecollar.rds")

# ------------------------------------------------
# Models for ALL workers
# ------------------------------------------------

m1_all <- fixest::feols(
  log_hourly_wage ~ construction_worker +
    age + age2 + fulltime + educ_bin |
    state + year,
  cluster = ~ state,
  data    = sample_all
)

m2_all <- fixest::feols(
  log_hourly_wage ~ construction_worker + good_market +
    age + age2 + fulltime + educ_bin |
    state + year,
  cluster = ~ state,
  data    = sample_all
)

m3_all <- fixest::feols(
  log_hourly_wage ~ construction_worker * good_market +
    age + age2 + fulltime + educ_bin |
    state + year,
  cluster = ~ state,
  data    = sample_all
)

# ------------------------------------------------
# Models for BLUE-COLLAR sample
# ------------------------------------------------

m1_blue <- fixest::feols(
  log_hourly_wage ~ construction_worker +
    age + age2 + fulltime + educ_bin |
    state + year,
  cluster = ~ state,
  data    = sample_bluecollar
)

m2_blue <- fixest::feols(
  log_hourly_wage ~ construction_worker + good_market +
    age + age2 + fulltime + educ_bin |
    state + year,
  cluster = ~ state,
  data    = sample_bluecollar
)

m3_blue <- fixest::feols(
  log_hourly_wage ~ construction_worker * good_market +
    age + age2 + fulltime + educ_bin |
    state + year,
  cluster = ~ state,
  data    = sample_bluecollar
)

saveRDS(
  list(
    m1_all  = m1_all,
    m2_all  = m2_all,
    m3_all  = m3_all,
    m1_blue = m1_blue,
    m2_blue = m2_blue,
    m3_blue = m3_blue
  ),
  "data_work/models_core.rds"
)

cat("\nRegressions estimated (6 models total).\n")
