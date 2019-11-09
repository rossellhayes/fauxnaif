test_that("scalar y replaces all matching x", {
  x <- c(0, 1, 0)
  expect_equal(na_if(x, 0), c(NA, 1, NA))
  expect_equal(na_if(x, 1), c(0, NA, 0))
})
