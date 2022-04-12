get_x_label <- function(call) {
  full_call <- call_standardize(call)

  if (!in_fauxnaif_function(full_call)) {
    return("x")
  }

  x <- full_call[["x"]]
  x_label <- rlang::expr_name(x)

  # In case `x` was passed in from the `magrittr` pipe
  if (x_label == ".") {
    return("x")
  }

  x_label
}

get_arg_labels <- function(call) {
  full_call <- call_standardize(call)

  # Exclude the first element (the function) and the second element (`x`)
  args <- full_call[-1:-2]

  if (!in_fauxnaif_function(full_call)) {
    return(paste0("..", seq_along(args)))
  }

  arg_labels <- vcapply(args, rlang::expr_name)
  arg_labels
}

call_standardize <- function(call) {
  tryCatch(
    rlang::call_match(rlang::frame_call(call), rlang::frame_fn(call)),
    error = identity
  )
}

in_fauxnaif_function <- function(full_call) {
  if (rlang::is_error(full_call)) {
    return(FALSE)
  }

  any(
    vlapply(as.list(full_call[[1]]), function(x) {
      identical(x, rlang::expr(na_if_in)) ||
        identical(x, rlang::expr(na_if_not))
    })
  )
}
