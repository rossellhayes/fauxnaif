faux_na_if <- function(input, arguments, not = FALSE) {
  check_valid_input(input)

  if(length(arguments) == 0) {
    warn("No values to replace with `NA` specified")
    return(input)
  }

  formula_indices <- sapply(arguments, is_formula, lhs = FALSE)
  formulas        <- extract_formulas(arguments[formula_indices], not = not)
  objects         <- evaulate_arguments(arguments[!formula_indices])

  if (length(objects) == 0 & length(formulas) == 0)
    warn("No valid values to replace with `NA` specified")

  input[eval(formulas)] <- NA

  if (length(objects) > 0) {
    if (not) {input[!input %in% objects] <- NA}
    else {input[input %in% objects] <- NA}
  }

  input
}
