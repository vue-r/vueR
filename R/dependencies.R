#' Dependencies for Vue
#'
#' @param offline \code{logical} to use local file dependencies.  If \code{FALSE},
#'          then the dependencies use cdn as its \code{src}.
#' @param minified \code{logical} to use minified (production) version.  Use
#'          \code{minified = FALSE} for debugging or working with Vue devtools.
#'
#' @return \code{\link[htmltools]{htmlDependency}}
#' @importFrom htmltools htmlDependency
#' @family dependencies
#' @export
#'
#' @examples
#' if(interactive()){
#'
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
#' }
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


#' Dependencies for 'Vue3'
#'
#' @param offline \code{logical} to use local file dependencies.  If \code{FALSE},
#'          then the dependencies use cdn as its \code{src}.
#' @param minified \code{logical} to use minified (production) version.  Use
#'          \code{minified = FALSE} for debugging or working with Vue devtools.
#'
#' @return \code{\link[htmltools]{htmlDependency}}
#' @importFrom htmltools htmlDependency
#' @family dependencies
#' @export
#'
#' @examples
#' if(interactive()){
#'
#' library(vueR)
#' library(htmltools)
#'
#' browsable(
#'   tagList(
#'     tags$div(id="app","{{message}}"),
#'     tags$script(
#'     "
#'     var app = {
#'       data: function() {
#'         return {
#'           message: 'Hello Vue!'
#'         }
#'       }
#'     };
#'
#'     Vue.createApp(app).mount('#app');
#'     "
#'     ),
#'     html_dependency_vue3()
#'   )
#' )
#' }
html_dependency_vue3 <- function(offline=TRUE, minified=TRUE){
  hd <- htmltools::htmlDependency(
    name = "vue",
    version = vue3_version(),
    src = system.file("www/vue3/dist",package="vueR"),
    script = "vue.global.prod.js"
  )

  if(!minified) {
    hd$script <- "vue.global.js"
  }

  if(!offline) {
    hd$src <- list(href=sprintf(
      "https://unpkg.com/vue@%s/dist/",
      vue3_version()
    ))
  }

  hd
}
