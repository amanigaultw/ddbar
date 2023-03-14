ui <- function() {
  shinyUI(
    semanticPage(

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
        ddbar = ddbarModuleUI("ddbarMain"),
        DT = DT::dataTableOutput('table'),
        hist1 = echarts4rOutput('hist1'),
        hist2 = echarts4rOutput('hist2')
      )

    )
  )
}
