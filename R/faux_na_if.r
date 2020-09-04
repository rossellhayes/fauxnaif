#' @importFrom glue glue glue_collapse
#' @importFrom rlang abort as_function as_label caller_env enquo inform
#'     is_atomic is_formula is_function is_list is_logical is_missing warn

faux_na_if <- function(
  x, ..., arguments, arg_names, not = FALSE, scoped = FALSE
) {
  if (!scoped) {
    arguments <- list(...)
    arg_names <- as.list(substitute(list(...)))
  }

  if (is_list(recurse(x))) abort_uncoercible(x)

  if (length(arguments) == 0) {
    warn("No values to replace with `NA` specified.")
    return(x)
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

    replacement <- as_function(replacement)(x)

    if (!is_logical(replacement)) return(replacement)

    x[replacement]
  }

  replacements <- recurse(lapply(arguments[valid], eval_replacement))

  if (length(replacements) > 0) {
    if (not) {
      x[!x %in% replacements] <- NA
    } else {
      x[x %in% replacements] <- NA
    }
  }

  two_sided <- vapply(arguments, is_formula, logical(1), lhs = TRUE)

  if (any(two_sided))           warn_two_sided(arg_names[-1][two_sided])
  if (any(!valid & !two_sided)) warn_invalid(arg_names[-1][!valid & !two_sided])

  x
}

scoped_na_if <- function(fun, .tbl, ...) {
  if (!requireNamespace("dplyr")) {
    glue_abort(
      "Package `dplyr` must be installed to use scoped fauxnaif functions.",
      "\n",
      'Try `install.packages("dplyr")`'
    )
  }

  fun    <- get(fun, envir = asNamespace("dplyr"))
  result <- fun(.tbl = .tbl, .funs = faux_na_if, ..., scoped = TRUE)

  result
}
