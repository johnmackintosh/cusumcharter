
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

## Expanded outputs with cusum\_simple\_extra

This function returns a dataframe

``` r
test_vec2 <- c(1,1,2,11,3,5,7,2,4,3,5)
cusum_simple_extra(test_vec2)
#>     x target si cusumx cusum_target
#> 1   1      4 -3     -3            1
#> 2   1      4 -3     -6           -2
#> 3   2      4 -2     -8           -4
#> 4  11      4  7     -1            3
#> 5   3      4 -1     -2            2
#> 6   5      4  1     -1            3
#> 7   7      4  3      2            6
#> 8   2      4 -2      0            4
#> 9   4      4  0      0            4
#> 10  3      4 -1     -1            3
#> 11  5      4  1      0            4
```

## Planned functionality

1.  CuSums for single vector with no control limits

2.  CuSum for single vector with control limits

3.  CuSums for multiple groups from dataframe, with no control limits

4.  CuSums for multiple groups from dataframe, with control limits
