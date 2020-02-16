# fauxnaif 0.5.6

* Scoped na_if_*() functions now call an internal function
  fauxnaif:::scoped_na_if() to reduce repeated code.

# fauxnaif 0.5.5

* Refactored scoped na_if_*() to only message when no replacements are made in
  in entire data frame. Previously, a message would be generated for each column
  in which no replacements were made.

# fauxnaif 0.5.4

* Changed all instances of `sapply()` to `vapply()` or `lapply()` for type
  stability.

# fauxnaif 0.5.3

* Moved package imports from "Depends" to "Imports" for cleaner loading.

# fauxnaif 0.5.2

* Included magrittr pipe.

# fauxnaif 0.5.1

* Rewrote scoped na_if_* functions to use only exported dplyr functions.

# fauxnaif 0.5.0

* Added support for function arguments.
* Complete rewrite of underlying implementation function.

# fauxnaif 0.4.1

* Added unit tests for scoped functions.

# fauxnaif 0.4.0

* Added scoped variants of `na_if()` and `na_if_not()` based on scoped
  `dplyr::mutate_*()` functions.

# fauxnaif 0.3.0

* Added a `NEWS.md` file to track changes to the package.
