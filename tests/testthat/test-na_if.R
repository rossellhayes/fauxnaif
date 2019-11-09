test_that("scalar argument replaces all matching x", {
  x <- rep(0:1, 2)
  expect_equal(na_if(x, 0), c(NA, 1, NA, 1))
  expect_equal(na_if(x, 1), c(0, NA, 0, NA))
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
  expect_error(na_if(mean, 0), "Input `x` cannot be coerced to a vector")
  expect_error(na_if(lm(1 ~ 1), 0), "Input `x` cannot be coerced to a vector")
  expect_error(na_if(~ . < 0, 0), "Input `x` cannot be coerced to a vector")
})

test_that("two-sided formula produces error", {
  expect_error(na_if(0:9, x ~ . < 1), "Formula arguments must be one-sided")
})

test_that("non-coercible argument produces error", {
  expect_error(na_if(0:9, mean))
  expect_error(na_if(0:9, lm(1 ~ 1)))
})

test_that("single argument produces warning", {
  expect_warning(na_if(0:9), "No values to replace with `NA` specified")
})
