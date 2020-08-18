library(shiny)
library(htmltools)
library(ggplot2)
library(vueR)

ui <- tagList(
  tags$head(
    tags$link(href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900", rel="stylesheet"),
    tags$link(href="https://cdn.jsdelivr.net/npm/@mdi/font@5.x/css/materialdesignicons.min.css", rel="stylesheet"),
    tags$link(href="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.min.css", rel="stylesheet")
  ),
  tags$div(
    id = "app",
    HTML(
      sprintf("
        <v-app>
          <v-main>
            <v-container
              class='fill-height'
            >
              <v-row justify='center' align='center'>
                <v-dialog
                  v-model='dialog'
                  width='500'
                >
                <template v-slot:activator='{ on, attrs }'>
                  <v-btn
                    color='red lighten-2'
                    dark
                    v-bind='attrs'
                    v-on='on'
                  >
                    Create Plot
                  </v-btn>
                </template>
                  %s
                </v-dialog>
              </v-row>
            </v-container>
          </v-main>
        </v-app>
      ",
        plotOutput("plot")
      )
    )
  ),
  html_dependency_vue(),
  tags$script(src="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.js"),
  tags$script(HTML("
const app = new Vue({
  el: '#app',
  vuetify: new Vuetify(),
  data: {dialog: false},
  watch: {
    dialog: {
      handler: function(val) {
        if(val === true) {
          Vue.nextTick(() => {
            // force bind to bind plot
            if(!Shiny.shinyapp.$bindings.hasOwnProperty('plot')) {
              Shiny.bindAll($('.v-dialog'))
            }
            // or this seems to work as well without checking
            //   since Shiny ignores already bound
            // Shiny.bindAll($('.v-dialog'))
          })
        }
        Shiny.setInputValue('dialog', val)
      }
    }
  }
})

$(document).on('shiny:sessioninitialized', function() {
  Shiny.setInputValue('dialog', app.$data.dialog)
})
  "))
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    input$dialog
    if(input$dialog == TRUE) {
      # plot with random data
      ggplot(data = data.frame(x=1:20,y=runif(20)*10), aes(x=x, y=y)) +
        geom_line()
    } else {
      # empty ggplot
      ggplot() + geom_blank()
    }
  })
}

shinyApp(ui, server)
