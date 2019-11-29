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
#' @importFrom glue glue glue_collapse
#' @importFrom purrr map map_chr map_lgl walk
#' @importFrom rlang abort caller_env enquo is_formula warn
#' @aliases fauxnaif
#' @export
#' @examples
#' na_if_in(1:5, 2, 4)
#'
#' y <- c("abc", "", "def", "NA", "ghi", 42, "jkl", "NULL", "mno")
#' na_if(y, "", c("NA", "NULL"), 1:100)
#'
#' # This function handles vector values differently than dplyr,
#' # and returns a different result with vector replacement values:
#' na_if(1:5, 5:1)
#' dplyr::na_if(1:5, 5:1)
#'
#' # na_if_in is particularly useful inside mutate,
#' # and is meant for use with vectors rather than entire data frames
#' dplyr::starwars %>%
#'   dplyr::select(name, hair_color) %>%
#'   dplyr::mutate(hair_color = na_if(hair_color, "unknown", "none"))
#'
#' # na_if_in can also be used with scoped variants of mutate
#' # like mutate_if to mutate multiple columns
#' dplyr::starwars %>%
#'   dplyr::mutate_if(is.character, ~ na_if(., "unknown", "none"))

na_if <- function(input, ...) {
  arguments <- extract_arguments(...)
  input     <- faux_na_if(input, arguments, not = FALSE)
  input
}

#' @rdname na_if
#' @export
na_if_in <- na_if
