
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fauxnaif <img src='man/figures/logo.png' align="right" height="138" />

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![GitHub
License](https://img.shields.io/github/license/rossellhayes/fauxnaif?color=blueviolet)](https://github.com/rossellhayes/fauxnaif/blob/master/LICENSE)
[![Travis build
status](https://travis-ci.org/rossellhayes/fauxnaif.svg?branch=master)](https://travis-ci.org/rossellhayes/fauxnaif)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/rossellhayes/fauxnaif?branch=master&svg=true)](https://ci.appveyor.com/project/rossellhayes/fauxnaif)
[![Codecov test
coverage](https://codecov.io/gh/rossellhayes/fauxnaif/branch/master/graph/badge.svg)](https://codecov.io/gh/rossellhayes/fauxnaif?branch=master)
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
```

### The basics

Let’s say we want to remove an unwanted negative value from a vector of
numbers

``` r
-1:10
#>  [1] -1  0  1  2  3  4  5  6  7  8  9 10
```

We can replace -1…

… explicitly:

``` r
na_if(-1:10, -1)
#>  [1] NA  0  1  2  3  4  5  6  7  8  9 10
```

… by specifying values to keep:

``` r
na_if_not(-1:10, 0:10)
#>  [1] NA  0  1  2  3  4  5  6  7  8  9 10
```

… using a formula:

``` r
na_if(-1:10, ~ . < 0)
#>  [1] NA  0  1  2  3  4  5  6  7  8  9 10
```

… or using a function:

``` r
na_if(-1:10, min)
#>  [1] NA  0  1  2  3  4  5  6  7  8  9 10
```

### A little more complex

``` r
messy_string <- c("abc", "", "def", "NA", "ghi", 42, "jkl", "NULL", "mno")
```

We can replace unwanted values…

… one at a time:

``` r
na_if(messy_string, "")
#> [1] "abc"  NA     "def"  "NA"   "ghi"  "42"   "jkl"  "NULL" "mno"
```

… or all at once:

``` r
na_if(messy_string, "", "NA", "NULL", 1:100)
#> [1] "abc" NA    "def" NA    "ghi" NA    "jkl" NA    "mno"
na_if(messy_string, c("", "NA", "NULL", 1:100))
#> [1] "abc" NA    "def" NA    "ghi" NA    "jkl" NA    "mno"
na_if(messy_string, list("", "NA", "NULL", 1:100))
#> [1] "abc" NA    "def" NA    "ghi" NA    "jkl" NA    "mno"
```

… or using a clever formula:

``` r
grepl("[a-z]{3,}", messy_string)
#> [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE
na_if_not(messy_string, ~ grepl("[a-z]{3,}", .))
#> [1] "abc" NA    "def" NA    "ghi" NA    "jkl" NA    "mno"
```

### With data frames

``` r
faux_census
#> # A tibble: 5 x 4
#>   state    age  income gender                      
#>   <chr>  <dbl>   <dbl> <chr>                       
#> 1 TX        57 9999999 Gender is a social construct
#> 2 Canada    49  149000 Male                        
#> 3 NY       557   90750 f                           
#> 4 LA         2   61000 Male                        
#> 5 TN        64 9999999 M
```

na\_if() is particularly useful inside dplyr::mutate:

``` r
faux_census %>%
 dplyr::mutate(
   income = na_if(income, 9999999),
   age    = na_if(age, ~ . < 18, ~ . > 120),
   state  = na_if_not(state, ~ grepl("^[A-Z]{2,}$", .)),
   gender = na_if(gender, ~ nchar(.) > 20)
 )
#> # A tibble: 5 x 4
#>   state   age income gender
#>   <chr> <dbl>  <dbl> <chr> 
#> 1 TX       57     NA <NA>  
#> 2 <NA>     49 149000 Male  
#> 3 NY       NA  90750 f     
#> 4 LA       NA  61000 Male  
#> 5 TN       64     NA M
```

Or you can use scoped functions (\_at, \_if, and \_all) directly on data
frames:

``` r
faux_census %>%
  na_if_at("age", ~ . < 18, ~ . > 120) %>% 
  na_if_not_at("state", ~ grepl("^[A-Z]{2,}$", .)) %>%
  na_if_if(is.character, ~ nchar(.) > 20) %>%
  na_if_all(9999999)
#> # A tibble: 5 x 4
#>   state   age income gender
#>   <chr> <dbl>  <dbl> <chr> 
#> 1 TX       57     NA <NA>  
#> 2 <NA>     49 149000 Male  
#> 3 NY       NA  90750 f     
#> 4 LA       NA  61000 Male  
#> 5 TN       64     NA M
```

## Credits

Hex sticker fonts are
[Bodoni\*](https://github.com/indestructible-type/Bodoni) by
[indestructible type\*](https://indestructibletype.com/Home.html) and
[Source Code Pro](https://github.com/adobe-fonts/source-code-pro) by
[Adobe](https://adobe.com).

Image adapted from icon made by [Freepik](https://freepik.com) from
[flaticon.com](https://www.flaticon.com/free-icon/paper-shredder_1701401).

-----

Please note that **fauxnaif** is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree
to abide by its terms.
