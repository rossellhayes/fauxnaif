is_atomicish <- function(x) {
  rlang::is_atomic(try_recurse(x))
}

try_recurse <- function(x) {
  if (rlang::is_atomic(x)) {
    return(x)
  }

  recursed <- tryCatch(
    c(x, recursive = TRUE),
    error = identity
  )

  if (rlang::is_atomic(recursed)) {
    return(recursed)
  }

  x
}

vlapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = logical(1), ..., USE.NAMES = USE.NAMES)
}

vcapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = character(1), ..., USE.NAMES = USE.NAMES)
}

mapply_lgl <- function(f, ...) {
  vapply(Map(f, ...), identity, logical(1))
}

mapply_chr <- function(f, ...) {
  vapply(Map(f, ...), identity, character(1))
}

release_questions <- function() {
  "Have you updated the CITATION file?" # nocov
}
