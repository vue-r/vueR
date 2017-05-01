library(treemap)
library(vueR)
library(d3r)
library(htmltools)

rhd <- random.hierarchical.data()

rhd_json <- d3_nest(rhd, value_cols="x")

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
                "v-if" = "node.depth === depth",
                "v-bind:x" = "node.x0",
                "v-bind:width" = "node.x1 - node.x0",
                "v-bind:y" =  "node.y0",
                "v-bind:height" = "node.y1 - node.y0",
                "v-bind:style" = "{fill: node.data.color ? node.data.color : color(node.parent.data.name)}",
                "v-on:click" = "onNodeClick(node)"
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
    depth: {
      type: Number,
      default: 2
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
    },
    onNodeClick: function(node) {
      this.$emit('node_click', node, this)
    }
  }
});
"
)

app <- tags$script(HTML(
sprintf("
var tree = %s;

var app = new Vue({
  el: '#app',
  data: {
    tree: tree,
    size: 'x',
    width: 800,
    height: 600,
    tile: d3.treemapSliceDice,
    depth: 1,
    color: d3.scaleOrdinal(d3.schemeCategory20c)
  },
  methods: {
    node_clicked: function(node, component) {
      console.log(node, component);
    }
  }
})
",
rhd_json
)
))

# one treemap example
browsable(
  tagList(
    template,
    component,
    tags$div(
      id="app",
      tag(
        "treemap-component",
        list(":tree" = "tree",":sizefield"="'x'","v-on:node_click"="node_clicked") #use defaults
      )
    ),
    app,
    html_dependency_vue(offline=FALSE,minified=FALSE),
    d3_dep_v4(offline=FALSE)
  )
)


browsable(
  tagList(
    template,
    component,
    tags$div(
      id="app",
      tag(
        "treemap-component",
        list(":tree" = "tree",":sizefield"="'x'") #use defaults
      ),
      tag(
        "treemap-component",
        list(":tree" = "tree",":sizefield"="size",":treeheight"=100,":treewidth"=200) #use explicit height,width
      ),
      tag(
        "treemap-component",
        list(
          ":tree" = "tree",":sizefield"="size",
          ":treeheight"="height",":treewidth"="width",
          ":depth"="depth", ":color"="color"
        )
      ),
      tag(
        "treemap-component",
        list(":tree" = "tree",":sizefield"="size",":tile"="tile","v-on:node_click"="node_clicked")
      )
    ),
    tags$script("
      setInterval(
        function(){app.$data.depth = app.$data.depth === 3 ? 1 : app.$data.depth + 1},
        2000
      )
    "),
    app,
    html_dependency_vue(offline=FALSE,minified=FALSE),
    d3_dep_v4(offline=FALSE)
  )
)





### other approach not using directives
create_tree: function() {
  var createElement = this.$createElement;
  var color = d3.scaleOrdinal(d3.schemeCategory10);
  var nodes_g = this.nodes.map(function(d) {
    if(d.depth === 2) {
      return createElement(
        'g',
        null,
        [createElement(
          'rect',
          {
            attrs: {
              x: d.x0,
              width: d.x1 - d.x0,
              y: d.y0,
              height: d.y1 - d.y0
            },
            style: {
              fill: color(d.parent.data.name)
            },
            domProps: {
              __data__: d
            }
          }
        )]
      )
    }
  })
  return createElement(
    'svg',
    {style: {height: this.treeheight, width: this.treewidth}},
    nodes_g
  );
}

,
render: function() {return this.create_tree()},
updated: function() {return this.create_tree()}

