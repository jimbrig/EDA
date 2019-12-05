#' Upload Data Module - UI
#'
#' @param id Namespace ID
#'
#' @return tagList of shinyFiles buttons
#' @export
#'
#' @examples
#' \dontrun{
#' upload_data_ui("data")
#' }

#' @importFrom DT DTOutput
#' @importFrom shiny NS tagList fluidRow column icon
#' @importFrom shinydashboard box
#' @importFrom shinyFiles shinyFilesButton shinyDirButton shinySaveButton
upload_data_ui <- function(id) {

  ns <- shiny::NS(id)

  shiny::tagList(

    shiny::fluidRow(
      column(
        12,
        shinydashboard::box(
          title = "Upload Data File(s)",
          # footer = "Currently Supported File Types / Extensions: CSV, XLSX, XLS, TXT, PDF, Rdata, RDS",
          width = 12,
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          shiny::fluidRow(
            shiny::column(
              12,
              shinyFiles::shinyFilesButton(
                id = ns("upload_file"),
                label = "Upload by File",
                title = "Select File(s) for Upload:",
                multiple = TRUE,
                buttonType = "primary",
                icon = shiny::icon(
                  "file"
                )
              ),
              shinyFiles::shinyDirButton(
                id = ns("upload_folder"),
                label = "Upload by Folder",
                title = "Select a Folder for Upload:",
                buttonType = "primary",
                icon = shiny::icon(
                  "folder-open"
                )
              ),
              shinyFiles::shinySaveButton(
                id = ns("save_file"),
                label = "Save to File",
                title = "Select a File to Save To:",
                buttonType = "primary",
                icon = shiny::icon(
                  "save"
                )
              )
            )
          )
        )
      )
    ),
    fluidRow(
      column(
        12,
        shinydashboard::box(
          title = "Data Files Table:",
          width = 12,
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          shiny::fluidRow(
            shiny::column(
              12,
              div(
                style = "display:inline-block",
                div(
                  style = "float:right",
                  shinyFiles::shinyFilesButton(
                    id = ns("upload_file_2"),
                    label = "Upload by File",
                    title = "Select File(s) for Upload:",
                    multiple = TRUE,
                    buttonType = "primary",
                    icon = shiny::icon(
                      "file"
                    )
                  )
                ),
                DT::DTOutput(
                  ns("files_table")
                )
              )
            )
          )
        )
      )
    )
  )

}

#' Upload Data Module - Server
#'
#' @param input shiny input
#' @param output shiny output
#' @param session shiny session
#'
#' @return list of uploaded files and data
#' @export
#'
#' @examples
#' \dontrun{
#' shiny::callModule(upload_data, "data")
#' }
#' @importFrom dplyr transmute row_number
#' @importFrom DT renderDT datatable dataTableProxy coerceValue replaceData
#' @importFrom fs path_package path_home path path_ext
#' @importFrom htmlwidgets JS
#' @importFrom purrr map map_dbl
#' @importFrom rio import
#' @importFrom shiny reactive req validate need reactiveValues observe
#' @importFrom shinyFiles getVolumes shinyFileChoose shinyDirChoose shinyFileSave parseFilePaths parseDirPath parseSavePath
#' @importFrom tibble tibble
upload_data <- function(input, output, session) {

  # namespace
  ns <- session$ns

  # volumes for shinyFiles inputs
  volumes <- c(
    'Demo Data' = fs::path_package("owEDA", "extdata"),
    'Home' = fs::path_home(),
    'Documents' = fs::path(fs::path_home(), "Documents"),
    shinyFiles::getVolumes()()
  )

  # observers for each button
  shinyFiles::shinyFileChoose(input, "upload_file", session = session, roots = volumes)
  shinyFiles::shinyDirChoose(input, "upload_folder", roots = volumes)
  shinyFiles::shinyFileSave(input, "save_file", roots = volumes)

  # parse selected files
  selected_files <- shiny::reactive({
    shiny::req(input$upload_file)
    shinyFiles::parseFilePaths(volumes, input$upload_file)
  })

  shiny::observe({
    msg <- base::sprintf("File %s was uploaded", selected_files()$name)
    cat(msg, "\n")
  })

  # parse selected folder
  selected_folder_files <- shiny::reactive({
    shiny::req(input$upload_folder)
    shinyFiles::parseDirPath(volumes, input$upload_folder) %>%
      list.files(full.names = TRUE)
  })

  shiny::observe({
    msg <- base::sprintf("Folder %s was uploaded", selected_folder_files())
    cat(msg, "\n")
    # print(selected_folder_files())
  })

  # parse save file
  selected_save_file <- shiny::reactive({
    shiny::req(input$save_file)
    shinyFiles::parseSavePath(volumes, input$save_file)
  })

  # merge folder files with selected files
  all_selected_files_rv <- shiny::reactiveValues(
    files = NULL,
    data = NULL
  )

  observe({
    if (nrow(selected_files()) > 0 && length(selected_folder_files()) > 0) {
      hold <- selected_files() %>%
        dplyr::pull(datapath)
      out <- c(hold, selected_folder_files())
    } else if (nrow(selected_files()) > 0) {
      out <- selected_files() %>%
        dplyr::pull(datapath)
    } else {
      out <- selected_folder_files()
    }

    all_selected_files_rv$files <- out

  })

  shiny::observe({
    print(all_selected_files_rv$files)
  })

  # load data into a list
  data_list <- shiny::reactive({
    shiny::req(all_selected_files_rv$files)
    purrr::map(all_selected_files_rv$files,
               rio::import,
               setclass = "tibble")
  })

  observeEvent(data_list(), {

    all_selected_files_rv$data <- data_list()

  })


  # extract dimensions of data's (i.e. rows, cols, # vars)
  data_dims <- shiny::reactive({
    shiny::req(data_list())
    num_rows <- purrr::map_dbl(data_list(), nrow)
    num_cols <- purrr::map_dbl(data_list(), ncol)
    list(rows = num_rows, cols = num_cols)
  })

  # create a reactive data frame for all selected files' meta-data
  selected_files_metadata <- shiny::reactive({
    shiny::req(all_selected_files_rv$files, data_list(), data_dims())
    purrr::map_dfr(all_selected_files_rv$files, fs::file_info, .id = "index") %>%
      dplyr::transmute(
        index = index,
        upload_date_time = Sys.time(),
        name = fs::path_ext_remove(basename(path)),
        desc = "Provide a brief description here..",
        file = basename(path),
        path = dirname(path),
        size = paste0(prettyNum(size, big.mark = ",", digits = 0, format = "d"), " Bytes"),
        type = fs::path_ext(path),
        num_rows = data_dims()[["rows"]],
        num_cols = data_dims()[["cols"]],
        mod_time = modification_time,
        birth_time = birth_time,
        access_time = access_time,
        change_time = change_time
      )
  })

  shiny::observe({
    print(selected_files_metadata())
  })

  # output DT
  output$files_table <- DT::renderDT({
    shiny::req(selected_files_metadata())

    js <- c(
      "table.on('key', function(e, datatable, key, cell, originalEvent){",
      "  var targetName = originalEvent.target.localName;",
      "  if(key == 13 && targetName == 'body'){",
      "    $(cell.node()).trigger('dblclick.dt');",
      "  }",
      "});",
      "table.on('keydown', function(e){",
      "  var keys = [9,13,37,38,39,40];",
      "  if(e.target.localName == 'input' && keys.indexOf(e.keyCode) > -1){",
      "    $(e.target).trigger('blur');",
      "  }",
      "});",
      "table.on('key-focus', function(e, datatable, cell, originalEvent){",
      "  var targetName = originalEvent.target.localName;",
      "  var type = originalEvent.type;",
      "  if(type == 'keydown' && targetName == 'input'){",
      "    if([9,37,38,39,40].indexOf(originalEvent.keyCode) > -1){",
      "      $(cell.node()).trigger('dblclick.dt');",
      "    }",
      "  }",
      "});"
    )

    DT::datatable(
      selected_files_metadata(),
      options = list(
        keys = TRUE,
        dom = "Bt",
        buttons = list(
          'copy', 'print',
          list(
            extend = 'collection',
            buttons = c('csv', 'excel', 'pdf'),
            text = 'Download'
          )
        ),
        paging = FALSE,
        searching = FALSE,
        # initComplete = table_hf,
        columnDefs = list(
          list(
            className = "dt-center",
            targets = c(0:13)
          )
        )
      ),
      class = "stripe cell-border",
      # callback = htmlwidgets::JS(js),
      rownames = FALSE,
      colnames = c(
        "Index",
        "Uploaded On",
        "Dataset Name",
        "Dataset Description",
        "File",
        "Path",
        "Size",
        "Type",
        "# Rows",
        "# Columns",
        "Last Modified",
        "Birth",
        "Last Accessed",
        "Last Changed"
      ),
      # container = sketch,
      caption = paste0("Sumary of Uploaded Data Files:"),
      # filter = "top",
      style = "bootstrap",
      # elementId = ns("files_table"),
      fillContainer = TRUE,
      autoHideNavigation = TRUE,
      # selection = "single",
      extensions = c("Buttons", "KeyTable"),
      # plugins = ,
      editable = list(
        target = 'row', disable = list(columns = c(0:1, 4:13))
      )
    )

  }) # , server = FALSE)

  # proxy <- DT::dataTableProxy("files_table", session = globalSession)

  observe(str(input$files_table_cell_edit))

  # observeEvent(input$files_table_cell_edit, {
  #
  #   rv[["table"]] <- editData(rv[["table"]],
  #                             input$files_table_cell_edit,
  #                             "files_table",
  #                             rownames = FALSE)
  #
  #   # info <- input$files_table_cell_info
  #   #
  #   # r <- info$row
  #   # c <- info$col + 1L
  #   # v <- info$value
  #   #
  #   # rv[["table"]][r, c] <- DT::coerceValue(v, rv[["table"]][r, c])
  #   #
  #   # DT::replaceData(proxy, rv[["table"]], resetPaging = FALSE, rownames = FALSE)
  #
  #   # files_data_rv$table <- DT::editData(
  #   #   files_data$table,
  #   #   input$files_table_cell_edit,
  #   #   "files_table",
  #   #   rownames = FALSE
  #   # )
  #
  # })


  # load data
  # files_data <- shiny::reactive({
  #   shiny::req(selected_files())
  #   purrr::map(selected_files()$datapath,
  #              rio::import,
  #              setclass = "tibble")
  # })
  #
  # # extract # rows
  # num_rows <- shiny::reactive({
  #   shiny::req(files_data())
  #   purrr::map_dbl(files_data(), nrow)
  # })
  #
  # # extract # cols
  # num_cols <- shiny::reactive({
  #   shiny::req(files_data())
  #   purrr::map_dbl(files_data(), ncol)
  # })

  # create a reactive data frame for selected files
  # data_files_table <- shiny::reactive({
  #   shiny::req(selected_files(), files_data(), num_rows(), num_cols()) #selected_folder())
  #
  #   # files_table_combined <- dplyr::bind_rows(
  #   #   selected_files(), selected_folder()
  #   # ) %>%
  #   selected_files() %>%
  #     dplyr::transmute(
  #       index = dplyr::row_number(),
  #       file = name,
  #       path = datapath,
  #       size = size,
  #       num_rows = num_rows(),
  #       num_cols = num_cols(),
  #       type = fs::path_ext(file),
  #       description = NA_character_
  #     )
  #
  #   # rv[["table"]] <- hold
  #
  # })

  # val <- reactiveValues(data = NULL)
  #
  # observe({
  #   shiny::isolate(data_files_table())
  #   val$data <<- data_files_table()
  # })

  # upload files, add to reactiveValues, output table:
  # output$files_table <- DT::renderDT({
  #   shiny::req(nrow(data_files_table()) > 0)
  #
  #   js <- c(
  #     "table.on('key', function(e, datatable, key, cell, originalEvent){",
  #     "  var targetName = originalEvent.target.localName;",
  #     "  if(key == 13 && targetName == 'body'){",
  #     "    $(cell.node()).trigger('dblclick.dt');",
  #     "  }",
  #     "});",
  #     "table.on('keydown', function(e){",
  #     "  var keys = [9,13,37,38,39,40];",
  #     "  if(e.target.localName == 'input' && keys.indexOf(e.keyCode) > -1){",
  #     "    $(e.target).trigger('blur');",
  #     "  }",
  #     "});",
  #     "table.on('key-focus', function(e, datatable, cell, originalEvent){",
  #     "  var targetName = originalEvent.target.localName;",
  #     "  var type = originalEvent.type;",
  #     "  if(type == 'keydown' && targetName == 'input'){",
  #     "    if([9,37,38,39,40].indexOf(originalEvent.keyCode) > -1){",
  #     "      $(cell.node()).trigger('dblclick.dt');",
  #     "    }",
  #     "  }",
  #     "});"
  #   )
  #
  #   DT::datatable(
  #     data_files_table(),
  #     # rv[["table"]],
  #     options = list(
  #       keys = TRUE,
  #       dom = "Bt",
  #       buttons = list(
  #         'copy', 'print',
  #         list(
  #           extend = 'collection',
  #           buttons = c('csv', 'excel', 'pdf'),
  #           text = 'Download'
  #         )
  #       ),
  #       paging = FALSE,
  #       searching = FALSE,
  #       # initComplete = table_hf,
  #       columnDefs = list(
  #         list(
  #           className = "dt-center",
  #           targets = c(0:7)
  #         )
  #       )
  #     ),
  #     class = "stripe cell-border",
  #     # callback = htmlwidgets::JS(js),
  #     rownames = FALSE,
  #     colnames = c(
  #       "Index",
  #       "File",
  #       "Path",
  #       "Size",
  #       "# Rows",
  #       "# Columns",
  #       "Type",
  #       "Description"
  #     ),
  #     # container = sketch,
  #     caption = paste0("Sumary Table of Selected Files for Upload:"),
  #     # filter = "top",
  #     style = "bootstrap",
  #     # elementId = ns("files_table"),
  #     fillContainer = TRUE,
  #     autoHideNavigation = TRUE,
  #     # selection = "single",
  #     extensions = c("Buttons", "KeyTable"),
  #     # plugins = ,
  #     editable = list(
  #       target = 'row', disable = list(columns = c(0:6))
  #     )
  #   )
  #
  # }) # , server = FALSE)
  #
  # # proxy <- DT::dataTableProxy("files_table", session = globalSession)
  #
  # observe(str(input$files_table_cell_edit))
  #
  # # observeEvent(input$files_table_cell_edit, {
  # #
  # #   rv[["table"]] <- editData(rv[["table"]],
  # #                             input$files_table_cell_edit,
  # #                             "files_table",
  # #                             rownames = FALSE)
  # #
  # #   # info <- input$files_table_cell_info
  # #   #
  # #   # r <- info$row
  # #   # c <- info$col + 1L
  # #   # v <- info$value
  # #   #
  # #   # rv[["table"]][r, c] <- DT::coerceValue(v, rv[["table"]][r, c])
  # #   #
  # #   # DT::replaceData(proxy, rv[["table"]], resetPaging = FALSE, rownames = FALSE)
  # #
  # #   # files_data_rv$table <- DT::editData(
  # #   #   files_data$table,
  # #   #   input$files_table_cell_edit,
  # #   #   "files_table",
  # #   #   rownames = FALSE
  # #   # )
  # #
  # # })
  #
  # shiny::observe({
  #   print(selected_files())
  # })


  # A tibble: 1 x 4
  # name        size type  datapath
  # <chr>      <dbl> <chr> <chr>
  #   1 mtcars.csv  1281 ""    C:/Users/jimmy.briggs/Documents/Projects/Development/R-Packages/owEDA/inst/extdata/mtcars.csv




}


