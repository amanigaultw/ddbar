#' Run example app featuring ddbar() as a data selection tool
#'
#' @export
runExample1 <- function() {
  appDir <- system.file("shiny-examples", "ddbarExplorer1", package = "ddbar")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `ddbar`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
