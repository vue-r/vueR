# use the very nice rgithub; still works but abandoned
# remotes::install_github("cscheid/rgithub")

get_vue_latest <- function(){
  gsub(
    x=github::get.latest.release("vuejs", "vue")$content$tag_name,
    pattern="v",
    replacement=""
  )
}

get_vue3_latest <- function(){
  gsub(
    x=github::get.latest.release("vuejs", "core")$content$tag_name,
    pattern="v",
    replacement=""
  )
}


# get newest vue2
download.file(
  url=sprintf(
    "https://unpkg.com/vue@%s/dist/vue.min.js",
    get_vue_latest()
  ),
  destfile="./inst/www/vue/dist/vue.min.js"
)

download.file(
  url=sprintf(
    "https://unpkg.com/vue@%s/dist/vue.js",
    get_vue_latest()
  ),
  destfile="./inst/www/vue/dist/vue.js"
)

# get newest vue3
download.file(
  url=sprintf(
    "https://unpkg.com/vue@%s/dist/vue.global.prod.js",
    get_vue3_latest()
  ),
  destfile="./inst/www/vue3/dist/vue.global.prod.js"
)

download.file(
  url=sprintf(
    "https://unpkg.com/vue@%s/dist/vue.global.js",
    get_vue3_latest()
  ),
  destfile="./inst/www/vue3/dist/vue.global.js"
)

# write function with newest version
#  for use when creating dependencies
cat(
  sprintf(
    "#'@keywords internal\nvue_version <- function(){'%s'}\n#'@keywords internal\nvue3_version <- function(){'%s'}\n",
    get_vue_latest(),
    get_vue3_latest()
  ),
  file = "./R/meta.R"
)
