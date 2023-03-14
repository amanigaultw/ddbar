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

#helper function
applyFilterVector <- function(data, filterVector){
  if(!is.null(filterVector) && length(filterVector) > 0){
    for(i in seq_along(filterVector)){
      data <- data[data[,i] == filterVector[i], ]
    }
  }
  data
}
