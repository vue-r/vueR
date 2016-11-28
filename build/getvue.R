# use the very nice rgithub
# devtools::install_github("cscheid/rgithub")

get_vue_latest <- function(){
  gsub(
    x=github::get.latest.release("vuejs", "vue")$content$tag_name,
    pattern="v",
    replacement=""
  )
}


# get newest vue
download.file(
  url=sprintf(
    "https://unpkg.com/vue@%s/dist/vue.min.js",
    get_vue_latest()
  ),
  destfile="./inst/www/vue/dist/vue.min.js"
)

# write function with newest version
#  for use when creating dependencies
cat(
  sprintf(
    "#'@keywords internal\nvue_version <- function(){'%s'}\n",
    get_vue_latest()
  ),
  file = "./R/meta.R"
)
