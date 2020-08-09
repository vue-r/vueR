library(htmltools)
library(vueR)
library(shiny)

# experiment with standalone vue reactivity in bare page
#   reference:
#     https://vuejs.org/v2/guide/reactivity.html
#     https://dev.to/jinjiang/understanding-reactivity-in-vue-3-0-1jni
browsable(
  tagList(
    tags$head(
      tags$script(src = "https://unpkg.com/@vue/reactivity@3.0.0-rc.5/dist/reactivity.global.js"),
    ),
    tags$p("we should see a number starting at 0 and increasing by one each second"),
    tags$div(id = "reporter"),
    tags$script(HTML(
"
let data = {x: 0};
let data_reactive = VueReactivity.reactive(data)  // could also use ref for primitive value
console.log(data, data_reactive)

VueReactivity.effect(() => {
  console.log(data_reactive.x)
  document.getElementById('reporter').innerText = data_reactive.x
})
setInterval(function() {data_reactive.x++}, 1000)

"
    ))
  )
)


# experiment with Shiny inputValues and vue-next
#   reference:
#     https://vuejs.org/v2/guide/reactivity.html
#     https://dev.to/jinjiang/understanding-reactivity-in-vue-3-0-1jni
ui <- tagList(
  tags$head(
    tags$script(src = "https://unpkg.com/@vue/reactivity@3.0.0-rc.5/dist/reactivity.global.js"),
  ),
  tags$div(
    tags$h3("Increment with JavaScript"),
    tags$span("Shiny: "),
    textOutput("reporterR", inline = TRUE),
    tags$span("JavaScript: "),
    tags$span(
      id = "reporterJS"
    )
  ),
  tags$div(
    tags$h3("Increment with R/Shiny"),
    tags$span("Shiny (used numeric input for convenience): "),
    numericInput(inputId = 'x2', label = "", value = 0),
    tags$span("JavaScript: "),
    tags$span(
      id = "reporterJS2"
    )
  ),
  tags$script(HTML(
"
$(document).on('shiny:connected', function() {

  // once Shiny connected replace Shiny inputValues with reactive Shiny inputValues
  Shiny.shinyapp.$inputValues = VueReactivity.reactive(Shiny.shinyapp.$inputValues)

  // do our counter using Shiny.setInputValue from JavaScript
  Shiny.setInputValue('x', 0) // initialize with 0
  VueReactivity.effect(() => {
    console.log('javascript', Shiny.shinyapp.$inputValues.x)
    document.getElementById('reporterJS').innerText = Shiny.shinyapp.$inputValues.x
  })
  setInterval(
    function() {
      Shiny.setInputValue('x', Shiny.shinyapp.$inputValues.x + 1) //increment by 1
    },
    1000
  )

  // react to counter implemented in Shiny
  VueReactivity.effect(() => {
    console.log('shiny', Shiny.shinyapp.$inputValues['x2:shiny.number'])
    document.getElementById('reporterJS2').innerText = Shiny.shinyapp.$inputValues['x2:shiny.number']
  })

})
"
  ))
)

server <- function(input, output, session) {
  x2 <- 0  # use this for state of Shiny counter
  output$reporterR <- renderText({input$x})

  observe({
    invalidateLater(1000, session = session)
    x2 <<- x2 + 1 # <<- or assign required to update parent
    updateNumericInput(inputId = "x2", value = x2, session = session)
  })
}

shinyApp(
  ui = ui,
  server = server,
  options = list(launch.browser = rstudioapi::viewer)
)
