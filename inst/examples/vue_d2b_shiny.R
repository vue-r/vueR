library(shiny)
library(treemap)
library(d3r)

d2b_dep <- htmltools::htmlDependency(
  name = "d2b",
  version = "0.0.23",
  src = c(href = "https://unpkg.com/d2b@0.0.23/build/"),
  script = "d2b.min.js"
)


ui <- tagList(
  # set up a div that will show state
  tags$div(
    id = "app",
    style = "height:400px",
    tag(
      "sunburst-chart",
      list(":data" = "sunburstChartData.data", ":config" = "sunburstChartConfig")
    )
  ),
  tags$script(
sprintf("
// careful here in a real application
//  set up a global/window store object to hold state
//  will be a simple object
var store = {data: %s};

// add a very simple function that will update our store object
//   with the x data provided
Shiny.addCustomMessageHandler(
  'updateStore',
  function(x) {
    // mutate store data to equal the x argument
    store.data = x;
    console.log('changed to ' + x);
  }
);

// super simple Vue app that watches our store object
var app = new Vue({
  el: '#app',
  components: {
    'sunburst-chart': d2b.vueChartSunburst
  },
  data: {
    sunburstChartData: store,
    sunburstChartConfig: function(chart) {
      chart.label(function(d){return d.name});
      chart.sunburst().size(function(d){return d.x});
    }
  }
});
",
d3r::d3_nest(
  treemap::random.hierarchical.data(),
  value_cols = "x"
)
)
  ),
  # add Vue dependency
  vueR::html_dependency_vue(offline = FALSE),
  d3r::d3_dep_v4(offline = FALSE),
  d2b_dep
)

server <- function(input,output,session) {
  observe({
    # every 1 second invalidate our session to trigger update
    invalidateLater(1000, session)
    # send a message to update store with a random value
    session$sendCustomMessage(
      type = "updateStore",
      message = d3r::d3_nest(
        treemap::random.hierarchical.data(),
        value_cols = "x"
      )
    )
  })
}

shinyApp(ui, server)
