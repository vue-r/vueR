library(htmltools)
library(vueR)

#### Mint examples #######################################
mint <- htmlDependency(
  name = "mint-ui",
  version = "2.0.5",
  src = c(href="https://unpkg.com/mint-ui/lib"),
  script = "index.js",
  stylesheet = "style.css"
)

tl <- tagList(
  tags$script("Vue.use(MINT)"),
  tags$div(
    id="app",
    tag("mt-switch",list("v-model"="value","{{value ? 'on' : 'off'}}")),
    tag(
      "mt-checklist",
      list(
        title="checkbox list",
        "v-model"="checkbox_value",
        ":options"="['Item A', 'Item B', 'Item C']"
      )
    )
  ),
  vue(list(el="#app",data=list(value=TRUE, checkbox_value=list())))
)

browsable(
  attachDependencies(
    tl,
    mint
  )
)

#### Element examples ####################################
element <- htmlDependency(
  name = "element",
  version = "1.0.3",
  src = c(href="https://unpkg.com/element-ui/lib"),
  script = "index.js",
  stylesheet = "theme-default/index.css"
)

tl <- tagList(
  tags$div(
    id="app",
    tags$span("Slider With Breakpoints Displayed"),
    tag(
      "el-slider",
      list(
        "v-model"="value5",
        ":step"=10,
        "show-stops" = NA
      )
    ),
    tags$span("Time Picker"),
    tag(
      "el-time-select",
      list(
        "v-model"="value1",
        ":picker-options"="{
          start: '08:30',
          step: '00:15',
          end: '18:30'
        }",
        "placeholder"="Select time"
      )
    )
  ),
  vue(list(el="#app",data=list(value5=0, value1=NULL)))
)

browsable(
  attachDependencies(
    tl,
    element
  )
)
