library(htmltools)
library(leaflet) # I installed leaflet 1.0 with devtools::install_github("timelyportfolio/leaflet@v1.0")
library(leaflet.extras)
library(vueR)

topojson <- readr::read_file('https://rawgit.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson')

map <- leaflet() %>%
  setView(-75.14, 40, zoom = 11) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addGeoJSONChoropleth(
    topojson,
    valueProperty = "{{selected}}",
    group = "choro"
  )

ui <- tagList(
  tags$div(
    id="app",
    tags$select("v-model" = "selected",
      tags$option("disabled value"="","Select one"),
      tags$option("incidents"),
      tags$option("dist_num")
    ),
    tags$span(
      "Selected: {{selected}}"
    ),
    tags$div(map)
),
  tags$script(
"
var app = new Vue({
  el: '#app',
  data: {
    selected: 'incidents'
  },
  watch: {
    selected: function() {
      // uncomment debugger below if you want to step through
      //debugger;

      // only expect one
      //  if we expect multiple leaflet then we will need
      //  to be more specific
      var instance = HTMLWidgets.find('.leaflet');
      // get the map
      //  could easily combine with above
      var map = instance.getMap();
      // we set group name to choro above
      //  so that we can easily clear
      map.layerManager.clearGroup('choro');

      // now we will use the prior method to redraw
      var el = document.querySelector('.leaflet');
      // get the original method
      var addgeo = JSON.parse(document.querySelector(\"script[data-for='\" + el.id + \"']\").innerText).x.calls[1];
      addgeo.args[7].valueProperty = this.selected;
      LeafletWidget.methods.addGeoJSONChoropleth.apply(map,addgeo.args);
    }
  }
});
"
  ),
  html_dependency_vue(offline=FALSE)
)

browsable(ui)
