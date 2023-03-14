# Module UI function
ddbarModuleUI <- function(id) {

  ns <- NS(id)

  tagList(
    div(ddbarOutput(ns('ddbarPlot')),
        actionButton(ns("show"), "Reorder variables")),
    uiOutput(ns("modalAction"))
  )

}

# Module server function
ddbarModuleServer <- function(id, data, filterVars = NULL) {
  moduleServer(
    id,

    function(input, output, session) {

      if(is.null(filterVars)) filterVars <- colnames(data)

      params <- reactiveValues(fullData = data,
                               order = filterVars,
                               plotData = data[,filterVars],
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

      filteredData <- reactive({
        if(length(params$filterVector) == 1 && is.na(params$filterVector)){
          data <- params$plotData
        } else {
          data <- applyFilterVector(params$plotData, params$filterVector)
        }
        data <- merge(data, params$fullData[ , !(names(params$fullData) %in% params$order)], by = 0)[,-1]
        return(data)
      })

      return(filteredData)
    }
  )
}

#helper function
applyFilterVector <- function(data, filterVector){
  if(!is.null(filterVector) && length(filterVector) > 0){
    for(i in seq_along(filterVector)){
      data <- data[data[,i] == filterVector[i], ]
    }
  }
  data
}
