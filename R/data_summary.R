quick_data_summary <- function(data) {
  print(dfSummary(data, graph.magnif = 0.8),
        method = 'render',
        headings = FALSE,
        bootstrap.css = FALSE)
}
