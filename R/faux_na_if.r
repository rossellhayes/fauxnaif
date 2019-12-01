#' @importFrom glue glue glue_collapse
#' @importFrom rlang abort as_function caller_env enquo inform is_atomic
#' is_formula is_function is_list is_logical is_missing warn

faux_na_if <- function(input, ..., not = FALSE, arguments, arg_names) {
  if (is_missing(arguments)) {arguments <- list(...)}
  if (is_missing(arg_names)) {arg_names <- as.list(substitute(list(...)))}

  original_input <- input

  if (is_list(c(input, recursive = TRUE))) {
    abort(
      glue(
        "Input ",
        deparse(substitute(input, env = parent.frame())),
        " invalid: input must be coercible to a vector"
      )
    )
  }

  if(length(arguments) == 0) {
    warn("No values to replace with `NA` specified")
    return(input)
  }

  lists <- sapply(arguments, is_list)

  arguments[lists] <- lapply(arguments[lists], c, recursive = TRUE)

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

  replacements <- c(sapply(arguments[valid], eval_replacement), recursive = TRUE)

  if (length(replacements) > 0) {
    if (not) {
      input[!input %in% replacements] <- NA
    } else {
      input[input %in% replacements] <- NA
    }
  } else {
    warn("No valid values to replace with `NA` specified")
  }

  two_sided <- sapply(arguments, is_formula, lhs = TRUE)

  if (sum(two_sided) > 0) {
    warn(
      glue(
        "Argument",
        ifelse(sum(!valid & !two_sided) > 1, "s ", " "),
        glue_collapse(arg_names[-1][two_sided], sep = ", ", last = " and "),
        " unused: formulas must be one-sided"
      )
    )
  }

  if (sum(!valid & !two_sided) > 0) {
    warn(
      glue(
        "Argument",
        ifelse(sum(!valid & !two_sided) > 1, "s ", " "),
        glue_collapse(
          arg_names[-1][!valid & !two_sided], sep = ", ", last = " and "
        ),
        " unused: arguments must be atomics, formulas or functions"
      )
    )
  }

  if(identical(input, original_input) & sum(two_sided | !valid) == 0)
    inform("Arguments were evaluated, but no replacements were made")

  input
}
