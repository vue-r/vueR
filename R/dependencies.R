#' Dependencies for Vue
#'
#' @param offline \code{logical} to use local file dependencies.  If \code{FALSE},
#'          then the dependencies use cdn as its \code{src}.
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
#'   tags$script(
#'   "
#'
#'   "
#'   ),
#'   html_dependency_vue()
#' )
html_dependency_vue <- function(offline=TRUE){
  hd <- htmltools::htmlDependency(
    name = "vue",
    version = vue_version(),
    src = system.file("www/vue/dist",package="vueR"),
    script = c("vue.min.js")
  )

  if(!offline) {
    hd$src <- list(href=sprintf(
      "//cdnjs.cloudflare.com/ajax/libs/vue/%s",
      vue_version()
    ))
  }

  hd
}
