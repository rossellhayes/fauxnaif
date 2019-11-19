evaulate_arguments <- function(objects) {
  c(
    remove_errors(
      lapply(
        objects,
        function (x) c(eval(x), recursive = TRUE)
      ),
      objects
    ),
    recursive = TRUE
  )
}
