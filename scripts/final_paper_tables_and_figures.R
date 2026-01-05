# ------------------------------------------------------------
# final_paper_tables_and_figures.R
# Purpose: Generate final tables and figures for ECON 490 paper
# Author: Alec Isaacman
# ------------------------------------------------------------

library(tidyverse)
library(scales)

# Regression-table packages
library(modelsummary)
library(sandwich)
library(lmtest)

# ------------------------------------------------------------
# 0) Output folder
# ------------------------------------------------------------
out_dir <- "outputs/final_paper"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# ------------------------------------------------------------
# 1) Load final datasets (RDS)
# ------------------------------------------------------------
df_all  <- readRDS("data_work/sample_all.rds")
df_blue <- readRDS("data_work/sample_bluecollar.rds")

# ------------------------------------------------------------
# 2) FIGURE 1 — Housing Market Cycles
#    (Share of state-years classified as GoodMarket)
# ------------------------------------------------------------
fig1_df <- df_all %>%
  distinct(state, year, good_market) %>%   # one obs per state-year
  group_by(year) %>%
  summarise(share_good = mean(good_market == 1, na.rm = TRUE), .groups = "drop")

p1 <- ggplot(fig1_df, aes(x = year, y = share_good)) +
  geom_col() +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Figure 1: Share of State-Years with Strong Housing Market Growth (2008–2022)",
    x = "Year",
    y = "Share of states classified as GoodMarket",
    caption = "Notes: GoodMarket equals 1 when year-over-year ZHVI growth exceeds 2%."
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(out_dir, "Figure1_GoodMarketShare.png"),
       p1, width = 8.5, height = 5.5, dpi = 300)

# ------------------------------------------------------------
# 3) FIGURE 2 — Wage Distribution
#    (Boxplot of log hourly wages by construction status)
# ------------------------------------------------------------
p2 <- df_all %>%
  mutate(group = if_else(construction_worker == 1, "Construction", "Non-construction")) %>%
  ggplot(aes(x = group, y = log_hourly_wage)) +
  geom_boxplot() +
  labs(
    title = "Figure 2: Distribution of Log Hourly Wages by Construction Status",
    x = "",
    y = "Log hourly wage",
    caption = "Notes: Sample restricted to male workers ages 25–64 (CPS)."
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(out_dir, "Figure2_WageBoxplot.png"),
       p2, width = 7.5, height = 5.5, dpi = 300)

# ------------------------------------------------------------
# 4) TABLE 1 — Summary Statistics (All men vs Blue-collar men)
# ------------------------------------------------------------
# Helper to compute summary stats
summ_stats <- function(d) {
  tibble(
    N = nrow(d),
    `Mean log hourly wage` = mean(d$log_hourly_wage, na.rm = TRUE),
    `SD log hourly wage`   = sd(d$log_hourly_wage, na.rm = TRUE),
    `Share construction`   = mean(d$construction_worker == 1, na.rm = TRUE),
    `Mean age`             = mean(d$age, na.rm = TRUE),
    `Share full-time`      = mean(d$full_time == 1, na.rm = TRUE),
    `Share GoodMarket`     = mean(d$good_market == 1, na.rm = TRUE)
  )
}

t1_all  <- summ_stats(df_all)  %>% mutate(Sample = "All men")
t1_blue <- summ_stats(df_blue) %>% mutate(Sample = "Blue-collar men")

table1 <- bind_rows(t1_all, t1_blue) %>%
  select(Sample, everything()) %>%
  pivot_longer(cols = -Sample, names_to = "Variable", values_to = "Value") %>%
  pivot_wider(names_from = Sample, values_from = Value) %>%
  mutate(
    `All men` = if_else(Variable == "N", round(`All men`, 0), round(`All men`, 3)),
    `Blue-collar men` = if_else(Variable == "N", round(`Blue-collar men`, 0), round(`Blue-collar men`, 3))
  )

write_csv(table1, file.path(out_dir, "Table1_SummaryStats.csv"))

# ------------------------------------------------------------
# 5) TABLES 2 & 3 — Regression output from saved models
# ------------------------------------------------------------
models <- readRDS("data_work/models_core.rds")

# Inspect model names (helpful if anything errors)
print(names(models))

# ---- Robust SEs clustered by state ----
# Note: state must be present in model frame. This works if your regressions used `state` as the cluster unit.
cluster_se <- function(model) {
  vcovCL(model, cluster = model$model$state)
}

# TABLE 2: Baseline construction premium
# Expected model objects: m1_all and m1_blue (adjust if your names differ)
table2_file <- file.path(out_dir, "Table2_BaselinePremium.html")

modelsummary(
  list("All men" = models$m1_all, "Blue-collar men" = models$m1_blue),
  vcov = list(cluster_se(models$m1_all), cluster_se(models$m1_blue)),
  statistic = "({std.error})",
  stars = TRUE,
  fmt = 3,
  output = table2_file,
  title = "Table 2: Baseline Construction Wage Premium",
  notes = "Notes: Dependent variable is log hourly wage. Controls include age, age squared, education, and full-time status, with state and year fixed effects. Standard errors clustered at the state level."
)

# TABLE 3: Cyclicality interaction with GoodMarket
# Expected model objects: m2_all and m2_blue (adjust if your names differ)
table3_file <- file.path(out_dir, "Table3_Cyclicality.html")

modelsummary(
  list("All men" = models$m2_all, "Blue-collar men" = models$m2_blue),
  vcov = list(cluster_se(models$m2_all), cluster_se(models$m2_blue)),
  statistic = "({std.error})",
  stars = TRUE,
  fmt = 3,
  output = table3_file,
  title = "Table 3: Construction Wages and Housing Market Cyclicality",
  notes = "Notes: GoodMarket equals 1 when state-level year-over-year ZHVI growth exceeds 2%. The interaction term tests whether the construction wage differential changes in strong housing markets. Controls include age, age squared, education, and full-time status, with state and year fixed effects. Standard errors clustered at the state level."
)

# ------------------------------------------------------------
# 6) Confirm outputs
# ------------------------------------------------------------
cat("\n--- Final paper outputs written to:", out_dir, "---\n")
print(list.files(out_dir))
