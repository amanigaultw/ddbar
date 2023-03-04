# Module UI function
ddbarModuleUI <- function(id) {

  ns <- NS(id)

  tagList(
    ddbarOutput(ns('ddbar')),
    DT::dataTableOutput(ns('table'))
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
          ddbar(options,
                reactiveID = session$ns("ddbar"))
      )

      # print the output of the ddbar-selection event (when fired)
      filteredData <- eventReactive(input$ddbar, {
        filterVector <- unlist(strsplit(input$ddbar, split="\\|"))
        print(filterVector)
        applyFilterVector(rawdata, filterVector)
      })

      output$table = DT::renderDataTable({
        if(is.null(input$ddbar)){
          data <- rawdata
        } else {
          data <- filteredData()
        }

        DT::datatable(data, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
      })

    }
  )
}


# library(shiny)
# library(ddbar)
# library(htmlwidgets)
# library(DT)
#
# applyFilterVector <- function(data, filterVector){
#   if(!is.null(filterVector) && length(filterVector) > 0){
#     for(i in seq_along(filterVector)){
#       data <- data[data[,i] == filterVector[i], ]
#     }
#   }
#   data
# }
#
# # example data
# #example data (categorical outcome)
# rawdata <- data.frame(nationality = sample(c("French", "German", "British"), 1000, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
#                       sex = sample(c("Male", "Female"), 1000, replace=TRUE, prob=c(0.5, 0.5)),
#                       age = sample(c("child", "adult", "older adult"), 1000, replace=TRUE, prob=c(0.1, 0.7, 0.2)),
#                       language = sample(c("unilingual", "bilingual"), 1000, replace=TRUE, prob=c(0.7, 0.3)),
#                       TV = sample(c("less than 2h TV / day", "more than 2h TV / day"), 1000, replace=TRUE, prob=c(0.7, 0.3)),
#                       politics = sample(c("left", "center", "right"), 1000, replace=TRUE, prob=c(0.3, 0.4, 0.3)))
#
# #pass in some example options
# options <- list(
#   tooltip = list(
#     trigger = 'axis',
#     axisPointer = list(
#       type = 'shadow'
#     )
#   )
# )
#
# ui <- fluidPage(
#   ddbarModuleUI("test1")
# )
#
# server <- function(input, output, session) {
#
#   ddbarModuleServer("test1")
# }
#
# shinyApp(ui, server)
