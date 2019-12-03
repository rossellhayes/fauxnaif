test_that("scalar argument replaces all matching x", {
  expect_equal(na_if(0:9, 0), c(NA, 1:9))
  expect_equal(na_if(0:9, 1), c(0, NA, 2:9))
  expect_equal(na_if_not(0:9, 0), c(0, rep(NA, 9)))
  expect_equal(na_if_not(0:9, 1), c(NA, 1, rep(NA, 8)))
})

test_that("no changes made if no matches", {
  expect_equal(na_if(0:9, 10), 0:9)
  expect_message(na_if(0:9, 10), "no replacements were made")
  expect_equal(na_if_not(0:9, 0:9), 0:9)
  expect_message(na_if_not(0:9, 0:9), "no replacements were made")
})

test_that("multiple scalar arguments replaces all matching x", {
  expect_equal(na_if(0:9, 0, 1), c(NA, NA, 2:9))
  expect_equal(na_if(0:9, 0, 9), c(NA, 1:8, NA))
  expect_equal(na_if_not(0:9, 0, 1), c(0, 1, rep(NA, 8)))
  expect_equal(na_if_not(0:9, 0, 9), c(0, rep(NA, 8), 9))
})

test_that("formula argument replaces all matching x", {
  expect_equal(na_if(0:9, ~ . < 2), c(NA, NA, 2:9))
  expect_equal(na_if(0:9, ~ . >= 8), c(0:7, NA, NA))
  expect_equal(na_if_not(0:9, ~ . < 2), c(0, 1, rep(NA, 8)))
  expect_equal(na_if_not(0:9, ~ . >= 8), c(rep(NA, 8), 8, 9))
})

test_that("function argument replaces all matching x", {
  is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) {
    abs(x - round(x)) < tol
  }

  expect_equal(na_if(0:9, min), c(NA, 1:9))
  expect_equal(na_if(0:9, max), c(0:8, NA))
  expect_equal(na_if(c(0, 0.5, 1), is.wholenumber), c(NA, 0.5, NA))
  expect_equal(na_if_not(0:9, min), c(0, rep(NA, 9)))
  expect_equal(na_if_not(0:9, max), c(rep(NA, 9), 9))
  expect_equal(na_if_not(c(0, 0.5, 1), is.wholenumber), c(0, NA, 1))
})

test_that("non-vector x produces error", {
  expect_error(na_if(mean, 0), "Input.*mean")
  expect_error(na_if(lm(1 ~ 1), 0), "Input.*lm")
  expect_error(na_if(~ . < 0, 0), "Input.*0")
  expect_error(na_if_not(mean, 0), "Input.*mean")
  expect_error(na_if_not(lm(1 ~ 1), 0), "Input.*lm")
  expect_error(na_if_not(~ . < 0, 0), "Input.*0")
})

test_that("coercible non-vector x does not produce error", {
  expect_equal(na_if(list(0, 1), 0), list(NA, 1))
  expect_equal(na_if_not(list(0, 1), 0), list(0, NA))
})

test_that("two-sided formula produces warning", {
  expect_warning(na_if(0:9, x ~ . < 1), "must be one-sided")
  expect_warning(na_if_not(0:9, x ~ . < 1), "must be one-sided")
})

test_that("non-coercible argument produces warning", {
  expect_warning(na_if(0:9, lm(1 ~ 1)), "Argument.*lm")
  expect_warning(na_if_not(0:9, lm(1 ~ 1)), "Argument.*lm")
})

test_that("multiple non-coercible arguments produce multiple warnings", {
  expect_warning(na_if(0:9, NULL, lm(1 ~ 1)), "NULL.*lm")
  expect_warning(na_if_not(0:9, NULL, lm(1 ~ 1)), "NULL.*lm")
})

test_that("no ... produces warning", {
  expect_warning(na_if(0:9), "No values to replace with `NA` specified")
  expect_warning(na_if_not(0:9), "No values to replace with `NA` specified")
})

test_that("na_if_in() aliases na_if()", {
  expect_equal(na_if(0:9, 0, 1), na_if_in(0:9, 0, 1))
})
