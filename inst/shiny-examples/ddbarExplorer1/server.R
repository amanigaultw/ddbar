server <- function(input, output, session){

  filteredData <- ddbarModuleServer("ddbarMain", data = rawdata, filterVars = c("nationality", "sex", "age", "politics"))

  output$table = DT::renderDataTable({
    DT::datatable(filteredData(), options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })

  output$hist1 <- renderEcharts4r({
    filteredData() |>
      e_charts() |>
      e_histogram(x1, name = "histogram") |>
      e_tooltip(trigger = "axis") |>
      e_title("x1", left = "center") |>
      e_legend(F)
  })
  output$hist2 <- renderEcharts4r({
    filteredData() |>
      e_charts() |>
      e_histogram(x2, name = "histogram") |>
      e_tooltip(trigger = "axis") |>
      e_title("x2", left = "center") |>
      e_legend(F)
  })
}
