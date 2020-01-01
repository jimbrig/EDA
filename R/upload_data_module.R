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

  shiny::fluidRow(
    shiny::column(
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
            ) %>% shinyjs::disabled(),
            shinyFiles::shinySaveButton(
              id = ns("save_file"),
              label = "Save to File",
              title = "Select a File to Save To:",
              buttonType = "primary",
              icon = shiny::icon(
                "save"
              )
            ) %>% shinyjs::disabled()
          )
        )
      ),

      shinydashboard::box(
        title = "Data Files Table:",
        width = 12,
        status = "primary",
        solidHeader = TRUE,
        collapsible = TRUE,
        shiny::fluidRow(
          shiny::column(
            12,
            DT::DTOutput(
              ns("files_table")
            )
          )
        )
      ),

      shinydashboard::box(
        title = "Preview Uploaded Datasets:",
        width = 12,
        status = "primary",
        solidHeader = TRUE,
        collapsible = TRUE,
        shiny::fluidRow(
          shiny::column(
            12,
            uiOutput(ns("data_picker")),
            DT::DTOutput(
              ns("data_table"),
              width = "100%"
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
#' @importFrom purrr map map_dbl set_names
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
  # shinyFiles::shinyDirChoose(input, "upload_folder", roots = volumes)
  # shinyFiles::shinyFileSave(input, "save_file", roots = volumes)

  # parse selected files
  selected_files <- shiny::reactive({
    shiny::req(input$upload_file)
    shinyFiles::parseFilePaths(volumes, input$upload_file)
  })

  shiny::observe({
    req(selected_files())
    print(selected_files())
  })

  # load data
  selected_files_data <- reactive({
    shiny::req(selected_files())

    paths <- selected_files() %>% dplyr::pull(datapath)

    purrr::map(
      paths,
      rio::import, # TODO: customize import for excel tabs, etc.
      setclass = "tibble"
    ) %>%
      purrr::set_names(fs::path_ext_remove(basename(paths)))
  })

  # extract dims
  selected_files_data_dims <- reactive({
    req(selected_files_data())

    data_list <- selected_files_data()

    num_rows <- purrr::map_dbl(data_list, nrow)
    num_cols <- purrr::map_dbl(data_list, ncol)

    list(rows = num_rows, cols = num_cols)

  })

  # pull details on files
  selected_files_info <- reactive({

    shiny::req(selected_files(), selected_files_data_dims())

    selected_files() %>%
      dplyr::transmute(
        index = dplyr::row_number(),
        file = name,
        path = datapath,
        type = fs::path_ext(name),
        num_rows = selected_files_data_dims()$rows,
        num_cols = selected_files_data_dims()$cols,
        last_modified = as.Date.character(file.mtime(path)),
        size = paste0(prettyNum(size, big.mark = ",", digits = 0, format = "d"), " Bytes"),
        custom_name = fs::path_ext_remove(name),
        custom_desc = "Brief Description..."
      )
  })

  shiny::observe({
    req(selected_files_info())
    print(selected_files_info())
  })

  # output DT
  output$files_table <- DT::renderDT({
    shiny::req(selected_files_info())

    hold <- selected_files_info()

    DT::datatable(
      hold,
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
        columnDefs = list(
          list(
            className = "dt-center",
            targets = c(0:9)
          )
        )
      ),
      class = "stripe cell-border",
      rownames = FALSE,
      colnames = c(
        "Index",
        "File",
        "Path",
        "Type",
        "# Rows",
        "# Columns",
        "Last Modified",
        "Size",
        "Custom Name",
        "Custom Description"
      ),
      caption = paste0("Sumary of Uploaded Data Files:"),
      style = "bootstrap",
      extensions = c("Buttons", "KeyTable"),
      editable = list(
        target = 'row', disable = list(columns = c(0:7))
      )
    )

  })

  observe(str(input$files_table_cell_edit))

  output$data_picker <- renderUI({
    req(selected_files_data())

    shinyWidgets::pickerInput(
      session$ns("data_picker"),
      label = "Select Data to Display Below:",
      choices = names(selected_files_data()),
      selected = names(selected_files_data())[1],
      width = "auto",
      options = shinyWidgets::pickerOptions(
        style = "primary"
      ),
      multiple = FALSE
    )

  })

  output$data_table <- DT::renderDT({

    req(selected_files_data(), input$data_picker)

    hold <- selected_files_data()[[match(input$data_picker, names(selected_files_data()))]]

    DT::datatable(
      hold,
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
        ) #,
        # paging = FALSE,
        # searching = FALSE,
        # columnDefs = list(
        #   list(
        #     className = "dt-center",
        #     targets = c(0:9)
        #   )
        # )
      ),
      class = "stripe cell-border",
      rownames = FALSE,
      # colnames = c(
      #   "Index",
      #   "File",
      #   "Path",
      #   "Type",
      #   "# Rows",
      #   "# Columns",
      #   "Last Modified",
      #   "Size",
      #   "Custom Name",
      #   "Custom Description"
      # ),
      # caption = paste0("Sumary of Uploaded Data Files:"),
      style = "bootstrap",
      extensions = "Buttons" #, "KeyTable"),
      # editable = list(
      #   target = 'row', disable = list(columns = c(0:7))
      # )
    )
  })

}


