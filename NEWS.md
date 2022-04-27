# fauxnaif 0.7.0

-   `na_if_in()` and `na_if_not()` now support `vctrs` classes like `haven_labelled`.
-   Function arguments must now return logical vectors of the same length as `x`.
-   `fauxnaif` no longer throws warnings. Situations that previously produced a warning now produce an error:
    -   If no arguments are passed to `...`.
    -   If any arguments passed to `...` are not coercible to a vector or a function.
-   Removed deprecated `fauxnaif::na_if()` and scoped `na_if_*()` functions.
-   Added `pkgdown` URL to `DESCRIPTION`.
-   Added `inst/CITATION`.

# fauxnaif 0.6.1

-   Replace argument `input` with `x`.
-   Advance `fauxnaif::na_if()` and scoped `na_if_*()` functions from `deprecate_soft()` to `deprecate_warn()`.
-   Only warn `fauxnaif::na_if()` is deprecated if arguments could not be handled by `dplyr::na_if()`.
-   Added `pkgdown` site.
-   Remove `inst/CITATION`.

# fauxnaif 0.6.0

-   No longer produce a warning when no replacements are made.
-   Deprecate scoped na_if() functions and suggest replacing them with `dplyr::across()`.
-   Deprecate `fauxnaif::na_if()` and suggest replacing it with `na_if_in()`.

# fauxnaif 0.5.6

-   Initial CRAN release.
-   Scoped na_if\_\*() functions now call an internal function fauxnaif:::scoped_na_if() to reduce repeated code.

# fauxnaif 0.5.5

-   Refactored scoped na_if\_\*() to only message when no replacements are made in in entire data frame. Previously, a message would be generated for each column in which no replacements were made.

# fauxnaif 0.5.4

-   Changed all instances of `sapply()` to `vapply()` or `lapply()` for type stability.

# fauxnaif 0.5.3

-   Moved package imports from "Depends" to "Imports" for cleaner loading.

# fauxnaif 0.5.2

-   Included magrittr pipe.

# fauxnaif 0.5.1

-   Rewrote scoped na_if\_\* functions to use only exported dplyr functions.

# fauxnaif 0.5.0

-   Added support for function arguments.
-   Complete rewrite of underlying implementation function.

# fauxnaif 0.4.1

-   Added unit tests for scoped functions.

# fauxnaif 0.4.0

-   Added scoped variants of `na_if()` and `na_if_not()` based on scoped `dplyr::mutate_*()` functions.

# fauxnaif 0.3.0

-   Added a `NEWS.md` file to track changes to the package.
