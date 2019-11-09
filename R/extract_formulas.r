extract_formulas <- function(arguments, formulas) {
  if (any(map_lgl(arguments, ~ is_formula(., lhs = TRUE))))
    stop("Formula arguments must be one-sided")

  parse(
    text = paste(
      map(
        arguments[formulas],
        ~ gsub("\\.|\\.x", "x", as.character(.)[2])
      ),
      collapse = " | "
    )
  )
}
