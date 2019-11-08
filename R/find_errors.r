#' Helper function to find invalid inputs

find_errors <- function(arguments, evaluated_arguments) {
  errors         <- map_lgl(evaluated_arguments, ~ typeof(.) == "list")
  error_names    <- map_chr(arguments[errors], ~ paste0("`", deparse(.), "`"))
  error_message  <- glue_collapse(error_names, sep = ", ", last = " and ")

  if (length(error_args) == 1) {
    paste(
      "Argument",
      error_message,
      "cannot be coerced to a vector or interpreted as a formula"
    )
  } else {
    paste(
      "Arguments",
      error_message,
      "cannot be coerced to vectors or interpreted as formulas"
    )
  }
}
