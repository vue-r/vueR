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
          # vue 3 is more burdensome but robust requiring data as function
          #   if data is not a function then widget will auto-convert
          data = list(message = "Hello Vue3!")
          # data = htmlwidgets::JS("
          #   function() {return {message: 'Hello Vue3!'}}
          # ")
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
      vue3(
        list(
          el = "#app-2",
          # vue 3 is more burdensome but robust requiring data as function
          #   if data is not a function then widget will auto-convert
          data = htmlwidgets::JS("
            function() {
              return {message: 'You loaded this page on ' + new Date()}
            }
          ")
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
      vue3(
        list(
          el = '#app-3',
          data = list(seen = TRUE),
          # data = htmlwidgets::JS("function() {return {seen: true}}"),
          mounted = htmlwidgets::JS("function() {var that = this; setInterval(function(){that.seen=!that.seen},1000);}")
        )
      )
    )
  )

}
