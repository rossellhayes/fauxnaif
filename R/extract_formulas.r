extract_formulas <- function(formulas, not = FALSE) {
  if (length(formulas) > 0) {
    formulas <- glue_collapse(
      map(
        formulas,
        ~ glue('({gsub(".", "input", as.character(.)[2], fixed = TRUE)})')
      ),
      sep = " | "
    )

    parse(
      text = if (not) {
        glue("!({formulas})")
      } else {
        formulas
      }
    )
  } else {
    NULL
  }
}
