
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/timelyportfolio/vuer.svg?branch=master)](https://travis-ci.org/timelyportfolio/vueR)[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/vueR)](https://cran.r-project.org/package=vueR)

[Vue.js](https://vuejs.org) is a quiet, very popular JavaScript framework with an impressive set of features, a solid community, and MIT license. Don't tell anybody, but I think I might even like it better than React. With all this, Vue deserves its own set of helpers for `R`, just like [`d3r`](https://github.com/d3r) and [`reactR`](https://github.com/reactR).

`vueR` provides these helpers with its dependency function `html_dependency_vue` and ?htmlwidget?.

### Installation

`vueR` aims to achieve CRAN status, but for now, it only exists on Github.

    devtools::install_github("timelyportfolio/vueR")

### Example

We'll start with a recreation of the simple "Hello World" example from the Vue.js documentation. This is the hard way.

``` r
library(htmltools)
library(vueR)

browsable(
  attachDependencies(
    tagList(
      tags$div(id="app","{{message}}"),
      tags$script(
      "
      var app = new Vue({
        el: '#app',
        data: {
          message: 'Hello Vue!'
        }
      });
      "
      )
    ),
    html_dependency_vue()
  )
)
```

`vueR` gives us an `htmlwidget` that can ease the code burden from above.

``` r
library(vueR)
library(htmltools)

# recreate Hello Vue! example
browsable(
  tagList(
    tags$div(id="app", "{{message}}"),
    vue(
      list(
        el = "#app",
        data = list(
          message = "Hello Vue!"
        )
      )
    )
  )
)
```

### Code of Conduct

I would love for you to participate and help with `vueR`, but please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
