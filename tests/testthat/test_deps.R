context("dependencies")

vue_dep <- html_dependency_vue()
vue_dep_online <- html_dependency_vue(offline=FALSE)

test_that("html_dependency_vue() returns html_dependency", {
  expect_is(vue_dep, "html_dependency")
  expect_is(vue_dep_online, "html_dependency")
})

test_that("html_dependency_vue() src href is a valid url", {
  skip_if_not_installed("httr")
  is_valid_url <- function(u){
    !httr::http_error(u)
  }
  expect_true(is_valid_url(file.path(vue_dep_online$src$href,vue_dep$script)))
})

test_that("html_dependency_vue() src file is a valid file", {
  expect_true(file.exists(file.path(vue_dep$src$file,vue_dep$script)))
})


test_that("html_dpeendency_vue() on latest vue release", {
  skip_if_not_installed("github")

  expect_identical(
    sprintf("v%s",vue_dep$version),
    github::get.latest.release("vuejs","vue")$content$tag_name
  )
})

