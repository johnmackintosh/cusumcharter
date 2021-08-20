
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cusumcharter

<!-- badges: start -->

[![R-CMD-check](https://github.com/johnmackintosh/cusumcharter/workflows/R-CMD-check/badge.svg)](https://github.com/johnmackintosh/cusumcharter/actions)

[![Codecov test
coverage](https://codecov.io/gh/johnmackintosh/cusumcharter/branch/master/graph/badge.svg)](https://codecov.io/gh/johnmackintosh/cusumcharter?branch=master)

<!-- badges: end -->

The goal of cusumcharter is to create both simple CuSum charts, with and
without control limits from a vector, or to create multiple CuSum
charts, with or without control limits, from a grouped dataframe, tibble
or data.table

## Installation

Install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("johnmackintosh/cusumcharter")
```

## A Simple CuSum calculation

This returns the CuSum statistics for a simple vector, centred on a
supplied target value:

``` r
library(cusumcharter)
test_vec <- c(0.175, 0.152, 0.15, 0.207, 0.136, 0.212, 0.166)

CuSum_res <- cusum_simple(test_vec, target = 0.16)
CuSum_res
#> [1] 0.175 0.167 0.157 0.204 0.180 0.232 0.238
```

## Planned functionality

1.  CuSums for single vector with no control limits

2.  CuSum for single vector with control limits

3.  CuSums for multiple groups from dataframe, with no control limits

4.  CuSums for multiple groups from dataframe, with control limits
