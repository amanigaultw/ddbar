#' Drill Down Bar Apache echarts Widget
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @examples
#'
#' data = list(list(dataGroupId = "1",
#'                  data = list(c("1_1", 5, "1_1"),
#'                              c("1_2", 2, "1_2"))),
#'             list(dataGroupId = "1_1",
#'                  data = list(c("1_1_1", 6, "1_1_1"),
#'                              c("1_1_2", 8, "1_1_2"))),
#'             list(dataGroupId = "1_2",
#'                  data = list(c("1_2_1", 1),
#'                              c("1_2_2", 3))),
#'             list(dataGroupId = "1_1_1",
#'                  data = list(c("1_1_1_1", 10),
#'                              c("1_1_1_2", 9))),
#'             list(dataGroupId = "1_1_2",
#'                  data = list(c("1_1_2_1", 12),
#'                              c("1_1_2_2", 7)))
#'        )
#'
#' ddbar(data)
#'
#' @export
ddbar <- function(data, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    data = data
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'ddbar',
    x,
    width = width,
    height = height,
    package = 'ddbar',
    elementId = elementId
  )
}

#' Shiny bindings for ddbar
#'
#' Output and render functions for using ddbar within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a ddbar
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name ddbar-shiny
#'
#' @export
ddbarOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'ddbar', width, height, package = 'ddbar')
}

#' @rdname ddbar-shiny
#' @export
renderDdbar <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, ddbarOutput, env, quoted = TRUE)
}
