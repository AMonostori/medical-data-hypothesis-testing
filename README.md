**Comparative Analysis of Renal Function Across Cardiac Treatment Groups**

**Overview**

This project investigates whether different cardiac treatment protocols (Groups A, B, C) affect kidney function in patients. Using both parametric and non-parametric approaches, I analyzed creatinine and potassium levels - two key biomarkers of renal health - to determine if treatment type influences these outcomes.

Key Finding: No significant differences in renal function were detected across the three treatment groups (p > 0.05 for all tests), suggesting the cardiac interventions do not differentially impact kidney health.
Dataset

Source: Medical study data (SPV format)
Sample size: N = 208
Variables analyzed: 

CREAT_0: Baseline creatinine levels (mg/dL)
K_0: Baseline potassium levels (mEq/L)
Csoport: Treatment group assignment (1, 2, 3)


Missing data: 6 creatinine observations, 9 potassium observations (imputed with global mean)
Mean imputation was applied to preserve sample size, acknowledging this approach assumes data is missing completely at random (MCAR). For production analyses, multiple imputation or sensitivity analyses would be recommended.

**Statistical Approach**
Test Selection Rationale
I employed a multi-method approach to ensure robust conclusions:

One-Way ANOVA (parametric)

Appropriate for comparing means across 3+ independent groups
Requires normality and homogeneity of variance assumptions


Kruskal-Wallis Test (non-parametric)

Distribution-free alternative to ANOVA
Used to validate findings without relying on normality assumptions


One-Way MANOVA (multivariate)

Evaluates both biomarkers simultaneously as a vector
Accounts for potential correlation between creatinine and potassium


**Assumption Testing**
Normality (Shapiro-Wilk test):

Creatinine: Groups 1 and 3 normal (p > 0.05); Group 2 violated normality (p < 0.05)
Potassium: All groups normally distributed (p > 0.05)

Homogeneity of Variance (Brown-Forsythe test):

Both variables showed homogeneous variances across groups (p > 0.05)

Given the mixed normality results, both parametric and non-parametric tests were warranted.

**Results**
Univariate Tests

All tests failed to reject the null hypothesis of equal group means.

Multivariate Test

One-Way MANOVA: No significant difference in the combined renal profile across treatment groups (p > 0.05).

**Interpretation**

Both parametric and non-parametric approaches yielded consistent results, strengthening confidence in the conclusion. The treatment protocols studied do not appear to differentially affect renal function markers, which is clinically reassuring for patient safety.

**Visualization**
Overlapping group distributions for both biomarkers
Slight skewness in Group 2 creatinine (explaining failed normality test)
Similar central tendencies across all groups

(Density plots show group means as vertical lines: black = Group 1, red = Group 2, blue = Group 3)

**Technical Details**

library(haven)      # SPV file import
library(dplyr)      # Data manipulation
library(nortest)    # Additional normality tests
library(onewaytests) # Brown-Forsythe test
library(ggplot2)    # Visualization
library(ggpubr)     # Publication-ready plots
library(mvnormtest) # Multivariate normality

