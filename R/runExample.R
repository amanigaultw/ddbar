#' Run example app featuring ddbar() as a data selection tool
#'
#' @param example shiny app name
#'
#' @export
runExample <- function(example = "ddbarExplorer") {
  appDir <- system.file("shiny-examples", example, package = "ddbar")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `ddbar`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
