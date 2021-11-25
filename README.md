
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/vue-r/vueR/workflows/R-CMD-check/badge.svg)](https://github.com/vue-r/vueR/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/vueR)](https://CRAN.R-project.org/package=vueR)
<!-- badges: end -->

[Vue.js](https://vuejs.org) is a quiet, very popular JavaScript
framework with an impressive set of features, a solid community, and MIT
license. Don’t tell anybody, but I think I might even like it better
than React. With all this, Vue deserves its own set of helpers for `R`,
just like [`d3r`](https://github.com/timelyportfolio/d3r) and
[`reactR`](https://github.com/react-r/reactR).

`vueR` provides these helpers with its dependency function
`html_dependency_vue()` and `htmlwidget` helper `vue()`.

### Installation

    install.packages("vueR")

or for the latest if different from CRAN

    remotes::install_github("vue-r/vueR")

### Example

We’ll start with a recreation of the simple “Hello World” example from
the Vue.js documentation. This is the hard way.

``` r
library(htmltools)
library(vueR)

browsable(
  tagList(
    html_dependency_vue(), # local and minimized by default
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
  )
)
```

`vueR` gives us an `htmlwidget` that can ease the code burden from
above.

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

Also, please check out additional
[examples](https://github.com/vue-r/vueR/tree/master/inst/examples) and
[experiments](https://github.com/vue-r/vueR/tree/master/inst/experiments).

### Build/Update

`vueR` is now part of a Github organization, and hopefully will be
backed with interest by more than one (me) developer. For most `vueR`
users, this section will not apply, but I would like to document the
build/update step for new versions of `Vue`. In
[`getvue.R`](https://github.com/vue-r/vueR/blob/master/build/getvue.R),
I created some functions for rapid download and deployment of new `Vue`
versions. Running all of the code in `getvue.R` should update local
minified and development versions of Vue and also update the version
references in `vueR`.

### Code of Conduct

I would love for you to participate and help with `vueR`, but please
note that this project is released with a [Contributor Code of
Conduct](https://github.com/vue-r/vueR/blob/master/CONDUCT.md). By
participating in this project you agree to abide by its terms.
