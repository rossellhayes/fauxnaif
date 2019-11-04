#' Convert values to NA
#'
#' This is a replacement for [dplyr::na_if()].
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
#'
#' @importFrom glue glue_collapse
#' @importFrom purrr map map_chr map_lgl
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
#'   mutate_if(is.character, list(~na_if(., "unknown", "none")))

na_if <- function(x, ...) {
  y <- c(..., recursive = TRUE)
  if (length(y) == 0) warning("No values to replace with `NA`")
  if (typeof(y) == "list") stop(test_na_if(...))
  x[x %in% y] <- NA
  x
}

test_na_if <- function(...) {
  args           <- as.list(substitute(list(...)))
  tested_args    <- map(args, ~ c(eval(.), recursive = TRUE))
  tested_args[1] <- NA
  errors         <- map_lgl(tested_args, ~ typeof(.) == "list")
  error_names    <- map_chr(args[errors], ~ paste0("`", deparse(.), "`"))
  error_message  <- glue_collapse(error_names, sep = ", ", last = " and ")

  if (length(error_args) == 1) {
    paste("Argument", error_message, "cannot be coerced to a vector")
  } else {
    paste("Arguments", error_message, "cannot be coerced to vectors")
  }
}
