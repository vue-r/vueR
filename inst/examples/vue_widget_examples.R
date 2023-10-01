if(interactive()) {

  library(vueR)
  library(htmltools)

  # recreate Hello Vue! example
  browsable(
    tagList(
      tags$div(id="app", "{{message}}"),
      vue3(
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

  # app3 from Vue.js introduction
  #  with a setInterval to toggle seen true and false
  browsable(
    tagList(
      tags$div(id="app-3",
        tags$p("v-if"="seen", "Now you see me")
      ),
      htmlwidgets::onRender(
        vue(
          list(
            el = '#app-3',
            data = list(
              seen = TRUE
            )
          )
        ),
        "
  function(el,x){
    var that = this;
    setInterval(function(){that.instance.seen=!that.instance.seen},1000);
  }
        "
      )
    )
  )

}
