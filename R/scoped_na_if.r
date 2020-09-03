#' Convert values to NA in multiple columns
#'
#' \lifecycle{deprecated}
#'
#' The [dplyr::scoped] variants of [na_if()] and [na_if_not()] can be used
#' directly within pipelines and can modify multiple variables at once.
#'  * `*_all()` affects every variable
#'  * `*_at()` affects variables selected with a character vector or
#'  [dplyr::vars()]
#'  * `*_if()` affects variables selected with a predicate function
#'
#' @param .tbl A `tbl` object
#' @param .predicate A predicate function to be applied to the columns or a
#'   logical vector. The variables for which .predicate is or returns TRUE are
#'   selected. This argument is passed to [rlang::as_function()] and thus
#'   supports quosure-style lambda functions and strings representing function
#'   names.
#' @param .vars A list of columns generated by [dplyr::vars()], a character
#'   vector of column names, a numeric vector of column positions, or NULL.
#' @param ... Values to replace with `NA`, specified as either:
#' \itemize{
#'     \item An object, vector of objects, or list of objects
#'     \item A one-sided formula (see section "Formulas" in [na_if()])
#' }
#' @return A modified data frame. Matched values in selected columns are
#'   replaced with `NA`.
#' @seealso [na_if_in()] and [na_if_not()] operate directly on vectors
#'
#'   [dplyr::mutate_all()], [dplyr::mutate_at()] and [dplyr::mutate_if()] can
#'   apply any function to variables selected in the same way
#'
#' @examples
#' \dontrun{
#' df <- data.frame(a = 0:5, b = 5:0, c = as.numeric(0:5), d = letters[1:6])
#'
#' na_if_all(df, 0)
#' na_if_not_all(df, 0:3, "c")
#'
#' na_if_at(df, c("a", "c"), 0)
#' na_if_not_at(df, c("a", "c"), 0:3)
#'
#' na_if_if(df, is.integer, 0)
#' na_if_not_if(df, is.integer, 0:3)
#' }
#'
#' @name scoped_na_if

NULL

#' @rdname scoped_na_if
#' @export

na_if_all <- function(.tbl, ...) {
  lifecycle::deprecate_warn("0.6.0", format(sys.call()[1]), "dplyr::across()")

  scoped_na_if(
    fun       = dplyr::mutate_all,
    .tbl      = .tbl,
    arguments = list(...),
    arg_names = as.list(substitute(list(...)))
  )
}

#' @rdname scoped_na_if
#' @export

na_if_not_all <- function(.tbl, ...) {
  lifecycle::deprecate_warn("0.6.0", format(sys.call()[1]), "dplyr::across()")

  scoped_na_if(
    fun       = dplyr::mutate_all,
    .tbl      = .tbl,
    arguments = list(...),
    arg_names = as.list(substitute(list(...))),
    not       = TRUE
  )
}

#' @rdname scoped_na_if
#' @export

na_if_at <- function(.tbl, .vars, ...) {
  lifecycle::deprecate_warn("0.6.0", format(sys.call()[1]), "dplyr::across()")

  scoped_na_if(
    fun       = dplyr::mutate_at,
    .tbl      = .tbl,
    .vars     = .vars,
    arguments = list(...),
    arg_names = as.list(substitute(list(...)))
  )
}

#' @rdname scoped_na_if
#' @export

na_if_not_at <- function(.tbl, .vars, ...) {
  lifecycle::deprecate_warn("0.6.0", format(sys.call()[1]), "dplyr::across()")

  scoped_na_if(
    fun       = dplyr::mutate_at,
    .tbl      = .tbl,
    .vars     = .vars,
    arguments = list(...),
    arg_names = as.list(substitute(list(...))),
    not       = TRUE
  )
}

#' @rdname scoped_na_if
#' @export

na_if_if <- function(.tbl, .predicate, ...) {
  lifecycle::deprecate_warn("0.6.0", format(sys.call()[1]), "dplyr::across()")

  scoped_na_if(
    fun        = dplyr::mutate_if,
    .tbl       = .tbl,
    .predicate = .predicate,
    arguments  = list(...),
    arg_names  = as.list(substitute(list(...)))
  )
}

#' @rdname scoped_na_if
#' @export

na_if_not_if <- function(.tbl, .predicate, ...) {
  lifecycle::deprecate_warn("0.6.0", format(sys.call()[1]), "dplyr::across()")

  scoped_na_if(
    fun        = dplyr::mutate_if,
    .tbl       = .tbl,
    .predicate = .predicate,
    arguments  = list(...),
    arg_names  = as.list(substitute(list(...))),
    not        = TRUE
  )
}

