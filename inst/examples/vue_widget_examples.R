\dontrun{
library(vueR)
library(htmltools)

# recreate Hello Vue! example
browsable(
  tagList(
    tags$div(id="app", "{{message}}"),
    vue(
      list(
        el = "#app",
        data = list(
          message = "Hello Vue!"
        )
      )
    )
  )
)

# app2 from Vue.js introduction
browsable(
  tagList(
    tags$div(id="app-2",
      tags$span(
        "v-bind:title" = "message",
        "Hover your mouse over me for a few seconds to see my dynamically bound title!"
      )
    ),
    vue(
      list(
        el = "#app-2",
        data = list(
          message =  htmlwidgets::JS(
            "'You loaded this page on ' + new Date()"
          )
        )
      )
    )
  )
)
}
