# quick example of Vuex and Shiny
# reference: https://vuex.vuejs.org/guide/

library(htmltools)
library(shiny)

vuex <- tags$script(src="https://unpkg.com/vuex@2.5.0/dist/vuex.js")

ui <- tagList(
  html_dependency_vue(offline = FALSE, minified = FALSE),
  tags$head(vuex),
  tags$h1("Shiny with Vue and Vuex"),
  tags$h3('Vue App'),
  tags$div(
    id = "app",
    tags$button(`@click`="increment", "+"),
    tags$button(`@click`="decrement", "-"),
    "{{ count }}"
  ),
  tags$h3("Shiny controls"),
  # add Shiny buttons to demonstrate Shiny to update Vuex state
  actionButton(inputId = "btnIncrement", label="+"),
  actionButton(inputId = "btnDecrement", label="-"),
  tags$script(HTML(
"
// first example in Vuex documentation
Vue.use(Vuex)

// make sure to call Vue.use(Vuex) if using a module system

const store = new Vuex.Store({
  state: {
    count: 0
  },
  mutations: {
  	increment: state => state.count++,
    decrement: state => state.count--
  }
})

const app = new Vue({
  el: '#app',
  computed: {
    count () {
	    return store.state.count
    }
  },
  methods: {
    increment () {
      store.commit('increment')
    },
    decrement () {
    	store.commit('decrement')
    }
  }
})

$(document).on('shiny:sessioninitialized', function() {
  // increment from Shiny custom message
  //   chose 'increment' but does not have to match the store mutation name
  Shiny.addCustomMessageHandler('increment', function(msg) {
    store.commit('increment')
  });
  Shiny.addCustomMessageHandler('decrement', function(msg) {
    store.commit('decrement')
  });
})
"
  ))
)

browsable(ui)

server <- function(input, output, session) {
  observeEvent(input$btnIncrement, {
    session$sendCustomMessage("increment", list())
  })
  observeEvent(input$btnDecrement, {
    session$sendCustomMessage("decrement", list())
  })
}

shinyApp(
  ui = ui,
  server = server,
  options = list(launch.browser = rstudioapi::viewer)
)
