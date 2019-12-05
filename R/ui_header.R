#' Header UI
#'
#' \lifecycle{experimental}
#'
#' @return HTML for app header
#' @export
#' @importFrom shinydashboardPlus dashboardHeaderPlus
header_ui <- function() {

  # contacts
  contacts <- c(
    contact_item("Jimmy Briggs", "Developer", "404-239-6402", "jimmy.briggs@oliverwyman.com"),
    contact_item("Scott Sobel", "Project Manager", "614-227-6225", "scott.sobel@oliverwyman.com")
  )

  shinydashboardPlus::dashboardHeaderPlus(
    title = "OW EDA",
    enable_rightsidebar = TRUE,
    rightSidebarIcon = "dashboard",
    # left_menu = header_left_menu_ui(),
    # fixed = TRUE,
    .list = header_buttons_ui("header", contacts = contacts)
  )
}
