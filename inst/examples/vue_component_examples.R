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
  version = "2.13.2",
  src = c(href="https://unpkg.com/element-ui@2.13.2/lib/"),
  script = "index.js",
  stylesheet = "theme-chalk/index.css"
)

tl <- tagList(
  tags$script("
    ELEMENT.locale({
      el: {
        colorpicker: {
          confirm: 'OK',
          clear: 'Clear'
        },
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
          prevYear: 'Previous Year',
          nextYear: 'Next Year',
          prevMonth: 'Previous Month',
          nextMonth: 'Next Month',
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
          week: 'week',
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
        cascader: {
          noMatch: 'No matching data',
          loading: 'Loading',
          placeholder: 'Select',
          noData: 'No data'
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
          deleteTip: 'press delete to remove',
          delete: 'Delete',
          preview: 'Preview',
          continue: 'Continue'
        },
        table: {
          emptyText: 'No Data',
          confirmFilter: 'Confirm',
          resetFilter: 'Reset',
          clearFilter: 'All',
          sumText: 'Sum'
        },
        tree: {
          emptyText: 'No Data'
        },
        transfer: {
          noMatch: 'No matching data',
          noData: 'No data',
          titles: ['List 1', 'List 2'], // to be translated
          filterPlaceholder: 'Enter keyword', // to be translated
          noCheckedFormat: '{total} items', // to be translated
          hasCheckedFormat: '{checked}/{total} checked' // to be translated
        },
        image: {
          error: 'FAILED'
        },
        pageHeader: {
          title: 'Back' // to be translated
        },
        popconfirm: {
          confirmButtonText: 'Yes',
          cancelButtonText: 'No'
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
        ":data" = "data.children",
        ":props" = "defaultProps",
        "show-checkbox" = NA,
        "@check-change" = "handleCheckChange"
      )
    ),
    tags$pre("{{checkedNodes.map(function(d){return d.name})}}")
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
  this.$emit('tree-checked');
}
          "
        )
      )
    ),
    minified = FALSE
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


# add a d3 tree and make it respond to Vue tree
d3t <- networkD3::diagonalNetwork(
  jsonlite::fromJSON(
    d3r::d3_nest(
      rhd,
      value_cols="x"
    ),
    simplifyVector=FALSE,
    simplifyDataFrame=FALSE
  )
)
# use onRender to add event handling
d3t <- htmlwidgets::onRender(
  d3t,
"
function(el, x) {
  var vue_tree = HTMLWidgets.find('.vue').instance;
  vue_tree.$on(
    'tree-checked',
    function() {
      var myvue = this;
      var checkedNodes = myvue.checkedNodes.map(function(d){return d.name});
      var nodes = d3.select(el).selectAll('g.node');
      debugger;
      nodes.each(function(d) {
        if(checkedNodes.indexOf(d.data.name) > -1){
          d3.select(this).select('circle').style('fill', 'gray');
        } else {
          d3.select(this).select('circle').style('fill', 'rgb(255,255,255)');
        };
      })
    }
  )
}
"
)
browsable(
  attachDependencies(
    tagList(
      tags$div(tl_tree,style="width:20%; float:left; display:block;"),
      tags$div(d3t,style="width:70%; float:left; display:block;")
    ),
    list(
      element
    )
  )
)
