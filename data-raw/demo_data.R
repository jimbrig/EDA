## code to prepare `demo_data` dataset goes here

dir.create("inst/extdata")

readr::write_csv(iris, "inst/extdata/iris.csv")
readr::write_csv(mtcars, "inst/extdata/mtcars.csv")

# usethis::use_data(demo_data, overwrite = TRUE)
