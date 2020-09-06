library(shiny)
library(vueR)
library(htmltools)
library(d3r)
library(treemap)

element <- htmlDependency(
  name = "element",
  version = "2.13.2",
  src = c(href="https://unpkg.com/element-ui@2.13.2/lib/"),
  script = "index.js",
  stylesheet = "theme-chalk/index.css"
)

locale <- {tags$script(HTML(
"
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
"
))}

# some random hierarchical data converted to proper format
rhd <- d3r::d3_nest(
  treemap::random.hierarchical.data(),
  value_cols="x"
)

ui <- tagList(
  html_dependency_vue(),
  element,
  actionButton("btnResetData", "Reset Data"),
  tags$head(locale),
  tags$script(HTML(
"
// add message handler to receive new data from R and update Vue data
Shiny.addCustomMessageHandler('updateData', function(message) {
  var w = HTMLWidgets.find(message.selector);
  if(typeof(w) !== 'undefined' && w.hasOwnProperty('instance')) {
    w.instance.data = message.data;
    w.instance.checkedNodes = [];
  }
});
"
  )),
  tags$h3("Tree from element-ui"),
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
    elementId = "vuewidget",
    list(
      el="#app",
      data = list(
        data = rhd,
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
      ),
      watch = list(
        checkedNodes = htmlwidgets::JS(
"
function(dat) {
  debugger
  Shiny.setInputValue(this.$el.id + '_checked', dat.map(d => d.name));
}
"
        )
      )
    ),
    minified = FALSE
  )
)

server <- function(input, output, session) {
  observeEvent(input$btnResetData, {
    session$sendCustomMessage(
      'updateData',
      list(
        selector = "#vuewidget",
        data = rhd
      )
    )
  })

  observeEvent(input$app_checked, {
    str(input$app_checked)
  })
}

shinyApp(ui, server)
