evaulate_arguments <- function(arguments, formulas) {
  arguments[formulas] <- NULL
  arguments[1]        <- NULL
  remove_errors(map(arguments, ~ c(eval(.), recursive = TRUE)), arguments)
}
