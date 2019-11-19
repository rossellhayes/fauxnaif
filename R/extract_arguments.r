extract_arguments <- function (...) {
  arguments <- as.list(substitute(list(...)))
  arguments[1] <- NULL

  arguments
}
