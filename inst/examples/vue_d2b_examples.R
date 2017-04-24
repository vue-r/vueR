library(vueR)
library(d3r)
library(treemap)
library(htmltools)

hier_dat <- treemap::random.hierarchical.data()
hier_json <- d3r::d3_nest(
  hier_dat,
  value_cols = "x"
)

library(dplyr)
hier_json <- hier_dat %>%
  treemap(index = c("index1", "index2", "index3"), vSize = "x") %>%
  {.$tm} %>%
  select(index1:index3,vSize, color) %>%
  rename(size = vSize) %>%
  d3_nest(value_cols = c("size", "color"))

browsable(tagList(
  html_dependency_vue(),
  d3r::d3_dep_v4(),
  tags$script(src = "https://unpkg.com/d3"),
  tags$script(src = "https://rawgit.com/d2bjs/d2b/master/build/d2b.js"),
  tags$div(
    id = "app",
    style = "height:400px",
    tag(
      "sunburst-chart",
      list(":data" = "sunburstChartData", ":config" = "sunburstChartConfig"
    )
  )),
  tags$script(HTML(
    sprintf(
      "
var app = new Vue({
  el: '#app',
  components: {
    'sunburst-chart': d2b.vueChartSunburst
  },
  data: {
    sunburstChartData: %s,
    sunburstChartConfig: function(chart) {
      var color = d3.scaleOrdinal(d3.schemeCategory20c);
      chart.label(function(d){return d.name});
      //chart.sunburst().size(function(d){return d.x});
      //chart.color(function(d){return color(d.name);})
      chart.color(function(d){return typeof(d.color) === 'undefined' ? '#BBB' : d.color; })
    }
  }
})
      ",
      hier_json
    )
  ))
))
