% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/na_if_in.r
\name{na_if_in}
\alias{na_if_in}
\alias{na_if_not}
\title{Convert values to NA}
\usage{
na_if_in(x, ...)

na_if_not(x, ...)
}
\arguments{
\item{x}{Vector to modify}

\item{...}{Values to replace with \code{NA}, specified as either:
\itemize{
\item An object, vector of objects, or list of objects.
\item A function (including a \link[rlang:as_function]{purrr-style lambda function})
that returns a logical vector of the same length as \code{x}.
See section "Formulas" for more details.
}}
}
\value{
A modified version of \code{x} with selected values replaced with
\code{NA}.
}
\description{
This is a replacement for \code{\link[dplyr:na_if]{dplyr::na_if()}}.
It is useful if you want to convert annoying values to \code{NA}.
Unlike \code{\link[dplyr:na_if]{dplyr::na_if()}}, this function allows you to specify multiple values
to be replaced with \code{NA} at the same time.
\itemize{
\item \code{na_if_in()} replaces values that match its arguments with \code{NA}.
\item \code{na_if_not()} replaces values that \emph{do not} match its arguments with \code{NA}.
}
}
\section{Formulas}{

These functions accept one-sided formulas that can evaluate to logical
vectors of the same length as \code{x}.
The input is represented in these conditional statements as "\code{.}".
Valid formulas take the form \code{~ . < 0}.
See examples.
}

\examples{
x <- sample(c(1:5, 99))
# We can replace 99...
# ... explicitly
na_if_in(x, 99)
# ... by specifying values to keep
na_if_not(x, 1:5)
# ... or by using a formula
na_if_in(x, ~ . > 5)

messy_string <- c("abc", "", "def", "NA", "ghi", 42, "jkl", "NULL", "mno")
# We can replace unwanted values...
# ... one at a time
clean_string <- na_if_in(messy_string, "")
clean_string <- na_if_in(clean_string, "NA")
clean_string <- na_if_in(clean_string, 42)
clean_string <- na_if_in(clean_string, "NULL")
clean_string
# ... or all at once
na_if_in(messy_string, "", "NA", "NULL", 1:100)
na_if_in(messy_string, c("", "NA", "NULL", 1:100))
na_if_in(messy_string, list("", "NA", "NULL", 1:100))
# ... or using a clever formula
grepl("[a-z]{3,}", messy_string)
na_if_not(messy_string, ~ grepl("[a-z]{3,}", .))

# na_if_in() is particularly useful inside dplyr::mutate
library(dplyr)
faux_census \%>\%
  mutate(
    state = na_if_in(state, "Canada"),
    age   = na_if_in(age, ~ . < 18, ~ . > 120)
  )

# This function handles vector values differently than dplyr,
# and returns a different result with vector replacement values:
na_if_in(1:5, 5:1)
dplyr::na_if(1:5, 5:1)
}
\seealso{
\code{\link[dplyr:na_if]{dplyr::na_if()}} to replace a single value with \code{NA}.

\code{\link[dplyr:coalesce]{dplyr::coalesce()}} to replace missing values with a specified value.

\code{\link[tidyr:replace_na]{tidyr::replace_na()}} to replace \code{NA} with a value.

\code{\link[dplyr:recode]{dplyr::recode()}} and \code{\link[dplyr:case_when]{dplyr::case_when()}} to more generally replace
values.
}
