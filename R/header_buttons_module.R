#' Header Buttons UI Module
#'
#' @param id namespace ID
#' @param contacts contacts for contact dropdown
#'
#' @return tagList
#' @export
#' @importFrom shiny NS tags actionLink icon div a
header_buttons_ui <- function(id, contacts = NULL) {

  ns <- shiny::NS(id)

  refresh <- shiny::tags$li(
    shiny::actionLink(
      ns("refresh"),
      "Refresh",
      shiny::icon("refresh")
    ),
    class = "dropdown"
  )

  help <- shiny::tags$li(
    shiny::actionLink(ns("help"),
                      label = "Help",
                      icon = shiny::icon("info-circle")),
    class = "dropdown"
  )

  contact <- contact_menu(contacts)

  logout <- shiny::tags$li(
    class = "dropdown",
    shiny::tags$a(
      href = "#",
      class = "dropdown-toggle",
      `data-toggle` = "dropdown",
      shiny::div(
        shiny::tags$i(
          class = "fa fa-sign-out"
        ),
        "Logout",
        style = "display: inline"
      )
    ),
    shiny::tags$ul(
      class = "dropdown-menu",
      shiny::tags$li(
        shiny::a(
          shiny::icon("sign-out"),
          "Logout",
          href = "__logout__"
        )
      )
    )
  )

  list(
    refresh,
    help,
    contact,
    logout
  )

}

#' Header Buttons Server Module
#'
#' @param input shiny input
#' @param output shiny output
#' @param session shiny session
#' @param help_path path to help .Rmd file
#'
#' @return server
#' @export
#' @importFrom shiny observeEvent showModal modalDialog div icon includeMarkdown
#' @importFrom shinyWidgets confirmSweetAlert
header_buttons <- function(input, output, session, help_path = "docs/help.Rmd") {

  shiny::observeEvent(input$refresh, {

    shinyWidgets::confirmSweetAlert(
      session = session,
      inputId = session$ns("confirmrefresh"),
      title = "Confirm Application Refresh?",
      text = "All progress will be lost.",
      type = "question",
      btn_labels = c("Cancel", "Confirm"),
      closeOnClickOutside = TRUE
    )

  })

  shiny::observeEvent(input$confirmrefresh, {

    if (isTRUE(input$confirmrefresh)) session$reload()

  })

  shiny::observeEvent(input$help, {
    shiny::showModal(
      shiny::modalDialog(title = shiny::div(shiny::icon("info-circle"), "Help"),
                         easyClose = TRUE,
                         fade = TRUE,
                         size = "l",
                         shiny::includeMarkdown(help_path)
      )
    )
  })

}
