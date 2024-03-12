fluidPage(
  titlePanel("Welcome the ddbar Demo Application!"),
  h4("The ddbar package allows you to quickly explore group composition while applying filters. Click within the bargraph below to get started."),
  hr(),
  ddbarModuleUI("ddbarMain"),
  DT::dataTableOutput('table')
)
