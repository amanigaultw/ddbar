# Module UI function
ddbarModuleUI <- function(id) {

  ns <- NS(id)

  tagList(

    actionButton(ns("show"), "Reorder variables"),

    ddbarOutput(ns('ddbarPlot'))
  )

}

# Module server function
ddbarModuleServer <- function(id, data, filterVars = NULL) {
  moduleServer(
    id,

    function(input, output, session) {

      if(is.null(filterVars)) filterVars <- colnames(data)

      params <- reactiveValues(data = data,
                               filterVars = filterVars,
                               filterVector = NA)

      observeEvent(input$show, {
        showModal(modalDialog(
          tagList(
            fluidRow(
              column(6,
                     uiOutput(session$ns("selection")),
                     actionButton(session$ns('update'),"Update")
              ),
              column(6,
                     helpText('The order of elements'),
                     tableOutput(session$ns('theorder'))
              )
            )
          ),
          footer = modalButton("Continue"),
          size = "l"))
      })

      output$selection <- renderUI({
        selectizeInput(session$ns('neworder'),
                       'Select new order',
                       choices = params$filterVars,
                       multiple = TRUE)
      })

      output$theorder <- renderTable(
        params$filterVars,
        colnames = F
      )

      observeEvent(input$update,{
        id <- params$filterVars %in% input$neworder
        params$filterVars <- c(input$neworder, params$filterVars[!id])
        params$data <- params$data[,params$filterVars]
        params$filterVector <- NA
      })

      output$ddbarPlot <- renderDdbar({
        params$data |>
          dataFormat() |>
          ddbar(options,
                reactiveID = session$ns("ddbar"))
      })

      observeEvent(input$ddbar,{
        params$filterVector <- unlist(strsplit(input$ddbar, split="\\|"))
      })

      filteredData <- reactive({
        if(length(params$filterVector) == 1 && is.na(params$filterVector)){
          data <- params$data
        } else {
          data <- applyFilterVector(params$data, params$filterVector)
        }
      })

      return(filteredData)
    }
  )
}


# library(shiny)
# library(ddbar)
# library(htmlwidgets)
# library(DT)
# library(shinyjs)
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
