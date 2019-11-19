check_valid_input <- function(input) {
  if (typeof(c(input, recursive = TRUE)) == "list")
    stop(
      deparse(sys.call(sys.parent())),
      ": input `",
      deparse(substitute(input, env = parent.frame())),
      "` cannot be coerced to a vector",
      call. = FALSE
    )
}
