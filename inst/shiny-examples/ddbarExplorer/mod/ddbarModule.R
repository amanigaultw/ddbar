# Module UI function
ddbarModuleUI <- function(id) {

  ns <- NS(id)

  tagList(
    ddbarOutput(ns('ddbar'))
  )

}

# Module server function
ddbarModuleServer <- function(id, type = 1) {
  moduleServer(
    id,

    function(input, output, session) {

      output$ddbar = renderDdbar(
        rawdata |>
          dataFormat() |>
          ddbar(options, reactiveID = session$ns("ddbar"))
      )

      # print the output of the ddbar-selection event (when fired)
      observeEvent(input$ddbar, {
        print(input$ddbar)
      })

    }
  )
}


# library(shiny)
# library(ddbar)
# library(htmlwidgets)
#
# ui <- fluidPage(
#   ddbarModuleUI("test1")
# )
#
# server <- function(input, output, session) {
#   # example data
#   #example data (categorical outcome)
#   rawdata <- data.frame(nationality = sample(c("French", "German", "British"), 1000, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
#                         sex = sample(c("Male", "Female"), 1000, replace=TRUE, prob=c(0.5, 0.5)),
#                         age = sample(c("child", "adult", "older adult"), 1000, replace=TRUE, prob=c(0.1, 0.7, 0.2)),
#                         language = sample(c("unilingual", "bilingual"), 1000, replace=TRUE, prob=c(0.7, 0.3)),
#                         TV = sample(c("less than 2h TV / day", "more than 2h TV / day"), 1000, replace=TRUE, prob=c(0.7, 0.3)),
#                         politics = sample(c("left", "center", "right"), 1000, replace=TRUE, prob=c(0.3, 0.4, 0.3)))
#
#   #pass in some example options
#   options <- list(
#     tooltip = list(
#       trigger = 'axis',
#       axisPointer = list(
#         type = 'shadow'
#       )
#     )
#   )
#
#   ddbarModuleServer("test1")
# }
#
# shinyApp(ui, server)
