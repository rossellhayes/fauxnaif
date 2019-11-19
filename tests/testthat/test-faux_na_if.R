test_that("scalar argument replaces all matching x", {
  expect_equal(faux_na_if(0:9, 0), na_if(0:9, 0))
  expect_equal(faux_na_if(0:9, 1), na_if(0:9, 1))
})

test_that("multiple scalar arguments replaces all matching x", {
  expect_equal(faux_na_if(0:9, 0, 1), na_if(0:9, 0, 1))
  expect_equal(faux_na_if(0:9, 0, 9), na_if(0:9, 0, 9))
})

test_that("formula argument replaces all matching x", {
  expect_equal(faux_na_if(0:9, ~ . < 2), na_if(0:9, ~ . < 2))
  expect_equal(faux_na_if(0:9, ~ . >= 8), na_if(0:9, ~ . >= 8))
})

test_that("coercible non-vector x does not produce error", {
  expect_equal(faux_na_if(list(0, 1), 0), na_if(list(0, 1), 0))
})
