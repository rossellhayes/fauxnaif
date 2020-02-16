abort_uncoercible <- function(input) {
  glue_abort(
    'Input must be coercible to a vector. \n* ',
    encodeString(
      as_label(substitute(input, env = parent.frame(2))),
      quote = "`"
    ),
    ' is of uncoercible class "', class(input), '".'
  )
}

warn_invalid <- function(arg_names) {
  glue_warn(
    "Arguments must be atomics, formulas or functions. \n* ",
    glue_list(arg_names),
    " can't be used."
  )
}

warn_two_sided <- function(arg_names) {
  glue_warn(
    "Formulas must be one-sided.\n* ",
    glue_list(arg_names),
    " is a two-sided function."
  )
}

inform_no_replacements <- function(input, result) {
  if (identical(input, result))
    inform("Arguments were evaluated, but no replacements were made.")
}

glue_abort <- function(...) {
  abort(glue(...))
}

glue_warn <- function(...) {
  warn(glue(...))
}

glue_list <- function(vector) {
  glue_collapse(tick(vector), sep = ", ", last = " and ")
}

recurse <- function(list) {
  c(list, recursive = TRUE)
}

tick <- function(names) {
  vapply(
    vapply(names, as_label, as_label(1)),
    encodeString,
    character(1),
    quote = "`"
  )
}
