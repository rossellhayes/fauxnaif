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
