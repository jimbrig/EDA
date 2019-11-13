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
insertLogo <- function(file,
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
