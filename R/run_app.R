#' Run the Shiny Application
#'
#' @export
#' @importFrom shiny shinyApp
run_app <- function() {
  shiny::shinyApp(ui = app_ui(), server = app_server)
}
