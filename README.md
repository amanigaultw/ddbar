

<!-- README.md is generated from README.Rmd. Please edit that file -->

# ddbar

<!-- badges: start -->
<!-- badges: end -->

 Multilevel Drilldown Bar Chart for R

## Installation

You can install the development version of ddbar from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("amanigaultw/ddbar")
```

## Example App

Illustrating how ddbar could be used within a Shiny app.

``` r
#simple example
ddbar::runExample("ddbarExplorer")

#prettier example
ddbar::runExample("ddbarExplorer1")
```

## Example Usage

Illustrating ddbar() using some dummy data.

``` r
library(ddbar)

#example data (categorical outcome)
rawdata <- data.frame(nationality = sample(c("French", "German", "British"), 1000, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
                      sex = sample(c("Male", "Female"), 1000, replace=TRUE, prob=c(0.5, 0.5)),
                      age = sample(c("child", "adult", "older adult"), 1000, replace=TRUE, prob=c(0.1, 0.7, 0.2)),
                      language = sample(c("unilingual", "bilingual"), 1000, replace=TRUE, prob=c(0.7, 0.3)),
                      TV = sample(c("less than 2h TV / day", "more than 2h TV / day"), 1000, replace=TRUE, prob=c(0.7, 0.3)),
                      politics = sample(c("left", "center", "right"), 1000, replace=TRUE, prob=c(0.3, 0.4, 0.3)))

#pass in some example options
options <- list(
  tooltip = list(
    trigger = 'axis',
    axisPointer = list(
      type = 'shadow'
    )
  )
)

#generate bar plot
rawdata |> 
  dataFormat() |>
  ddbar(options)

#generate horizontal bar plot 
rawdata |> 
  dataFormat() |>
  ddbar(options, T)

#example data (continuous outcome)  
rawdata2 <- data.frame(nationality = sample(c("French", "German", "British"), 100, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
                      sex = sample(c("Male", "Female"), 100, replace=TRUE, prob=c(0.5, 0.5)),
                      occupation = sample(c("Chef", "Pilot", "Developer"), 100, replace=TRUE, prob=c(0.1, 0.7, 0.2)),
                      income = rpois(100, 1.5) * 100000)

#generate bar plot (aggregation via mean)
rawdata2 |> 
  dataFormat(mean, mode = "vector", filterVars = c("nationality", "sex", "occupation")) |>
  ddbar()

#generate bar plot (aggregation via median)  
rawdata2 |> 
  dataFormat(median, mode = "vector", filterVars = c("nationality", "sex", "occupation")) |>
  ddbar()

#example of dataframe level aggregation 
rawdata3 <- data.frame(rawdata,
                       x1 = rnorm(100),
                       x2 = rnorm(100))

#create a function that takes the raw data as input and produces a single numeric value as output
getMeanDiffx1x2 <- function(dataframe) mean(dataframe$x1 - dataframe$x2, na.rm = TRUE)

#generate the bar plot (aggregation via getMeanDiffx1x2)
rawdata3 |>
  dataFormat(getMeanDiffx1x2, 
             mode = "dataframe", 
             filterVars = names(rawdata)) |>
  ddbar()
```
