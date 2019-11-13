#' App UI
#'
#' @return tagList for app's UI
#' @export
#' @importFrom shiny tagList
#' @importFrom shinydashboardPlus dashboardPagePlus
app_ui <- function() {

  shiny::tagList(

    # adding external resources
    add_external_resources(),

    # shinydashboardPagePlus with right_sidebar
    shinydashboardPlus::dashboardPagePlus(
      header = header_ui(),
      sidebar = sidebar_ui(),
      body = body_ui(),
      rightsidebar = right_sidebar_ui(),
      # footer = footer_ui(),
      # title = "OW EDA",
      skin = "black" #,
      # enable_preloader = TRUE,
      # loading_duration = 2
    )
  )

}


#' Add External Resources for owEDA
#'
#' @return invisible
#' @export
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyWidgets useSweetAlert useShinydashboardPlus
#' @importFrom shiny addResourcePath tags
add_external_resources <- function(){

  shiny::addResourcePath(
    'www', system.file('app/www', package = 'owEDA')
  )

  shiny::tags$head(
    shinyjs::useShinyjs(),
    shinyWidgets::useSweetAlert(),
    shinyWidgets::useShinydashboardPlus(),
    # shinyCleave::includeCleave(country = "us"),
    tags$link(rel = "stylesheet", type = "text/css", href = "www/styles.css"),
    tags$script(src = "www/custom.js")
  )
}
