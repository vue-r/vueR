library(shiny)
library(treemap)
library(d3r)
library(htmltools)

# set up dependency for d2bjs chart library
d2b_dep <- htmltools::htmlDependency(
  name = "d2b",
  version = "0.0.24",
  src = c(href = "https://unpkg.com/d2b@0.0.24/build/"),
  script = "d2b.min.js"
)

# our simple Vue d3 treemap component
template <- tag(
  "template",
  list(
    id = "d3treemap",
    tag(
      "svg",
      list(
        "v-bind:style"="styleObject",
        tag(
          "g",
          list(
            tag(
              "rect",
              list(
                "v-for" = "(node, index) in nodes",
                "v-if" = "node.depth === 2",
                "v-bind:x" = "node.x0",
                "v-bind:width" = "node.x1 - node.x0",
                "v-bind:y" =  "node.y0",
                "v-bind:height" = "node.y1 - node.y0",
                "v-bind:style" = "{fill: node.data.color ? node.data.color : color(node.parent.data.name)}"
              )
            )
          )
        )
      )
    )
  )
)

component <- tags$script(
"
Vue.component('treemap-component', {
  template: '#d3treemap',
  props: {
    tree: Object,
    sizefield: {
      type: String,
      default: 'size'
    },
    treewidth: {
      type: Number,
      default: 400
    },
    treeheight: {
      type: Number,
      default: 400
    },
    tile: {
      type: Function,
      default: d3.treemapSquarify
    },
    color: {
      type: Function,
        default: d3.scaleOrdinal(d3.schemeCategory10)
    }
  },
  computed: {
    styleObject: function() {
      return {width: this.treewidth, height: this.treeheight}
    },
    treemap: function() { return this.calculate_tree() },
    nodes: function() {
      var color = this.color;
      var nodes = [];
      this.treemap.each(function(d) {
        nodes.push(d);
      });
      return nodes;
    }
  },
  methods: {
    calculate_tree: function() {
      var sizefield = this.sizefield;
      var d3t = d3.hierarchy(this.tree)
        .sum(function(d) {
          return d[sizefield]
        });
      return d3.treemap()
        .size([this.treewidth, this.treeheight])
        .tile(this.tile)
        .round(true)
        .padding(1)(d3t)
    }
  }
});
"
)



app <- tags$script(HTML("
// careful here in a real application
//  set up a global/window store object to hold state
//  will be a simple object
var store = {
  tree: {},
  size: 'x',
  width: 800,
  height: 600,
  tile: d3.treemapBinary,
  sunburstChartConfig: function(chart) {
    chart.label(function(d){return d.name});
    chart.sunburst().size(function(d){return d.x});
  }
};

// add a very simple function that will update our store object
//   with the x data provided
Shiny.addCustomMessageHandler(
  'updateStore',
  function(x) {
    // mutate store data to equal the x argument
    store[x.field] = x.data;
    console.log('changed to ' + x);
  }
);

$(document).on(
  'shiny:connected',
  function() {
    var app = new Vue({
    el: '#app',
    components: {
      'sunburst-chart': d2b.vueChartSunburst
    },
      data: store
    })
  }
)
"
))


ui <- tagList(
  template,
  component,
  tags$div(
    id = "app",
    tags$div(
      style = "height:400px; width:400px; float:left;",
      tag(
        "sunburst-chart",
        list(":data" = "tree", ":config" = "sunburstChartConfig")
      )
    ),
    tags$div(
      style = "height:400px; width:400px; float:left;",
      tag(
        "treemap-component",
        list(":tree" = "tree",":sizefield"="'x'") #use defaults
      )
    )
  ),
  app,
  html_dependency_vue(offline=FALSE,minified=FALSE),
  d3_dep_v4(offline=FALSE),
  d2b_dep
)

server <- function(input, output, session) {
  observe({
    # every 1 second invalidate our session to trigger update
    invalidateLater(1000, session)
    # send a message to update store with a random value
    session$sendCustomMessage(
      type = "updateStore",
      message = list(
        field = "tree",
        data = d3r::d3_nest(
          treemap::random.hierarchical.data(),
          value_cols = "x"
        )
      )
    )
  })
}

shinyApp(ui, server)
