#' @importFrom glue glue glue_collapse
#' @importFrom rlang abort as_function as_label caller_env enquo inform
#' is_atomic is_formula is_function is_list is_logical is_missing warn

faux_na_if <- function(input, ..., not = FALSE, arguments, arg_names) {
  if (is_missing(arguments)) arguments <- list(...)
  if (is_missing(arg_names)) arg_names <- as.list(substitute(list(...)))

  original_input <- input

  if (is_list(recurse(input))) abort_uncoercible(input)

  if (length(arguments) == 0) {
    warn("No values to replace with `NA` specified.")
    return(input)
  }

  lists <- sapply(arguments, is_list)

  arguments[lists] <- lapply(arguments[lists], recurse)

  valid <- sapply(
    arguments,
    function(x) is_atomic(x) | is_function(x) | is_formula(x, lhs = FALSE)
  )

  eval_replacement <- function(replacement) {
    if (is_atomic(replacement)) return(replacement)

    replacement <- as_function(replacement)(input)

    if (!is_logical(replacement)) return(replacement)

    input[replacement]
  }

  replacements <- recurse(sapply(arguments[valid], eval_replacement))

  if (length(replacements) > 0) {
    if (not) {
      input[!input %in% replacements] <- NA
    } else {
      input[input %in% replacements] <- NA
    }
  } else {
    warn("No valid values to replace with `NA` specified.")
  }

  two_sided <- sapply(arguments, is_formula, lhs = TRUE)

  if (any(two_sided))           warn_two_sided(arg_names[-1][two_sided])
  if (any(!valid & !two_sided)) warn_invalid(arg_names[-1][!valid & !two_sided])

  if (identical(input, original_input) & sum(two_sided | !valid) == 0)
    inform("Arguments were evaluated, but no replacements were made.")

  input
}
