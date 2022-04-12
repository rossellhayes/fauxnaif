test_that("scalar argument replaces all matching x", {
  expect_equal(na_if_in(0:9, 0), c(NA, 1:9))
  expect_equal(na_if_in(0:9, 1), c(0, NA, 2:9))
  expect_equal(na_if_not(0:9, 0), c(0, rep(NA, 9)))
  expect_equal(na_if_not(0:9, 1), c(NA, 1, rep(NA, 8)))
})

test_that("no changes made if no matches", {
  expect_equal(na_if_in(0:9, 10), 0:9)
  expect_equal(na_if_not(0:9, 0:9), 0:9)
})

test_that("early return if length == 0", {
  expect_equal(na_if_in(numeric(0), 99), numeric(0))
  expect_equal(na_if_not(numeric(0), ~ . < 10), numeric(0))

  expect_equal(na_if_in(character(0), "NA"), character(0))
  expect_equal(na_if_not(character(0), ~ grepl(., "^[a-z]+$")), character(0))

  expect_equal(na_if_in(NULL, 99), NULL)
  expect_equal(na_if_not(NULL, ~ . < 10), NULL)
})

test_that("multiple scalar arguments replaces all matching x", {
  expect_equal(na_if_in(0:9, 0, 1), c(NA, NA, 2:9))
  expect_equal(na_if_in(0:9, 0, 9), c(NA, 1:8, NA))
  expect_equal(na_if_not(0:9, 0, 1), c(0, 1, rep(NA, 8)))
  expect_equal(na_if_not(0:9, 0, 9), c(0, rep(NA, 8), 9))
})

test_that("formula argument replaces all matching x", {
  expect_equal(na_if_in(0:9, ~ . < 2), c(NA, NA, 2:9))
  expect_equal(na_if_in(0:9, ~ . >= 8), c(0:7, NA, NA))
  expect_equal(na_if_not(0:9, ~ . < 2), c(0, 1, rep(NA, 8)))
  expect_equal(na_if_not(0:9, ~ . >= 8), c(rep(NA, 8), 8, 9))
})

test_that("function argument replaces all matching x", {
  is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) {
    abs(x - round(x)) < tol
  }

  expect_equal(na_if_in(c(0, 0.5, 1), is.wholenumber), c(NA, 0.5, NA))
  expect_equal(na_if_not(c(0, 0.5, 1), is.wholenumber), c(0, NA, 1))
})

test_that("non-vector x produces error", {
  expect_snapshot_error(na_if_in(mean, 0), class = "fauxnaif_uncoercible_input")
  expect_snapshot_error(na_if_not(mean, 0), class = "fauxnaif_uncoercible_input")

  expect_snapshot_error(na_if_in(lm(1 ~ 1), 0), class = "fauxnaif_uncoercible_input")
  expect_snapshot_error(na_if_not(lm(1 ~ 1), 0), class = "fauxnaif_uncoercible_input")

  expect_snapshot_error(na_if_in(~ . < 0, 0), class = "fauxnaif_uncoercible_input")
  expect_snapshot_error(na_if_not(~ . < 0, 0), class = "fauxnaif_uncoercible_input")
})

test_that("if `x_label` is `.`, use `x` instead", {
  withr::local_package("magrittr")
  expect_snapshot_error(mean %>% na_if_in(1:10), class = "fauxnaif_uncoercible_input")
  expect_snapshot_error(mean %>% na_if_not(1:10), class = "fauxnaif_uncoercible_input")
})

test_that("coercible non-vector x does not produce error", {
  expect_equal(na_if_in(list(0, 1), 0), list(NA, 1))
  expect_equal(na_if_not(list(0, 1), 0), list(0, NA))
})

test_that("two-sided formula produces error", {
  expect_snapshot_error(na_if_in(0:9, x ~ . < 1), "fauxnaif_invalid_arguments")
  expect_snapshot_error(na_if_not(0:9, x ~ . < 1), "fauxnaif_invalid_arguments")
})

test_that("non-coercible argument produces error", {
  expect_snapshot_error(na_if_in(0:9, lm(1 ~ 1)), "fauxnaif_invalid_arguments")
  expect_snapshot_error(na_if_not(0:9, lm(1 ~ 1)), "fauxnaif_invalid_arguments")
})

test_that("multiple non-coercible arguments produce errors", {
  expect_snapshot_error(na_if_in(0:9, NULL, lm(1 ~ 1)), "fauxnaif_invalid_arguments")
  expect_snapshot_error(na_if_not(0:9, NULL, lm(1 ~ 1)), "fauxnaif_invalid_arguments")
})

test_that("no ... produces error", {
  expect_snapshot_error(na_if_in(0:9), class = "fauxnaif_no_arguments")
  expect_snapshot_error(na_if_not(0:9), class = "fauxnaif_no_arguments")
})

test_that("function arguments must return logical vectors", {
  expect_snapshot_error(na_if_in(0:9, min), class = "fauxnaif_invalid_functions")
  expect_snapshot_error(na_if_not(0:9, min), class = "fauxnaif_invalid_functions")

  expect_snapshot_error(na_if_in(0:9, max), class = "fauxnaif_invalid_functions")
  expect_snapshot_error(na_if_not(0:9, max), class = "fauxnaif_invalid_functions")

  expect_snapshot_error(na_if_in(1:5, mean), class = "fauxnaif_invalid_functions")
  expect_snapshot_error(na_if_not(1:5, mean), class = "fauxnaif_invalid_functions")
})

test_that("function arguments must return vectors of the same length as `x`", {
  expect_snapshot_error(na_if_in(1:5, ~ TRUE), class = "fauxnaif_invalid_functions")
  expect_snapshot_error(na_if_not(1:5, ~ TRUE), class = "fauxnaif_invalid_functions")
})

test_that("function arguments can generate multiple errors", {
  expect_snapshot_error(na_if_in(1:5, mean, ~ TRUE), class = "fauxnaif_invalid_functions")
  expect_snapshot_error(na_if_not(1:5, mean, ~ TRUE), class = "fauxnaif_invalid_functions")
})

test_that("errors when fauxnaif functions are called in unusual ways", {
  expect_snapshot_error(do.call(na_if_in, list(mean, 0)), class = "fauxnaif_uncoercible_input")
  expect_snapshot_error(do.call(na_if_in, list(0, lm(1 ~ 1))), class = "fauxnaif_invalid_arguments")
  expect_snapshot_error(do.call(na_if_in, list(0, mean)), class = "fauxnaif_invalid_functions")

  expect_snapshot_error(lapply(1:10, na_if_in, mean), class = "fauxnaif_invalid_functions")
  expect_snapshot_error(lapply(1:10, na_if_in, lm(1 ~ 1)), class = "fauxnaif_invalid_arguments")
  expect_snapshot_error(lapply(1:10, na_if_in, x = mean), class = "fauxnaif_uncoercible_input")
})

test_that("coercible argument does not produce error", {
  expect_equal(na_if_in(0:9, list(0, 1)), c(NA, NA, 2:9))
  expect_equal(na_if_not(0:9, list(0, 1)), c(0, 1, rep(NA, 8)))
})

test_that("with haven_labelled", {
  x <- haven::labelled(
    c(1:3, 98, 99),
    labels = c(a = 1, b = 2, c = 3, DK = 98, Refused = 99)
  )

  expect_equal(na_if_in(x, 99), c(1:3, 98, NA), ignore_attr = TRUE)
  expect_equal(na_if_in(x, 98, 99), c(1:3, NA, NA), ignore_attr = TRUE)
  expect_equal(na_if_not(x, 1:3), c(1:3, NA, NA), ignore_attr = TRUE)
  expect_equal(na_if_in(x, ~ . > 3), c(1:3, NA, NA), ignore_attr = TRUE)
  expect_equal(na_if_not(x, ~ . <= 3), c(1:3, NA, NA), ignore_attr = TRUE)
})

test_that("examples", {
  x <- c(1:5, 99)
  target <- c(1:5, NA)
  expect_equal(na_if_in(x, 99), target)
  expect_equal(na_if_not(x, 1:5), target)
  expect_equal(na_if_in(x, ~ . > 5), target)

  messy_string <- c("abc", "", "def", "NA", "ghi", 42, "jkl", "NULL", "mno")
  target <- c("abc", NA, "def", NA, "ghi", NA, "jkl", NA, "mno")

  clean_string <- na_if_in(messy_string, "")
  clean_string <- na_if_in(clean_string, "NA")
  clean_string <- na_if_in(clean_string, 42)
  clean_string <- na_if_in(clean_string, "NULL")
  expect_equal(clean_string, target)

  expect_equal(na_if_in(messy_string, "", "NA", "NULL", 1:100), target)
  expect_equal(na_if_in(messy_string, c("", "NA", "NULL", 1:100)), target)
  expect_equal(na_if_in(messy_string, list("", "NA", "NULL", 1:100)), target)
  expect_equal(na_if_not(messy_string, ~ grepl("[a-z]{3,}", .)), target)
})
