extract_formulas <- function(formulas, not = FALSE) {
  if (length(formulas) == 0) {return(NULL)}

  formulas <- glue_collapse(
    map(
      formulas,
      ~ paste0("(", gsub("\\.", "input", as.character(.)[2]), ")")
    ),
    sep = " | "
  )

  if (not) {formulas <- glue("!({formulas})")}

  parse(text = formulas)
}
