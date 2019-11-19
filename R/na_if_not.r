#' @rdname na_if
#' @export

na_if_not <- function(input, ...) {
  check_valid_input(input)

  arguments <- extract_arguments(...)

  if(length(arguments) == 0) {
    warn("No values to replace with `NA` specified")
    return(input)
  }

  formula_indices <- sapply(arguments, is_formula, lhs = FALSE)
  formulas        <- extract_formulas(arguments[formula_indices], not = TRUE)
  objects         <- evaulate_arguments(arguments[!formula_indices])

  if (length(objects) == 0 & length(formulas) == 0)
    warn("No valid values to replace with `NA` specified")

  input[eval(formulas)] <- NA
  if (length(objects) > 0) {
    input[!input %in% objects] <- NA
  }
  input
}
