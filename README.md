# construction-wage-premium-cps
Applied economics capstone analyzing construction wage premiums using CPS data.

## Overview
Construction is one of the most cyclical labor markets in the United States, with employment and hours closely tied to housing market conditions. This project studies whether construction workers earn an hourly wage premium relative to comparable workers in other industries—and whether that premium varies across housing market cycles.

The analysis focuses on male workers ages 25–64 and uses nationally representative microdata combined with state-level housing market indicators.

## Research Questions
1. Do construction workers earn an hourly wage premium relative to similar non-construction workers?
2. Does the construction wage premium change during strong housing market periods?

## Data
- **IPUMS Current Population Survey (CPS), 2008–2022**
- **Zillow Home Value Index (ZHVI)** aggregated to the state–year level

Hourly wages are constructed from reported earnings and hours worked. Housing market conditions are measured using year-over-year home price growth.

## Empirical Approach
- Baseline wage regressions comparing construction and non-construction workers
- Controls for age, education, full-time status, and state and year fixed effects
- Interaction models linking construction wages to housing market conditions
- Robustness checks using a restricted blue-collar comparison sample

## Key Findings
- Construction workers do **not** earn a meaningful hourly wage premium relative to comparable workers.
- Estimated wage differences are small and slightly negative after controlling for demographics and fixed effects.
- Housing booms do **not** significantly raise construction workers’ hourly wages.
- Cyclical adjustments in construction appear to occur through **employment and hours**, rather than wage rates.

## Interpretation
Despite the cyclical nature of construction demand, hourly wages remain relatively stable. This suggests that labor supply adjustments - such as entry of new workers during booms - may dampen wage growth, even in strong housing markets.


**Final presentation:** See `capstone_presentation.pdf` for a summary of results and interpretation.

## How to Run the Project
1. Open `CAPSTONE_FINAL.Rproj` in RStudio.
2. Ensure required packages are installed (see `01_load_packages.R`).
3. Place CPS and housing data in local `data/` directories (not included).
4. Run `00_master.R` to execute the full analysis pipeline.

## Notes
- Raw data files are excluded due to size and licensing restrictions.
- This repository focuses on code, structure, and reproducibility of the analysis.
