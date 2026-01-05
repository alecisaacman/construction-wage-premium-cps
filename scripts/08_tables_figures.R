# scripts/08_tables_figures.R

models <- readRDS("data_work/models_core.rds")

m1_all   <- models$m1_all
m2_all   <- models$m2_all
m3_all   <- models$m3_all
m1_blue  <- models$m1_blue
m2_blue  <- models$m2_blue
m3_blue  <- models$m3_blue

# --------------------------------------------------
# Slide 6: Baseline construction wage premium (M1)
# --------------------------------------------------

library(modelsummary)

models_slide6 <- list(
  "All Workers (M1)"  = m1_all,
  "Blue Collar (M1)"  = m1_blue
)

modelsummary(
  models_slide6,
  output    = "outputs/slide6_baseline_table.html",
  statistic = c("({std.error})", "p.value"),
  stars     = TRUE,
  coef_map  = c("construction_worker" = "Construction Worker"),
  gof_omit  = "IC|logLik|Adj|RMSE|Within"
)

cat("\nSlide 6 table exported to outputs/slide6_baseline_table.html\n")

# --------------------------------------------------
# Slide 7: Second-stage table (housing cycles, M3)
# --------------------------------------------------

modelsummary(
  list(
    "All Workers (M3)"  = m3_all,
    "Blue Collar (M3)"  = m3_blue
  ),
  coef_map = c(
    "construction_worker"            = "Construction Worker",
    "good_market"                    = "Good Market",
    "construction_worker:good_market" = "CW × Good Market"
  ),
  statistic = "({std.error})",
  gof_omit  = "AIC|BIC|IC|logLik|RMSE|Within|Adj",
  output    = "outputs/table_second_stage.html"
)

cat("Second-stage table saved to outputs/table_second_stage.html\n")