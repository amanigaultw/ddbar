

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
                 data = list(c("animals", 5, "animals"),
                             c("fruits", 2, "fruits"))),
            list(dataGroupId = "animals",
                 data = list(c("cats", 6, "cats"),
                             c("dogs", 8, "dogs"))),
            list(dataGroupId = "fruits",
                 data = list(c("apples", 1),
                             c("oranges", 3))),
            list(dataGroupId = "cats",
                 data = list(c("calico cats", 10),
                             c("american short hair cats", 9))),
            list(dataGroupId = "dogs",
                 data = list(c("pugs", 12),
                             c("german shepherds", 7)))
		)

ddbar(data)

```