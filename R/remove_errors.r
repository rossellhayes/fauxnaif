remove_errors <- function(evaluated_arguments, arguments) {
  errors      <- map_lgl(evaluated_arguments, ~ typeof(.) == "list")
  error_names <- map_chr(arguments[errors], ~ paste0("`", deparse(.), "`"))

  walk(
    error_names,
    ~ warning(
      "Argument ",
      .,
      " unused: cannot be coerced to a vector or interpreted as a formula"
    )
  )

  evaluated_arguments[errors] <- NULL
  evaluated_arguments
}
