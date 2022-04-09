assert_atomicish <- function(x, x_label, call) {
  if (is_atomicish(x)) {
    return()
  }

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

assert_valid_args <- function(args, arg_labels, call) {
  invalid <- vlapply(
    args,
    function(x) !rlang::is_atomic(x) & !rlang::is_function(x)
  )

  if (all(!invalid)) {
    return()
  }

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

assert_valid_fun <- function(arg, replacement, x, x_label, arg_label, call) {
  if (!rlang::is_logical(replacement)) {
    cli::cli_abort(
      c(
        "!" = "Function arguments must return logical vectors.",
        "x" = "{.arg {arg_label}} returns an object of class {.cls {class(replacement)}}."
      ),
      call = call,
      class = "fauxnaif_illogical_function"
    )
  }

  if (!identical(length(replacement), length(x))) {
    cli::cli_abort(
      c(
        "!" = "Function arguments must return vectors of the same length as {.arg x}.",
        "x" = paste(
          "{.arg {arg_label}} returns a vector of length {.val {length(replacement)}},",
          "but {.arg {x_label}} is length {.val {length(x)}}."
        )
      ),
      call = call,
      class = "fauxnaif_wrong_length_function"
    )
  }
}
