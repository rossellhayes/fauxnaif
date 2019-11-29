check_valid_input <- function(input) {
  if (typeof(c(input, recursive = TRUE)) == "list") {
    input <- deparse(substitute(input, env = parent.frame(2)))

    abort(
      paste0(
        "Input `",
        input,
        "` cannot be coerced to a vector"
      )
    )
  }
}

extract_arguments <- function (...) {
  arguments    <- as.list(substitute(list(...)))
  arguments[1] <- NULL
  arguments
}

remove_errors <- function(evaluated_arguments, arguments) {
  if (any(sapply(arguments, is_formula, lhs = TRUE)))
    warn("Formula arguments must be one-sided")

  errors      <- map_lgl(evaluated_arguments, ~ typeof(.) == "list")
  error_names <- map_chr(arguments[errors], ~ glue("`{deparse(.)}`"))

  walk(
    error_names,
    ~ rlang::warn(
      message = glue(
        'Argument {.} unused: cannot be coerced to a vector or interpreted as ',
        'a formula'
      ),
      bad_arg = .
    )
  )

  evaluated_arguments[errors] <- NULL
  evaluated_arguments
}
