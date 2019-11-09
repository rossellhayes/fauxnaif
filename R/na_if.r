#' Convert values to NA
#'
#' This is a replacement for [dplyr::na_if()].
#' It is useful if you want to convert annoying values to `NA`.
#' Unlike [dplyr::na_if()], this function allows you to specify multiple values
#' to be replaced with `NA` at the same time.
#' `faux_na_if()` is offered as an alternative to avoid clashes with
#' \link[dplyr:dplyr-package]{dplyr}.
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
#'
#' @importFrom glue glue_collapse
#' @importFrom purrr map map_chr map_lgl
#' @importFrom rlang is_formula
#' @importFrom stringr fixed str_c str_replace
#' @aliases faux_na_if fauxnaif
#' @export
#' @examples
#' na_if(1:5, 2, 4)
#'
#' y <- c("abc", "", "def", "NA", "ghi", 42, "jkl", "NULL", "mno")
#' na_if(y, "", c("NA", "NULL"), 1:100)
#'
#' # This function handles vector values differently than dplyr,
#' # and returns a different result with vector replacement values:
#' na_if(1:5, 5:1)
#' dplyr::na_if(1:5, 5:1)
#'
#' # na_if is particularly useful inside mutate,
#' # and is meant for use with vectors rather than entire data frames
#' dplyr::starwars %>%
#'   select(name, hair_color) %>%
#'   mutate(hair_color = na_if(hair_color, "unknown", "none"))
#'
#' # na_if can also be used with scoped variants of mutate
#' # like mutate_if to mutate multiple columns
#' dplyr::starwars %>%
#'   mutate_if(is.character, ~ na_if(., "unknown", "none"))

na_if <- function(x, ...) {
  if (typeof(c(x, recurisve = TRUE)) == "list")
    stop("Input `x` cannot be coerced to a vector")

  arguments <- as.list(substitute(list(...)))

  if (any(map_lgl(arguments, ~ is_formula(., lhs = TRUE))))
    stop("Formula arguments must be one-sided")

  formulas <- map_lgl(arguments, ~ is_formula(., lhs = FALSE))
  x[eval(parse(text = extract_formulas(arguments, formulas)))] <- NA

  arguments[formulas] <- NULL
  arguments[1]        <- NULL
  evaluated_arguments <- map(arguments, ~ c(eval(.), recursive = TRUE))
  y                   <- c(evaluated_arguments, recursive = TRUE)

  if (typeof(y) == "list")
    stop(find_errors(arguments, evaluated_arguments))

  if (length(y) == 0 & sum(formulas) == 0)
    warning("No values to replace with `NA` specified")

  x[x %in% y] <- NA
  x
}

#' @rdname na_if
#' @export

faux_na_if <-  na_if
