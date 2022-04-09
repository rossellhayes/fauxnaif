matches <- function(x, ..., call = rlang::caller_env()) {
  # Set up argument labels if they are needed for error messages
  delayedAssign("labels",
    lapply(
      rlang::call_match(rlang::frame_call(call), rlang::frame_fn(call)),
      rlang::as_label
    )
  )
  delayedAssign("x_label", {
    x_label <- labels[["x"]]
    if (x_label == ".") { # In case `x` was passed in from `magrittr`
      x_label <- "x"
    }
    x_label
  })
  delayedAssign("arg_labels", {
    arg_labels <- labels[names(labels) != "x"]
    arg_labels <- arg_labels[-1] # Remove the function name
    arg_labels
  })

  assert_atomicish(x, x_label, call)

  args <- list(...)
  args <- validate_args(args, arg_labels, call)

  matches <- apply_functions(x, args, x_label, arg_labels, call)
  try_recurse(matches)
}

apply_functions <- function(x, args, x_label, arg_labels, call) {
  functions <- vlapply(args, rlang::is_function)

  args[functions] <- lapply(args[functions], do.call, args = list(x))

  assert_valid_functions(args, functions, x, x_label, arg_labels, call)

  args[functions] <- lapply(args[functions], function(logical) x[logical])

  args
}

validate_args <- function(args, arg_labels, call) {
  assert_args(args, call)

  lists <- vlapply(args, rlang::is_list)
  args[lists] <- lapply(args[lists], try_recurse)

  formulas <- vlapply(args, rlang::is_formula, lhs = FALSE)
  args[formulas] <- lapply(args[formulas], rlang::as_function)

  assert_valid_args(args, arg_labels, call)

  args
}
