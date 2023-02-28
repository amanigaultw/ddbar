#' Run example app featuring ddbar() as a data selection tool
#'
#' @export
runExample <- function() {
  appDir <- system.file("shiny-examples", "ddbarExplorer", package = "ddbar")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `ddbar`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
