
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Oliver Wyman Exploratory Data Analysis (owEDA) <img src='man/figures/logo.png' align="right" height="13.5" />

<!-- badges: start -->

[![Lifecycle:
Experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Project Status:
WIP](https://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
<!-- badges: end -->

## General Overview

The goal of **owEDA** is to:

  - Save Time
  - Improve Efficiency
  - Improve Project Analysis Quality
  - Priduce Artifacts for Export Internally and Externally to Excel,
    PowerPoint, and Word

## Installation

> Since **owEDA** is a private repository make sure you have a GitHub
> PAT (personal access token) setup and have permission before
> attempting to install the package. See [Usethis Setup
> Guide](https://usethis.r-lib.org/articles/articles/usethis-setup.html#get-and-store-a-github-personal-access-token)
> for more details on setting this up.

You can install from [GitHub](https://github.com/) with:

``` r
remotes::install_github("jimbrig2011/owEDA")

# or

require(devtools)
devtools::install_github("jimbrig2011/owEDA")
```

## Run Application

After installing the package, you can run the app simply with:

``` r
owEDA::run_app()
```

## Roadmap

**owEDA** desires to provide the following features:

  - Data Upload Management:
    
      - Support easy data upload for a various number of possible data
        types (xlsx, csv, txt, etc).
      - Support advanced settings to upload different types of data
        (i.e. merge across excel tabs, headers, lines to skip, etc.)
      - Implement a “control totals” feature which allows user to
        preview the sums of numeric columns and validate / reconcile.
      - Allow user to create their own datasets from uploaded files via
        merging and transforming them
      - Provide initial summary statistics on data and preview data
        itself

  - Data Diagnostics

  - Data Dictionary

  - Data Validation Report

  - Data Summaries

  - Data Visualization

  - Export to PDF, PowerPoint, CSV, Excel, and Email

  - Multivariate Analysis

  - Feature Engineering / Variable Importance

  - Record Linkage
