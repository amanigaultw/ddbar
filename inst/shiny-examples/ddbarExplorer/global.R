library(shiny)
library(ddbar)
library(htmlwidgets)

#load helper functions
files = list.files(path = "R/", pattern = "*.R")
if(length(files) > 0) sapply(paste0("R/", files), source, .GlobalEnv)

#load modules
files = list.files(path = "mod/", pattern = "*.R")
if(length(files) > 0) sapply(paste0("mod/", files), source, .GlobalEnv)

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
