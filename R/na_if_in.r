#' Convert values to NA
#'
#' This is a replacement for [dplyr::na_if()].
#' It is useful if you want to convert annoying values to `NA`.
#' Unlike [dplyr::na_if()], this function allows you to specify multiple values
#' to be replaced with `NA` at the same time.
#'  * `na_if_in()` replaces values that match its arguments with `NA`.
#'  * `na_if_not()` replaces values that *do not* match its arguments with `NA`.
#'
#' @section Formulas:
#' These functions accept one-sided formulas that can evaluate to logical
#' vectors.
#' The input is represented in these conditional statements as "`.`".
#' Valid formulas take the form `~ . < 0`.
#' See examples.
#'
#' @param x Vector to modify
#' @param ... Values to replace with `NA`, specified as either:
#' \itemize{
#'     \item An object, vector of objects, or list of objects
#'     \item A one-sided formula (see section "Formulas")
#' }
#' @return A modified version of `x` with selected values replaced with
#' `NA`.
#'
#' @seealso [dplyr::na_if()] to replace a single value with `NA`.
#'
#'   [dplyr::coalesce()] to replace missing values with a specified value.
#'
#'   [tidyr::replace_na()] to replace `NA` with a value.
#'
#'   [dplyr::recode()] and [dplyr::case_when()] to more generally replace
#'   values.
#'
#' @export
#' @examples
#' x <- sample(c(1:5, 99))
#' # We can replace 99...
#' # ... explicitly
#' na_if_in(x, 99)
#' # ... by specifying values to keep
#' na_if_not(x, 1:5)
#' # ... using a formula
#' na_if_in(x, ~ . > 5)
#' # ... or using a function
#' na_if_in(x, max)
#'
#' messy_string <- c("abc", "", "def", "NA", "ghi", 42, "jkl", "NULL", "mno")
#' # We can replace unwanted values...
#' # ... one at a time
#' na_if_in(messy_string, "")
#' # ... or all at once
#' na_if_in(messy_string, "", "NA", "NULL", 1:100)
#' na_if_in(messy_string, c("", "NA", "NULL", 1:100))
#' na_if_in(messy_string, list("", "NA", "NULL", 1:100))
#' # ... or using a clever formula
#' grepl("[a-z]{3,}", messy_string)
#' na_if_not(messy_string, ~ grepl("[a-z]{3,}", .))
#'
#' # na_if_in() is particularly useful inside dplyr::mutate
#' library(dplyr)
#' faux_census %>%
#'   mutate(
#'     state = na_if_in(state, "Canada"),
#'     age   = na_if_in(age, ~ . < 18, ~ . > 120)
#'   )
#'
#' # We get a message if our values to replace don't exist
#' na_if_in(x, 11)
#' # And a warning if we use an invalid input...
#' # ... like a two-sided formula
#' na_if_in(x, x ~ . < 0)
#' # ... NULL
#' na_if_in(x, NULL)
#' # ... or nothing at all
#' na_if_in(x)
#'
#' # This function handles vector values differently than dplyr,
#' # and returns a different result with vector replacement values:
#' na_if_in(1:5, 5:1)
#' dplyr::na_if(1:5, 5:1)

na_if_in <- function(x, ...) {
  faux_na_if(x, ...)
}

#' @rdname na_if_in
#' @export

na_if_not <- function(x, ...) {
  faux_na_if(x, ..., not = TRUE)
}
