#' @rdname na_if_all
#' @export

na_if_not_all <- function(.tbl, ...) {
  if(!requireNamespace("dplyr")) {
    abort("Package `dplyr` must be installed to use `na_if_not_all`")
  }

  arguments <- extract_arguments(...)

  dplyr:::check_grouped(.tbl, "mutate", "all", alt = TRUE)

  funs <- dplyr:::manip_all(
    .tbl, faux_na_if, enquo(faux_na_if), caller_env(), arguments, not = TRUE
  )

  dplyr::mutate(.tbl, !!!funs)
}

#' @rdname na_if_all
#' @export

na_if_not_at <- function(.tbl, .vars, ...) {
  if(!requireNamespace("dplyr")) {
    abort("Package `dplyr` must be installed to use `na_if_not_at`")
  }

  arguments <- extract_arguments(...)

  funs <- dplyr:::manip_at(
    .tbl, .vars, faux_na_if, enquo(faux_na_if), caller_env(),
    .include_group_vars = TRUE, arguments, not = TRUE
  )

  dplyr::mutate(.tbl, !!!funs)
}

#' @rdname na_if_all
#' @export

na_if_not_if <- function(.tbl, .predicate, ...) {
  if(!requireNamespace("dplyr")) {
    abort("Package `dplyr` must be installed to use `na_if_not_if`")
  }

  arguments <- extract_arguments(...)

  dplyr:::check_grouped(.tbl, "mutate", "if")

  funs <- dplyr:::manip_if(
    .tbl, .predicate, faux_na_if, enquo(faux_na_if), caller_env(), arguments,
    not = TRUE
  )

  dplyr::mutate(.tbl, !!!funs)
}
