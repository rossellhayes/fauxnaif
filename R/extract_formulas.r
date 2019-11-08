#' Helper function to extract and format formulas

extract_formulas <- function(arguments, formulas) {
  str_c(
    map(
      arguments[formulas],
      ~ str_replace(as.character(.)[2], "\\.|\\.x", "x")
    ),
    collapse = " | "
  )
}
