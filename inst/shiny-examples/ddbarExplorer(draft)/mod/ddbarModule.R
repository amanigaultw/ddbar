# Module UI function
ddbarModuleUI <- function(id) {

  ns <- NS(id)

  tagList(
    modalDialog(
      tagList(
        fluidRow(
          column(6,
                 uiOutput(ns("selection")),
                 actionButton(ns('update'),"Update")
          ),
          column(6,
                 helpText('The order of elements'),
                 tableOutput(ns('theorder'))
          )
        )
      ),
      footer = modalButton("Continue"),
      size = "l"),

    ddbarOutput(ns('ddbarPlot')),

    DT::dataTableOutput(ns('table'))
  )

}

# Module server function
ddbarModuleServer <- function(id, type = 1) {
  moduleServer(
    id,

    function(input, output, session) {

      params <- reactiveValues(order = colnames(rawdata),
                               data = rawdata)

      output$selection <- renderUI({
        selectizeInput(session$ns('neworder'),
                       'Select new order',
                       choices = params$order,
                       multiple = TRUE)
      })

      output$theorder <- renderTable(
        params$order,
        colnames = F
      )

      observeEvent(input$update,{
        id <- params$order %in% input$neworder
        params$order <- c(input$neworder, params$order[!id])
        params$data <- params$data[,params$order]
      })

      output$ddbarPlot <- renderDdbar({
        params$data |>
          dataFormat() |>
          ddbar(options,
                reactiveID = session$ns("ddbar"))
      })

      filteredData <- eventReactive(input$ddbar, {
        filterVector <- unlist(strsplit(input$ddbar, split="\\|"))
        applyFilterVector(params$data, filterVector)
      })

      output$table = DT::renderDataTable({
        data <- params$data
        if(!is.null(input$ddbar)) data <- filteredData()
        DT::datatable(data, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
      })

    }
  )
}


library(shiny)
library(ddbar)
library(htmlwidgets)
library(DT)
library(shinyjs)

applyFilterVector <- function(data, filterVector){
  if(!is.null(filterVector) && length(filterVector) > 0){
    for(i in seq_along(filterVector)){
      data <- data[data[,i] == filterVector[i], ]
    }
  }
  data
}

# # example data
# #example data (categorical outcome)
# rawdata <- data.frame(nationality = sample(c("French", "German", "British"), 1000, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
#                       sex = sample(c("Male", "Female"), 1000, replace=TRUE, prob=c(0.5, 0.5)),
#                       age = sample(c("child", "adult", "older adult"), 1000, replace=TRUE, prob=c(0.1, 0.7, 0.2)),
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
#   ddbarModuleServer("test1")
# }
#
# shinyApp(ui, server)
