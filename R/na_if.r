#' Convert values to NA
#'
#' This is a replacement for [dplyr::na_if()].
#' It is useful if you want to convert annoying values to `NA`.
#' Unlike [dplyr::na_if()], this function allows you to specify multiple values
#' to be replaced with `NA` at the same time.
#'  * `na_if()` replaces values that match its arguments with `NA`.
#'  * `na_if_not()` replaces values that *do not* match its arguments with `NA`.
#'  * `na_if_in()` is provided as an alias for `na_if()` to avoid clashes
#' with [dplyr::na_if()].
#'
#' @section Formulas:
#' These functions accept one-sided formulas that can evaluate to logical
#' vectors.
#' The input is represented in these conditional statements as "`.`".
#' Valid formulas take the form `~ . < 0`.
#' Additional examples are included in section "Examples".
#'
#' @param input Vector to modify
#' @param ... Values to replace with `NA`, specified as either:
#' \itemize{
#'     \item An object, vector of objects, or list of objects
#'     \item A one-sided formula (see section "Formulas")
#' }
#' @return A modified version of `input` with selected values replaced with
#' `NA`.
#'
#' @seealso [Scoped variants][na_if_all()] can be used in pipelines and modify
#'   multiple variables at once
#'
#'   [dplyr::na_if()] to replace a single value with `NA`.
#'
#'   [dplyr::coalesce()] to replace missing values with a specified value.
#'
#'   [tidyr::replace_na()] to replace `NA` with a value.
#'
#'   [dplyr::recode()] and [dplyr::case_when()] to more generally replace
#'   values.
#'
#' @aliases fauxnaif
#' @export
#' @examples
#' -1:10
#' # We can replace -1...
#' # ... explicitly
#' na_if(-1:10, -1)
#' # ... by specifying values to keep
#' na_if_not(-1:10, 0:10)
#' # ... using a formula
#' na_if(-1:10, ~ . < 0)
#' # ... or using a function
#' na_if(-1:10, min)
#'
#' messy_string <- c("abc", "", "def", "NA", "ghi", 42, "jkl", "NULL", "mno")
#' # We can replace unwanted values...
#' # ... one at a time
#' na_if(messy_string, "")
#' # ... or all at once
#' na_if(messy_string, "", "NA", "NULL", 1:100)
#' na_if(messy_string, c("", "NA", "NULL", 1:100))
#' na_if(messy_string, list("", "NA", "NULL", 1:100))
#' # ... or using a clever formula
#' grepl("[a-z]{3,}", messy_string)
#' na_if_not(messy_string, ~ grepl("[a-z]{3,}", .))
#'
#' # na_if() is particularly useful inside dplyr::mutate
#' faux_census %>%
#'   dplyr::mutate(
#'     state = na_if(state, "Canada"),
#'     age   = na_if(age, ~ . < 18, ~ . > 120)
#'   )
#'
#' # We get a message if our values to replace don't exist
#' na_if(-1:10, 11)
#' # And a warning if we use an invalid input...
#' # ... like a two-sided formula
#' na_if(-1:10, x ~ . < 0)
#' # ... NULL
#' na_if(-1:10, NULL)
#' # ... or nothing at all
#' na_if(-1:10)
#'
#' # If you want to avoid clashes with dplyr::na_if(), you can use na_if_in()
#' na_if_in(-1:10, -1)
#'
#' # This function handles vector values differently than dplyr,
#' # and returns a different result with vector replacement values:
#' fauxnaif::na_if(1:5, 5:1)
#' dplyr::na_if(1:5, 5:1)

na_if <- function(input, ...) {
  faux_na_if(input, ...)
}

#' @rdname na_if
#' @export
na_if_in <- na_if

#' @rdname na_if
#' @export

na_if_not <- function(input, ...) {
  faux_na_if(input, ..., not = TRUE)
}
