test_that("scalar argument replaces all matching x", {
  expect_equal(na_if(0:9, 0), c(NA, 1:9))
  expect_equal(na_if(0:9, 1), c(0, NA, 2:9))
})

test_that("multiple scalar arguments replaces all matching x", {
  expect_equal(na_if(0:9, 0, 1), c(NA, NA, 2:9))
  expect_equal(na_if(0:9, 0, 9), c(NA, 1:8, NA))
})

test_that("formula argument replaces all matching x", {
  expect_equal(na_if(0:9, ~ . < 2), c(NA, NA, 2:9))
  expect_equal(na_if(0:9, ~ . >= 8), c(0:7, NA, NA))
})

test_that("non-vector x produces error", {
  expect_error(na_if(mean, 0), "`mean` cannot")
  expect_error(na_if(lm(1 ~ 1), 0), "`lm(1 ~ 1)` cannot", fixed = TRUE)
  expect_error(na_if(~ . < 0, 0), "`~. < 0` cannot", fixed = TRUE)
})

test_that("coercible non-vector x does not produce error", {
  expect_equal(na_if(list(0, 1), 0), list(NA, 1))
})

test_that("two-sided formula produces warning", {
  expect_warning(na_if(0:9, x ~ . < 1), "Formula arguments must be one-sided")
})

test_that("non-coercible argument produces warning", {
  expect_warning(na_if(0:9, mean), "`mean` unused")
  expect_warning(na_if(0:9, lm(1 ~ 1)), "`lm(1 ~ 1)` unused", fixed = TRUE)
})

test_that("multiple non-coercible arguments produce multiple warnings", {
  expect_warning(na_if(0:9, mean, lm(1 ~ 1)), "`mean` unused")
  expect_warning(na_if(0:9, mean, lm(1 ~ 1)), "`lm(1 ~ 1)` unused", fixed = TRUE)
})

test_that("single argument produces warning", {
  expect_warning(na_if(0:9), "No values to replace with `NA` specified")
})

test_that("na_if_in() aliases na_if()", {
  expect_equal(na_if(0:9, 0, 1), na_if_in(0:9, 0, 1))
})
