server <- function(input, output, session){

  filtereData <- ddbarModuleServer("ddbarMain", rawdata)

  output$table = DT::renderDataTable({
    DT::datatable(filtereData(), options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
}
