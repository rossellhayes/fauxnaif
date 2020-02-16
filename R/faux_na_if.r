#' @importFrom glue glue glue_collapse
#' @importFrom rlang abort as_function as_label caller_env enquo inform
#'     is_atomic is_formula is_function is_list is_logical is_missing warn

faux_na_if <- function(
  input, ..., arguments, arg_names, not = FALSE, scoped = FALSE
) {
  if (!scoped) {
    arguments <- list(...)
    arg_names <- as.list(substitute(list(...)))
  }

  original_input <- input

  if (is_list(recurse(input))) abort_uncoercible(input)

  if (length(arguments) == 0) {
    warn("No values to replace with `NA` specified.")
    return(input)
  }

  lists <- vapply(arguments, is_list, logical(1))

  arguments[lists] <- lapply(arguments[lists], recurse)

  valid <- vapply(
    arguments,
    function(x) is_atomic(x) | is_function(x) | is_formula(x, lhs = FALSE),
    logical(1)
  )

  eval_replacement <- function(replacement) {
    if (is_atomic(replacement)) return(replacement)

    replacement <- as_function(replacement)(input)

    if (!is_logical(replacement)) return(replacement)

    input[replacement]
  }

  replacements <- recurse(lapply(arguments[valid], eval_replacement))

  if (length(replacements) > 0) {
    if (not) {
      input[!input %in% replacements] <- NA
    } else {
      input[input %in% replacements] <- NA
    }
  } else {
    warn("No valid values to replace with `NA` specified.")
  }

  two_sided <- vapply(arguments, is_formula, logical(1), lhs = TRUE)

  if (any(two_sided))           warn_two_sided(arg_names[-1][two_sided])
  if (any(!valid & !two_sided)) warn_invalid(arg_names[-1][!valid & !two_sided])

  if (!scoped & sum(two_sided | !valid) == 0) {
    inform_no_replacements(input, original_input)
  }

  input
}

scoped_na_if <- function(fun, .tbl, ...) {
  if(!requireNamespace("dplyr")) {
    glue_abort(
      "Package `dplyr` must be installed to use scoped fauxnaif functions.",
      "\n",
      'Try install.packages("dplyr")'
    )
  }

  result <- fun(.tbl = .tbl, .funs = faux_na_if, ..., scoped = TRUE)

  inform_no_replacements(.tbl, result)

  result
}
