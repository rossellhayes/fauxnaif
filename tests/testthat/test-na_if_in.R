test_that("scalar argument replaces all matching x", {
  expect_equal(na_if_in(0:9, 0), c(NA, 1:9))
  expect_equal(na_if_in(0:9, 1), c(0, NA, 2:9))
})

test_that("multiple scalar arguments replaces all matching x", {
  expect_equal(na_if_in(0:9, 0, 1), c(NA, NA, 2:9))
  expect_equal(na_if_in(0:9, 0, 9), c(NA, 1:8, NA))
})

test_that("formula argument replaces all matching x", {
  expect_equal(na_if_in(0:9, ~ . < 2), c(NA, NA, 2:9))
  expect_equal(na_if_in(0:9, ~ . >= 8), c(0:7, NA, NA))
})

test_that("non-vector x produces error", {
  expect_error(na_if_in(mean, 0), "input `mean`")
  expect_error(na_if_in(lm(1 ~ 1), 0), "input `lm(1 ~ 1)`", fixed = TRUE)
  expect_error(na_if_in(~ . < 0, 0), "input `~. < 0`", fixed = TRUE)
})

test_that("coercible non-vector x does not produce error", {
  expect_equal(na_if_in(list(0, 1), 0), list(NA, 1))
})

test_that("two-sided formula produces warning", {
  expect_warning(na_if_in(0:9, x ~ . < 1), "Formula arguments must be one-sided")
})

test_that("non-coercible argument produces warning", {
  expect_warning(na_if_in(0:9, mean), "`mean` unused")
  expect_warning(na_if_in(0:9, lm(1 ~ 1)), "`lm(1 ~ 1)` unused", fixed = TRUE)
})

test_that("multiple non-coercible arguments produce multiple warnings", {
  expect_warning(na_if_in(0:9, mean, lm(1 ~ 1)), "`mean` unused")
  expect_warning(na_if_in(0:9, mean, lm(1 ~ 1)), "`lm(1 ~ 1)` unused", fixed = TRUE)
})

test_that("single argument produces warning", {
  expect_warning(na_if_in(0:9), "No values to replace with `NA` specified")
})
