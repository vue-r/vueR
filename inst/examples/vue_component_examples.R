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
  tags$script("
ELEMENT.locale(
{
  el: {
  datepicker: {
  now: 'Now',
  today: 'Today',
  cancel: 'Cancel',
  clear: 'Clear',
  confirm: 'OK',
  selectDate: 'Select date',
  selectTime: 'Select time',
  startDate: 'Start Date',
  startTime: 'Start Time',
  endDate: 'End Date',
  endTime: 'End Time',
  year: '',
  month1: 'January',
  month2: 'February',
  month3: 'March',
  month4: 'April',
  month5: 'May',
  month6: 'June',
  month7: 'July',
  month8: 'August',
  month9: 'September',
  month10: 'October',
  month11: 'November',
  month12: 'December',
  // week: 'week',
  weeks: {
  sun: 'Sun',
  mon: 'Mon',
  tue: 'Tue',
  wed: 'Wed',
  thu: 'Thu',
  fri: 'Fri',
  sat: 'Sat'
  },
  months: {
  jan: 'Jan',
  feb: 'Feb',
  mar: 'Mar',
  apr: 'Apr',
  may: 'May',
  jun: 'Jun',
  jul: 'Jul',
  aug: 'Aug',
  sep: 'Sep',
  oct: 'Oct',
  nov: 'Nov',
  dec: 'Dec'
  }
  },
  select: {
  loading: 'Loading',
  noMatch: 'No matching data',
  noData: 'No data',
  placeholder: 'Select'
  },
  pagination: {
  goto: 'Go to',
  pagesize: '/page',
  total: 'Total {total}',
  pageClassifier: ''
  },
  messagebox: {
  title: 'Message',
  confirm: 'OK',
  cancel: 'Cancel',
  error: 'Illegal input'
  },
  upload: {
  delete: 'Delete',
  preview: 'Preview',
  continue: 'Continue'
  },
  table: {
  emptyText: 'No Data',
  confirmFilter: 'Confirm',
  resetFilter: 'Reset',
  clearFilter: 'All'
  },
  tree: {
  emptyText: 'No Data'
  }
  }
  })
  "),
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
        "v-model"="value_time",
        ":picker-options"="{
          start: '08:30',
          step: '00:15',
          end: '18:30'
        }",
        "placeholder"="Select time"
      )
    ),
    tags$span("Date Picker"),
    tag(
      "el-date-picker",
      list(
        "v-model"="value_date",
        type="date",
        placeholder="Pick a day"
      )
    )
  ),
  vue(list(el="#app",data=list(value5=0, value_time=NULL, value_date=NULL)))
)

browsable(
  attachDependencies(
    tl,
    list(
      element
    )
  )
)

rhd <- treemap::random.hierarchical.data()
tl_tree <- tagList(
  tags$div(
    id = "app",
    tag(
      "el-tree",
      list(
        "ref" = "mytree",
        ":data" = "data",
        ":props" = "defaultProps",
        "show-checkbox" = NA,
        "@check-change" = "handleCheckChange"
      )
    ),
    tags$pre("{{checkedNodes.map(d=>d.name) | json}}")
  ),
  vue(
    list(
      el="#app",
      data = list(
        data = d3r::d3_nest(
          rhd,
          value_cols="x"
        ),
        defaultProps = list(
          'children' = 'children',
          'label' = 'name'
        ),
        checkedNodes = list()
      ),
      methods = list(
        handleCheckChange = htmlwidgets::JS(
          "
function(data, checked, indeterminate){
  //debugger;
  //data.checked = checked && !indeterminate;
  console.log(data, checked, indeterminate);
  this.checkedNodes = this.$refs.mytree.getCheckedNodes();
}
          "
        )
      )
    )
  )
)

browsable(
  attachDependencies(
    tl_tree,
    list(
      element
    )
  )
)
