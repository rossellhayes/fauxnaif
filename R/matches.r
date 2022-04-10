find_matches <- function(x, ..., call = rlang::caller_env()) {
  assert_atomicish(x, call)

  args <- list(...)
  args <- validate_args(args, call)

  matches <- apply_functions(x, args, call)
  try_recurse(matches)
}

apply_functions <- function(x, args, call) {
  functions <- vlapply(args, rlang::is_function)

  args[functions] <- lapply(args[functions], do.call, args = list(x))

  assert_valid_functions(args, functions, x, call)

  args[functions] <- lapply(args[functions], function(logical) x[logical])

  args
}

validate_args <- function(args, call) {
  assert_args(args, call)

  lists <- vlapply(args, rlang::is_list)
  args[lists] <- lapply(args[lists], try_recurse)

  formulas <- vlapply(args, rlang::is_formula, lhs = FALSE)
  args[formulas] <- lapply(args[formulas], rlang::as_function)

  assert_valid_args(args, call)

  args
}
