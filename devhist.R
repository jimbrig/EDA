
#  ------------------------------------------------------------------------
#
# Title : owEDA Development History Code
#    By : Jimmy Briggs
#  Date : 2019-11-12
#
#  ------------------------------------------------------------------------

# Library Development Packages --------------------------------------------
if (!require(pacman)) install.packages("pacman")
pacman::p_load(
  usethis,
  devtools,
  desc
)

# Initialize Package ------------------------------------------------------

# setwd("~/Work/Oliver-Wyman/Packages")
usethis::create_package("owEDA")

# ignore this script from build
usethis::use_build_ignore("devhist.R")

# create and ignore admin folder
dir.create("admin")
usethis::use_build_ignore("admin")
usethis::use_git_ignore(c("*", "!.gitignore"), "admin")

# setup namespace and roxygen
usethis::use_namespace()
usethis::use_roxygen_md()
devtools::document()

# setup prelim .R files
usethis::use_package_doc()
usethis::use_tibble() # @return a [tibble][tibble::tibble-package]
usethis::use_pipe()
usethis::use_testthat()
devtools::document()

# setup git
usethis::use_git()
usethis::use_github(private = TRUE)

# Edit DESCRIPTION --------------------------------------------------------
desc::desc_set(Title = "Oliver Wyman Exploratory Data Analysis Package",
               Description = "Interactive EDA.")

# add authors
desc::desc_add_author(given = "Scott",
                      family = "Sobel",
                      role = "ctb",
                      email = "scott.sobel@oliverwyman.com")

desc::desc_add_author(given = "Oliver Wyman Actuarial Consulting, Inc.",
                      role = "fnd")

# license
usethis::use_mit_license(name = "Oliver Wyman Actuarial Consulting, Inc.")

desc::desc_normalize()

# document, check, build, install
devtools::document()
devtools::check()
devtools::build()
devtools::install()

# Documentation -----------------------------------------------------------
usethis::use_readme_rmd()
usethis::use_logo("../../../../Pictures/OWAC/ow.jpg")
usethis::use_lifecycle_badge("Experimental")
usethis::use_badge(
  "Project Status: WIP",
  href = "http://www.repostatus.org/#wip",
  src = "https://www.repostatus.org/badges/latest/wip.svg"
)
knitr::knit("README.Rmd")

# setup lifecycle
usethis::use_lifecycle()
# ● Refer to functions with `lifecycle::fun()`
# ● Add badges inshiny::iconumentation topics by inserting this macro:
# \lifecycle{experimental}
#shinydashboard::menuSubItem
# You can choose from the following lifecycle stages:
#
# - experimental
# - maturing
# - stable
# - qushinydashboard::menuItemg
# - soft-deprecated
# - deprecated
# - defunct
# - archived

usethis::use_rmarkdown_template("Data Validation Report")

dir.create("inst/app")

golem::add_ui_server_files(pkg = getwd())
golem::add_css_file("styles", getwd())
golem::add_js_file("custom", getwd())

golem::use_recommended_deps() # DT, glue, golem, shiny
golem::use_recommended_tests()

golem::detach_all_attached()
golem::document_and_reload()

# initialize R functions
usethis::use_r("utils")
usethis::use_r("run_app")
usethis::use_r("app_ui")
usethis::use_r("app_server")
# usethis::use_r("ui_elements")
usethis::use_r("ui_helpers")
usethis::use_r("ui_header")
usethis::use_r("ui_sidebar")
usethis::use_r("ui_body")
usethis::use_r("ui_rightbar")
usethis::use_r("contact_dropdown")
usethis::use_r("header_buttons_module")
usethis::use_r("upload_data_module")
usethis::use_r("tables")

attachment::att_to_description(

  extra.suggests = c("golem",
                     "testthat",
                     "pkgload",
                     "usethis",
                     "attachment")
)

attachment::create_dependencies_file(to = "inst/docs/dependencies.R")

usethis::use_data_raw("demo_data")


usethis::use_package("shiny")
usethis::use_package("shinydashboard")
usethis::use_package("shinyjs")
usethis::use_package("shinyWidgets")
usethis::use_package("shinyFiles")
usethis::use_package("DT")
usethis::use_package("rhandsontable")
usethis::use_package("highcharter")
usethis::use_package("htmltools")
usethis::use_package("attempt")
usethis::use_package("processx")
usethis::use_package("golem", type = "Suggests")
usethis::use_package("shinyEffects", type = "Suggests")
usethis::use_package("rhandsontable")
# usethis::use_package("darkmode")


ghactions::use_ghactions(workflow = ghactions::website())
