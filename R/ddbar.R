#' Drill Down Bar Apache echarts Widget
#'
#' @param data
#' @param width
#' @param height
#' @param elementId
#'
#' @import htmlwidgets
#'
#' @examples
#'
#' data <- data.frame(nationality = sample(c("French", "German", "British"), 1000, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
#'                    sex = sample(c("Male", "Female"), 1000, replace=TRUE, prob=c(0.5, 0.5)),
#'                    age = sample(c("child", "adult", "older adult"), 1000, replace=TRUE, prob=c(0.1, 0.7, 0.2)),
#'                    language = sample(c("unilingual", "bilingual"), 1000, replace=TRUE, prob=c(0.7, 0.3)),
#'                    TV = sample(c("less than 2h TV / day", "more than 2h TV / day"), 1000, replace=TRUE, prob=c(0.7, 0.3)),
#'                    politics = sample(c("left", "center", "right"), 1000, replace=TRUE, prob=c(0.3, 0.4, 0.3)))
#'
#' ddbar(data)
#'
#' @export
ddbar <- function(data, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    data = dataFormat(data)
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
