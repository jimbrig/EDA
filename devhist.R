
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
