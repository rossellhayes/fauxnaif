test_that("scalar y replaces all matching x", {
  x <- c(0, 1, 0)
  expect_equal(na_if(x, 0), c(NA, 1, NA))
  expect_equal(na_if(x, 1), c(0, NA, 0))
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
