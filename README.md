
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fauxnaif <img src='man/figures/logo.png' align="right" height="138" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Build
Status](https://travis-ci.org/rossellhayes/fauxnaif.svg?branch=master)](https://travis-ci.org/rossellhayes/fauxnaif)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/rossellhayes/fauxnaif?branch=master&svg=true)](https://ci.appveyor.com/project/rossellhayes/fauxnaif)
[![Codecov test
coverage](https://codecov.io/gh/rossellhayes/fauxnaif/branch/master/graph/badge.svg)](https://codecov.io/gh/rossellhayes/fauxnaif?branch=master)
[![GitHub
License](https://img.shields.io/github/license/rossellhayes/fauxnaif?color=blueviolet)](https://github.com/rossellhayes/fauxnaif/blob/master/LICENSE)
<!-- badges: end -->

***faux-naïf***
([/ˌfoʊ.naɪˈif/](https://en.wikipedia.org/wiki/Help:IPA/English)): a
person who pretends to be simple or innocent

**`fauxnaif`**: an R package for simplifying data by pretending values
are `NA`

## Overview

fauxnaif provides a replacement for `dplyr::na_if()`. Unlike
[**dplyr**](https://github.com/tidyverse/dplyr)’s `na_if()`, it allows
you to specify multiple values to be replaced with `NA` using a single
function.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("rossellhayes/fauxnaif")
```

## Usage

``` r
library(dplyr)
library(fauxnaif)

na_if_in(1:10, 2, 4:5, c(7, 9))
#>  [1]  1 NA  3 NA NA  6 NA  8 NA 10

na_if_in(1:10, ~ . >= 8)
#>  [1]  1  2  3  4  5  6  7 NA NA NA

dplyr::starwars %>%
  select(name, hair_color) %>%
  mutate(mutated_hair_color = na_if_in(hair_color, "unknown", "none"))
#> # A tibble: 87 x 3
#>   name           hair_color mutated_hair_color
#>   <chr>          <chr>      <chr>             
#> 1 Luke Skywalker blond      blond             
#> 2 C-3PO          <NA>       <NA>              
#> 3 R2-D2          <NA>       <NA>              
#> 4 Darth Vader    none       <NA>              
#> 5 Leia Organa    brown      brown             
#> # ... with 82 more rows
```

## Credits

Sticker fonts are
[Bodoni\*](https://github.com/indestructible-type/Bodoni) and
[Hasklig](https://github.com/i-tu/Hasklig)
