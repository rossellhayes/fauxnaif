
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fauxnaif

***faux-naïf*** (/ˌfoʊ.naɪˈif/ *FOH-niy-EEF*): a person who pretends to
be simple or innocent

**`fauxnaif`**: an R package for pretending values are `NA`

## Overview

fauxnaif provides a replacement for `dplyr::na_if()`. Unlike
[**dplyr**](https://github.com/tidyverse/dplyr)’s `na_if()`, it allows
you to specify multiple values to be replaced with `NA` using a single
function. Load **fauxnaif** after **dplyr** (or use a conflict manager
like [**conflicted**](https://github.com/r-lib/conflicted)) to use the
extended `na_if()` functionality. Alternatively, use `na_if_in()` to
avoid conflicts with **dplyr**.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("rossellhayes/fauxnaif")
```

## Usage

``` r
library(dplyr)
library(fauxnaif)

na_if(1:5, 2, 4)
#> [1]  1 NA  3 NA  5

dplyr::starwars %>%
  select(name, hair_color) %>%
  mutate(mutated_hair_color = na_if(hair_color, "unknown", "none"))
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
