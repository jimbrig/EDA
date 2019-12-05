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
    shiny::tags$div(
      style = 'padding: 10px; position:fixed; bottom:0px;',
      shiny::tags$a(
        shiny::tags$img(
          src = "ow-logo.png",
          width = 200
        ),
        href = "http://www.oliverwyman.com/index.html"
      )
    )
  )

}

