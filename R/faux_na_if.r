#' Convert values to NA
#'
#' This is an alias for [fauxnaif::na_if()] for those wishing to avoid conflict
#' with [dplyr::na_if()].
#' It is useful if you want to convert annoying values to `NA`.
#' Unlike [dplyr::na_if()], this function allows you to specify multiple values
#' to be replaced with `NA` at the same time.
#'
#' @param x Vector to modify
#' @param ... Values to replace with `NA`
#' @return A modified version of `x` that replaces any values contained in `...`
#'   with NA.
#' @seealso [dplyr::na_if()] to replace a single value with `NA`.
#'
#'   [dplyr::coalesce()] to replace missing values with a specified value.
#'
#'   [tidyr::replace_na()] to replace `NA` with a value.
#'
#'   [dplyr::recode()] and [dplyr::case_when()] to more generally replace
#'   values.
#' @export
#' @examples
#' faux_na_if(1:5, 2, 4)
#'
#' y <- c("abc", "", "def", "NA", "ghi", 42, "jkl", "NULL", "mno")
#' faux_na_if(y, "", c("NA", "NULL"), 1:100)
#'
#' \donttest{
#' # This function handles vector values differently than dplyr,
#' # and returns a different result with vector replacement values:
#' faux_na_if(1:5, 5:1)
#' dplyr::na_if(1:5, 5:1)
#'
#' # na_if is particularly useful inside mutate,
#' # and is meant for use with vectors rather than entire data frames
#' dplyr::starwars %>%
#'   select(name, hair_color) %>%
#'   mutate(hair_color = faux_na_if(hair_color, "unknown", "none"))
#'
#' # na_if can also be used with scoped variants of mutate
#' # like mutate_if to mutate multiple columns
#' dplyr::starwars %>%
#'   mutate_if(is.character, ~ faux_na_if(., "unknown", "none"))
#' }

faux_na_if <- na_if
