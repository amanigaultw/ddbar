

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

data = list(list(dataGroupId = "1",
                 data = list(c("1_1", 5, "1_1"),
                             c("1_2", 2, "1_2"))),
            list(dataGroupId = "1_1",
                 data = list(c("1_1_1", 6, "1_1_1"),
                             c("1_1_2", 8, "1_1_2"))),
            list(dataGroupId = "1_2",
                 data = list(c("1_2_1", 1),
                             c("1_2_2", 3))),
            list(dataGroupId = "1_1_1",
                 data = list(c("1_1_1_1", 10),
                             c("1_1_1_2", 9))),
            list(dataGroupId = "1_1_2",
                 data = list(c("1_1_2_1", 12),
                             c("1_1_2_2", 7)))
       )

ddbar(data)

```