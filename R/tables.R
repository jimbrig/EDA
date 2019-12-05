#' #' Add Delete Column to Data Table
#' #'
#' #' Adds a column of delete buttons for each row in the data frame for the first column
#' #'
#' #' @param df data frame
#' #' @param id id prefix to add to each actionButton. The buttons will be id'd as id_INDEX.
#' #' @return A DT::datatable with escaping turned off that has the delete buttons in the first column and \code{df} in the rest
#' #' @export
#' deleteButtonColumn <- function(df, id, ...) {
#'
#'   # function to create one action button as string
#'   f <- function(i) {
#'     as.character(
#'       actionButton(
#'         # The id prefix with index
#'         paste(id, i, sep = "_"),
#'         label = NULL,
#'         icon = icon('trash'),
#'         onclick = 'Shiny.setInputValue(\"deletePressed\", this.id, {priority: "event"})'))
#'   }
#'
#'   deleteCol <- unlist(lapply(seq_len(nrow(df)), f))
#'
#'   # Return a data table
#'   DT::datatable(cbind(delete = deleteCol, df),
#'                 # Need to disable escaping for html as string to work
#'                 escape = FALSE,
#'                 options = list(
#'                   # Disable sorting for the delete column
#'                   columnDefs = list(
#'                     list(targets = 1, sortable = FALSE))
#'                 ))
#' }
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#' customDT <- function(data, ) {
#'
#'   stopifnot(is.data.frame(data))
#'
#'   DT::datatable(
#'     data,
#'     extensions = c("Buttons", "ColReorder", "KeyTable"),
#'     options = list(
#'       keys = TRUE,
#'       dom = "Bt",
#'       buttons = list(
#'         'colVis',
#'         'copy', 'print',
#'         list(
#'           extend = 'collection',
#'           buttons = c('csv', 'excel', 'pdf'),
#'           text = 'Download'
#'         )
#'       ),
#'       # paging = FALSE,
#'       searching = TRUE,
#'       # initComplete = ,
#'       columnDefs = list(
#'         list(
#'           className = "dt-center",
#'           targets = c(0:13)
#'         )
#'       )
#'     ),
#'     class = "stripe cell-border",
#'     # callback = htmlwidgets::JS(js),
#'     rownames = FALSE,
#'     colnames = c(
#'       "Index",
#'       "Uploaded On",
#'       "Dataset Name",
#'       "Dataset Description",
#'       "File",
#'       "Path",
#'       "Size",
#'       "Type",
#'       "# Rows",
#'       "# Columns",
#'       "Last Modified",
#'       "Birth",
#'       "Last Accessed",
#'       "Last Changed"
#'     ),
#'     # container = sketch,
#'     caption = paste0("Sumary of Uploaded Data Files:"),
#'     # filter = "top",
#'     style = "bootstrap",
#'     # elementId = ns("files_table"),
#'     fillContainer = TRUE,
#'     autoHideNavigation = TRUE,
#'     # selection = "single",
#'     # plugins = ,
#'     editable = list(
#'       target = 'row', disable = list(columns = c(0:1, 4:13))
#'     )
#'   )
#'
#' }
