#' @rdname na_if
#' @export

na_if_not <- function(input, ...) {
  arguments <- extract_arguments(...)
  input     <- faux_na_if(input, arguments, not = TRUE)
  input
}
