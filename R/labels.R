get_x_label <- function(call) {
  full_call <- rlang::call_match(rlang::frame_call(call), rlang::frame_fn(call))

  x <- full_call[["x"]]
  x_label <- rlang::expr_name(x)

  # In case `x` was passed in from the `magrittr` pipe
  if (x_label == ".") {
    return("x")
  }

  x_label
}

get_arg_labels <- function(call) {
  full_call <- rlang::call_match(rlang::frame_call(call), rlang::frame_fn(call))

  # Exclude the first element (the function) and the second element (`x`)
  args <- full_call[-1:-2]
  arg_labels <- vcapply(args, rlang::expr_name)
  arg_labels
}
