# Module UI function
ddbarModuleUI <- function(id) {

  ns <- NS(id)

  tagList(

    grid(
      grid_template = grid_template(
        default = list(
          areas = rbind(
            c("ddbar", "hist1", "hist2"),
            c("DT", "DT", "DT")
          ),
          cols_width = c("1fr", "1fr", "1fr"),
          rows_height = c("1fr", "1fr")
        )
      ),
      area_styles = list(ddbar = "margin: 10px;",
                         DT = "margin: 10px;",
                         hist1 = "margin: 10px;",
                         hist2 = "margin: 10px;"),
      ddbar = div(ddbarOutput(ns('ddbarPlot')),
                  actionButton(ns("show"), "Reorder variables")),
      DT =  DT::dataTableOutput(ns('table')),
      hist1 = echarts4rOutput(ns('hist1')),
      hist2 = echarts4rOutput(ns('hist2'))
    ),

    uiOutput(ns("modalAction"))

  )

}

# Module server function
ddbarModuleServer <- function(id) {
  moduleServer(
    id,

    function(input, output, session) {

      params <- reactiveValues(fullData = rawdata,
                               order = c("nationality", "sex", "age", "politics"),
                               plotData = rawdata[,c("nationality", "sex", "age", "politics")],
                               filterVector = NA)


      observeEvent(input$show, {
        print("show modal")
        show_modal('action-example-modal', asis = F)
      })
      observeEvent(input$hide, {
        hide_modal('action-example-modal', asis = F)
      })

      output$modalAction <- renderUI({
        modal(
          grid(
            grid_template = grid_template(
              default = list(
                areas = rbind(
                  c("selectionField", "table"),
                  c("button", "table")
                ),
                cols_width = c("1fr", "1fr"),
                rows_height = c("1fr", "1fr")
              )
            ),
            area_styles = list(selectionField = "margin: 20px;", button = "margin: 20px;", table = "margin: 20px;"),
            selectionField = uiOutput(session$ns("selection")),
            button = actionButton(session$ns('update'),"Update"),
            table =  segment(class = "ui raised segment",
                             label(class = "top attached", "current order"),
                             tableOutput(session$ns('theorder')))
          ),
          id = session$ns("action-example-modal"),
          header = "Update the order of variables",
          footer = actionButton(session$ns("hide"), "Continue"),
          class = "large"
        )
      })

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
        params$plotData <- params$plotData[,params$order]
        params$filterVector <- NA
      })

      output$ddbarPlot <- renderDdbar({
        params$plotData |>
          dataFormat() |>
          ddbar(options,
                horizontal = F,
                reactiveID = session$ns("ddbar"))
      })

      observeEvent(input$ddbar,{
        params$filterVector <- unlist(strsplit(input$ddbar, split="\\|"))
      })

      tabledata <- reactive({
        if(length(params$filterVector) == 1 && is.na(params$filterVector)){
          data <- params$plotData
        } else {
          data <- applyFilterVector(params$plotData, params$filterVector)
        }
        data <- merge(data, params$fullData[ , !(names(params$fullData) %in% params$order)], by = 0)[,-1]
        return(data)
      })

      output$table = DT::renderDataTable({
        DT::datatable(tabledata(), options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
      })

      output$hist1 <- renderEcharts4r({
        tabledata() |>
          e_charts() |>
          e_histogram(x1, name = "histogram") |>
          e_tooltip(trigger = "axis") |>
          e_title("x1", left = "center") |>
          e_legend(F)
      })
      output$hist2 <- renderEcharts4r({
        tabledata() |>
          e_charts() |>
          e_histogram(x2, name = "histogram") |>
          e_tooltip(trigger = "axis") |>
          e_title("x2", left = "center") |>
          e_legend(F)
      })

    }
  )
}


# library(shiny)
# library(ddbar)
# library(htmlwidgets)
# library(DT)
# library(shinyjs)
# library(shiny.semantic)
# library(echarts4r)
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
# rawdata <- data.frame(row.names = 1:1000,
#                       nationality = sample(c("French", "German", "British"), 1000, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
#                       sex = sample(c("Male", "Female"), 1000, replace=TRUE, prob=c(0.5, 0.5)),
#                       age = sample(c("child", "adult", "older adult"), 1000, replace=TRUE, prob=c(0.1, 0.7, 0.2)),
#                       politics = sample(c("left", "center", "right"), 1000, replace=TRUE, prob=c(0.3, 0.4, 0.3)),
#                       x1 = rnorm(1000),
#                       x2 = runif(1000))
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
# ui <- function() {
#   shinyUI(
#     semanticPage(
#       ddbarModuleUI("test1")
#     )
#   )
# }
# server <- function(input, output, session) {
#   ddbarModuleServer("test1")
# }
#
# shinyApp(ui, server)
