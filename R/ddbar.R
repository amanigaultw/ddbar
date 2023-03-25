#' Multilevel Drill Down Bar Widget
#'
#' @param data data list object to be plotted; typically generated using \code{dataFormat()}.
#' @param width width of the graph as CSS units.
#' @param height height of the graph as CSS units.
#' @param elementId html element id.
#' @param options list of apache echarts options
#' @param horizontal bool indicating whether the bar plot should be horizontal
#' @param showTitle bool indicating whether to display a dynamic title
#' @param reactiveID string id to be passed to \code{Shiny.setInputValue()} called within ddbar.js
#' @param delimiter string delimiter for the dataGroupId; must match the delimiter used by \code{dataFormat()}.
#'
#' @import htmlwidgets
#'
#' @examples
#'
#' rawdata <- data.frame(nationality = sample(c("French", "German", "British"),
#'                       100, replace=TRUE, prob=c(0.4, 0.3, 0.3)),
#'                       sex = sample(c("Male", "Female"),
#'                       100, replace=TRUE, prob=c(0.5, 0.5)),
#'                       occupation = sample(c("Chef", "Pilot", "Developer"),
#'                       100, replace=TRUE, prob=c(0.1, 0.7, 0.2)),
#'                       netWorth = rpois(100, 1.5) * 100000)
#'
#' options <- list(
#'   tooltip = list(
#'     trigger = 'axis',
#'     axisPointer = list(
#'       type= 'shadow'
#'     )
#'   )
#' )
#'
#' rawdata |>
#'   dataFormat(mean, mode = "vector") |>
#'   ddbar(options)
#'
#' @export
ddbar <- function(data, options = NULL, horizontal = F, showTitle = T, reactiveID = NULL, delimiter = "|", width = NULL, height = NULL, elementId = NULL) {

  if(is.null(options)){
    options <- list(animationDurationUpdate = 500)
  }

  if(is.null(reactiveID)){
    reactiveID <- "ddbar_selection"
  }

  # forward options using x
  x = list(
    data = data,
    options = options,
    flip = as.character(horizontal),
    showTitle = as.character(showTitle),
    reactiveID = reactiveID,
    delimiter = "|"
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
