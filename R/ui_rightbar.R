#' Right Sidebar UI
#'
#' @return HTML for app's right-sidebar
#' @export
#' @importFrom shinydashboardPlus rightSidebar
right_sidebar_ui <- function() {

  shinydashboardPlus::rightSidebar(
    background = "dark"
  )

}
