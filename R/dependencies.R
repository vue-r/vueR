#' Dependencies for Vue
#'
#' @param offline \code{logical} to use local file dependencies.  If \code{FALSE},
#'          then the dependencies use cdn as its \code{src}.
#' @param minified \code{logical} to use minified (production) version.  Use
#'          \code{minified = FALSE} for debugging or working with Vue devtools.
#'
#' @return \code{\link[htmltools]{htmlDependency}}
#' @importFrom htmltools htmlDependency
#' @export
#'
#' @examples
#' library(vueR)
#' library(htmltools)
#'
#' attachDependencies(
#'   tagList(
#'     tags$div(id="app","{{message}}"),
#'     tags$script(
#'     "
#'     var app = new Vue({
#'       el: '#app',
#'       data: {
#'         message: 'Hello Vue!'
#'       }
#'     });
#'     "
#'     )
#'   ),
#'   html_dependency_vue()
#' )
html_dependency_vue <- function(offline=TRUE, minified=TRUE){
  hd <- htmltools::htmlDependency(
    name = "vue",
    version = vue_version(),
    src = system.file("www/vue/dist",package="vueR"),
    script = "vue.min.js"
  )

  if(!minified) {
    hd$script <- "vue.js"
  }

  if(!offline) {
    hd$src <- list(href=sprintf(
      "https://unpkg.com/vue@%s/dist/",
      vue_version()
    ))
  }

  hd
}
