assert_atomicish <- function(x, call) {
  if (is_atomicish(x)) {
    return()
  }

  x_label <- get_x_label(call)

  cli::cli_abort(
    c(
      "!" = "Input {.arg x} must be coercible to a vector.",
      "x" = "{.arg {x_label}} is of uncoercible class {.cls {class(x)}}."
    ),
    call = call,
    class = "fauxnaif_uncoercible_input"
  )
}

assert_args <- function(args, call) {
  if (length(args) >= 1) {
    return()
  }

  cli::cli_abort(
    c("x" = "No values to replace with {.code NA} specified."),
    call = call,
    class = "fauxnaif_no_arguments"
  )
}

assert_valid_args <- function(args, call) {
  invalid <- vlapply(
    args,
    function(x) !rlang::is_atomic(x) & !rlang::is_function(x)
  )

  if (all(!invalid)) {
    return()
  }

  arg_labels <- get_arg_labels(call)

  errors <- mapply_chr(
    function(arg, label) {
      if (rlang::is_formula(arg, lhs = TRUE)) {
        return(cli::format_inline("{.arg {label}} is a two-sided formula."))
      }

      cli::format_inline(
        "{.arg {label}} is of uncoercible class {.cls {class(arg)}}."
      )
    },
    arg = args[invalid], label = arg_labels[invalid]
  )
  names(errors) <- rep("x", length(errors))

  cli::cli_abort(
    cli::cli_abort(
      c(
        "!" = "All arguments must be coercible to an atomic vector, function, or one-sided formula.",
        errors
      ),
      call = call,
      class = "fauxnaif_invalid_arguments"
    )
  )
}

assert_valid_functions <- function(args, functions, x, call) {
  invalid <- mapply_lgl(
    function(arg, is_function, x) {
      is_function &&
        (!rlang::is_logical(arg) || !identical(length(arg), length(x)))
    },
    arg = args, is_function = functions, MoreArgs = list(x = x)
  )

  if (all(!invalid)) {
    return()
  }

  x_label <- get_x_label(call)
  arg_labels <- get_arg_labels(call)

  errors <- mapply_chr(
    function(arg, label) {
      if (!rlang::is_logical(arg)) {
        return(cli::format_inline(
          "{.arg {label}} returns an object of class {.cls {class(arg)}}."
        ))
      }

      cli::format_inline(
        "{.arg {label}} returns a vector of length {.val {length(arg)}}."
      )
    },
    arg = args[invalid], label = arg_labels[invalid]
  )
  names(errors) <- rep("x", length(errors))

  cli::cli_abort(
    cli::cli_abort(
      c(
        "!" = paste(
          "All function arguments must return a logical vector of length",
          "{.val {length(x)}} (the same length as {.arg {x_label}})."
        ),
        errors
      ),
      call = call,
      class = "fauxnaif_invalid_functions"
    )
  )
}
