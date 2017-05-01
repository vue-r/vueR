library(treemap)
library(d3r)
library(htmltools)

# set up dependency for d2bjs chart library
d2b_dep <- htmltools::htmlDependency(
  name = "d2b",
  version = "0.0.28",
  src = c(href = "https://unpkg.com/d2b@0.0.28/build/"),
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



app <- tags$script(HTML(
sprintf(
"
// try to keep color consistent across charts
//  so use global color function
var color = d3.scaleOrdinal(d3.schemeCategory20);

// careful here in a real application
//  set up a global/window store object to hold state
//  will be a simple object
var tree = %s;
var store = {
  tree: tree,
  filtered_tree: tree,
  size: 'x',
  width: 800,
  height: 600,
  tile: d3.treemapBinary,
  color: color,
  sunburstChartConfig: function(chart) {
    chart.label(function(d){return d.name});
    chart.color(function(d){return color(d.name);})
    chart.sunburst().size(function(d){return d.x});
  }
};

var app = new Vue({
  el: '#app',
  components: {
    'sunburst-chart': d2b.vueChartSunburst
  },
  data: store,
  methods: {
    sunburstChartRendered: function (el, chart) {
      var that = this;
      d3.select(el).selectAll('.d2b-sunburst-chart')
        .on('mouseover', function (d) {
          if(d3.event.target.classList[0] === 'd2b-sunburst-arc'){
            that.filtered_tree = d3.select(d3.event.target).datum().data;
          }
        });
    }
  }
})
",
d3r::d3_nest(
  treemap::random.hierarchical.data(depth=4),
  value_cols = "x"
)
  )
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
        list(
          ":data" = "tree",
          ":config" = "sunburstChartConfig",
          "@rendered" = "sunburstChartRendered"
        )
      )
    ),
    tags$div(
      style = "height:400px; width:400px; float:left;",
      tag(
        "treemap-component",
        list(":tree" = "filtered_tree",":sizefield"="'x'",":color" = "color") #use defaults
      )
    )
  ),
  app,
  html_dependency_vue(offline=FALSE,minified=FALSE),
  d3_dep_v4(offline=FALSE),
  d2b_dep
)

browsable(ui)
