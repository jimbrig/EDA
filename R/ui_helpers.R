#' Insert Logo
#'
#' @param file file
#' @param style style
#' @param width width
#' @param ref ref
#'
#' @return tag
#' @export
#' @importFrom shiny tags img
insert_logo <- function(file,
                       style = "background-color: #FFF; width: 100%; height: 100%;",
                       width = NULL,
                       ref = "#"){

  shiny::tags$div(
    style = style,
    shiny::tags$a(
      shiny::img(
        src = file,
        width = width
      ),
      href = ref
    )
  )

}


#' Repeat tags$br
#'
#' @param times the number of br to return
#'
#' @return the number of br specified in times
#' @export
#'
#' @examples
#' rep_br(5)
#'
#' @importFrom htmltools HTML
#' @importFrom shiny HTML
rep_br <- function(times = 1) {
  shiny::HTML(rep("<br/>", times = times))
}

#' Icon Text
#'
#' Creates an HTML div containing the icon and text.
#'
#' @param icon fontawesome icon
#' @param text text
#'
#' @return HTML div
#' @export
#'
#' @examples
#' icon_text("table", "Table")
#'
#' @importFrom shiny tagList
icon_text <- function(icon, text) {

  i <- shiny::icon(icon)
  t <- paste0(" ", text)

  shiny::tagList(div(i, t))

}

#' Fluid Column - Shiny fluidRow + Column
#'
#' @param ... elements to include within the flucol
#' @param width width
#' @param offset offset
#'
#' @return A column wrapped in fluidRow
#' @export
#'
#' @examples
#' owEDA::flucol(12, 0, shiny::h5("HEY))
flucol <- function(..., width = 12, offset = 0) {

  if (!is.numeric(width) || (width < 1) || (width > 12))
    stop("column width must be between 1 and 12")

  shiny::fluidRow(
    shiny::column(
      width = width,
      offset = offset,
      ...
    )
  )
}
