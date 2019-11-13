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

#' Sidebar UI
#'
#' @return HTML for app sidebar
#' @export
#' @importFrom desc desc_get_version
#' @importFrom shiny tags h5 br hr icon
#' @importFrom shinydashboard dashboardSidebar sidebarMenu menuItem menuSubItem
sidebar_ui <- function() {

  shinydashboard::dashboardSidebar(
    shiny::tags$div(
      shiny::h5(
        "Exploatory Data Analysis",
        shiny::br(),
        paste0(
          "App Version: ",
          desc::desc_get_version(
            file = system.file(
              "DESCRIPTION",
              package = "owEDA"
            )
          )
        ),
        shiny::hr()
      ),
      align = "center",
      style = "font-weight: bold; color: #ffffff;"
    ),

    shinydashboard::sidebarMenu(
      id = "sidebar_menus",
      shinydashboard::menuItem(
        "Data Upload",
        tabName = "upload_data",
        icon = shiny::icon("cloud-upload"),
        selected = TRUE
      ),
      shinydashboard::menuItem(
        "Data Diagnostics",
        tabName = "diagnostics",
        icon = shiny::icon("cogs")
      ),
      shinydashboard::menuItem(
        "Data Dictionary",
        tabName = "data_dictionary",
        icon = shiny::icon("list")
      ),
      shinydashboard::menuItem(
        "Data Insights",
        tabName = "insights",
        icon = shiny::icon("lightbulb"),
        startExpanded = FALSE,
        shinydashboard::menuSubItem(
          "Distributions",
          tabName = "distributions",
          icon = shiny::icon("area-chart"),
        ),
        shinydashboard::menuSubItem(
          "Univariate Analysis",
          tabName = "univariate",
          icon = shiny::icon("line-chart")
        ),
        shinydashboard::menuSubItem(
          "Bi-Variate Analysis",
          tabName = "bivariate",
          icon = shiny::icon("bar-chart")
        )
      ),
      shinydashboard::menuItem(
        "Data Modelling",
        tabName = "model",
        icon = shiny::icon("calculator"),
        startExpanded = FALSE,
        shinydashboard::menuSubItem(
          "Predictor Relationships",
          tabName = "predictors",
          icon = shiny::icon("balance-scale"),
        ),
        shinydashboard::menuSubItem(
          "Feature Engineering",
          tabName = "feature",
          icon = shiny::icon("sliders")
        )
      )
    ),
    insertLogo(
      file = "www/ow-logo.png",
      style = 'padding: 10px; position:fixed; bottom:10px;',
      width = 200,
      ref = "http://www.oliverwyman.com/index.html"
    )
  )

}


#' Body UI
#'
#' @return HTML for app body
#' @export
#' @importFrom shiny fluidRow column
#' @importFrom shinydashboard dashboardBody tabItems tabItem box
#' @importFrom shinyWidgets radioGroupButtons
body_ui <- function() {

  shinydashboard::dashboardBody(

    shinydashboard::tabItems(

      shinydashboard::tabItem(
        tabName = "upload_data",
        upload_data_ui("data"),
        # upload_files_ui("data")
        # shinyWidgets::radioGroupButtons(
        #   "file_type",
        #   "Select File Type:",
        #   choices = c(
        #     `<div><i class="fa fa-file-excel"></i> Excel</div>` = "xl",
        #     `<div><i class="fa fa-file-text"></i> CSV</div>` = "csv",
        #     `<div><i class='fa fa-file-text'></i> Text</div>` = "txt",
        #     `<div><i class='fa fa-file-pdf-o'></i> PDF</div>` = "pdf",
        #     `<div><i class='fa fa-cubes'></i> R Data File</div>` = "rdata",
        #     `<div><i class='fa fa-clipboard'></i> Copy/Paste</div>` = "copy"
        #   ),
        #   selected = "xl",
        #   status = "primary",
        #   size = "normal",
        #   direction = "horizontal",
        #   individual = TRUE,
        #   justified = TRUE
        # )
      )
    )
  )
}

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

