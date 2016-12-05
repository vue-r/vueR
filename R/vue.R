#' 'Vue.js' 'htmlwidget'
#'
#' Use 'Vue.js' with the convenience and flexibility of 'htmlwidgets'.
#' \code{vue} is a little different from other 'htmlwidgets' though
#' since it requires specification of the HTML tags/elements separately.
#'
#' @param app \code{list} with \code{el} and \code{data} and other pieces
#'          of a 'Vue.js' app
#' @param width,height any valid \code{CSS} size unit, but in reality
#'          this will not currently have any impact
#' @param elementId \code{character} id of the htmlwidget container
#'          element
#' @param minified \code{logical} to indicate minified (\code{minified=TRUE}) or
#'          non-minified (\code{minified=FALSE}) Vue.js
#'
#' @import htmlwidgets
#'
#' @export
#' @example ./inst/examples/vue_widget_examples.R
#' @return vue htmlwidget

vue <- function(
  app = list(),
  width = NULL, height = NULL, elementId = NULL,
  minified = TRUE
) {

  # forward options using x
  x = app

  # create widget
  hw <- htmlwidgets::createWidget(
    name = 'vue',
    x,
    width = width,
    height = height,
    package = 'vueR',
    elementId = elementId
  )

  hw$dependencies <- list(
    html_dependency_vue(offline=TRUE, minified=minified)
  )

  hw
}

#' Shiny bindings for vue
#'
#' Output and render functions for using vue within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a vue
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name vue-shiny
#'
#' @export
vueOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'vue', width, height, package = 'vueR')
}

#' @rdname vue-shiny
#' @export
renderVue <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, vueOutput, env, quoted = TRUE)
}
