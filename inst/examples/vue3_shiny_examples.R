if(interactive()) {

  library(shiny)
  library(vueR)

  ui <- tagList(
    tags$div(id="app-3",
      tags$p("v-if"="seen", "Now you see me")
    ),
    vue3Output('vue1')
  )

  server <- function(input, output, session) {
    output$vue1 <- renderVue3({
      vue3(
        list(
          el = '#app-3',
          data = list(seen = TRUE),
          mounted = htmlwidgets::JS("function() {var that = this; setInterval(function(){that.seen=!that.seen},1000);}"),
          watch = list(
            seen = htmlwidgets::JS("function() {Shiny.setInputValue('seen',this.seen)}")
          )
        )
      )
    })

    # show that Shiny input value is being updated
    observeEvent(input$seen, {print(input$seen)})
  }

  shinyApp(ui, server)

}
