extract_formulas <- function(arguments, formulas) {
  paste(
    map(
      arguments[formulas],
      ~ gsub("\\.|\\.x", "x", as.character(.)[2])
    ),
    collapse = " | "
  )
}
