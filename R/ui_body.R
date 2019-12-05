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
        # darkmode::with_darkmode(),
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
