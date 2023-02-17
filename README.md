

<!-- README.md is generated from README.Rmd. Please edit that file -->

# ddbar

<!-- badges: start -->
<!-- badges: end -->

 Multilevel Bar Chart Drilldown derived from Apache Echart brought to R via htmlWidget

## Installation

You can install the development version of ddbar from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("amanigaultw/ddbar")
```

## Example

``` r
library(ddbar)

data <- data.frame(nationality = sample(c("French", "German", "British"), 100, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
                      sex = sample(c("Male", "Female"), 100, replace=TRUE, prob=c(0.5, 0.5)),
                      age = sample(c("child", "adult", "older adult"), 100, replace=TRUE, prob=c(0.1, 0.7, 0.2)))

ddbar(data)

```