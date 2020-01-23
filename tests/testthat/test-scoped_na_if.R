test_that("scoped na_if_* errors when dplyr not installed", {
  with_mock(
    requireNamespace = function(...) FALSE,
    df <- data.frame(a = 0:5, b = as.numeric(5:0)),
    expect_error(na_if_all(df, 0), "Package `dplyr`"),
    expect_error(na_if_at(df, "a", 0), "Package `dplyr`"),
    expect_error(na_if_if(df, is.integer, 0), "Package `dplyr`"),
    expect_error(na_if_not_all(df, 0), "Package `dplyr`"),
    expect_error(na_if_not_at(df, "a", 0), "Package `dplyr`"),
    expect_error(na_if_not_if(df, is.integer, 0), "Package `dplyr`")
  )
})

test_that("scalar argument replaces all matching x", {
  df <- data.frame(a = 0:9, b = as.numeric(9:0))
  expect_equal(
    na_if_all(df, 0),
    data.frame(a = c(NA, 1:9), b = c(9:1, NA))
  )
  expect_equal(
    na_if_at(df, "a", 0),
    data.frame(a = c(NA, 1:9), b = 9:0)
  )
  expect_equal(
    na_if_if(df, is.integer, 0),
    data.frame(a = c(NA, 1:9), b = 9:0)
  )
  expect_equal(
    na_if_not_all(df, 0),
    data.frame(a = c(0, rep(NA, 9)), b = c(rep(NA, 9), 0))
  )
  expect_equal(
    na_if_not_at(df, "a", 0),
    data.frame(a = c(0, rep(NA, 9)), b = 9:0)
  )
  expect_equal(
    na_if_not_if(df, is.integer, 0),
    data.frame(a = c(0, rep(NA, 9)), b = 9:0)
  )
})

test_that("multiple scalar arguments replaces all matching x", {
  df     <- data.frame(a = 0:9, b = as.numeric(0:9))
  target <- c(NA, NA, 2:9)
  expect_equal(na_if_all(df, 0, 1), data.frame(a = target, b = target))
  expect_equal(na_if_at(df, "a", 0, 1), data.frame(a = target, b = 0:9))
  expect_equal(na_if_if(df, is.integer, 0, 1), data.frame(a = target, b = 0:9))
  target <- c(NA, 1:8, NA)
  expect_equal(na_if_all(df, 0, 9), data.frame(a = target, b = target))
  expect_equal(na_if_at(df, "a", 0, 9), data.frame(a = target, b = 0:9))
  expect_equal(na_if_if(df, is.integer, 0, 9), data.frame(a = target, b = 0:9))
  target <- c(0, 1, rep(NA, 8))
  expect_equal(na_if_not_all(df, 0, 1), data.frame(a = target, b = target))
  expect_equal(na_if_not_at(df, "a", 0, 1), data.frame(a = target, b = 0:9))
  expect_equal(
    na_if_not_if(df, is.integer, 0, 1), data.frame(a = target, b = 0:9)
  )
  target <- c(0, rep(NA, 8), 9)
  expect_equal(na_if_not_all(df, 0, 9), data.frame(a = target, b = target))
  expect_equal(na_if_not_at(df, "a", 0, 9), data.frame(a = target, b = 0:9))
  expect_equal(
    na_if_not_if(df, is.integer, 0, 9), data.frame(a = target, b = 0:9)
  )
})

test_that("two-sided formula produces warning", {
  df <- data.frame(a = 0:9, b = as.numeric(0:9))
  expect_warning(na_if_all(df, x ~ . < 1), "must be one-sided")
  expect_warning(na_if_at(df, "a", x ~ . < 1), "must be one-sided")
  expect_warning(na_if_if(df, is.integer, x ~ . < 1), "must be one-sided")
  expect_warning(na_if_not_all(df, x ~ . < 1), "must be one-sided")
  expect_warning(na_if_not_at(df, "a", x ~ . < 1), "must be one-sided")
  expect_warning(na_if_not_if(df, is.integer, x ~ . < 1), "must be one-sided")
})

test_that("non-coercible argument produces warning", {
  df <- data.frame(a = 0:9, b = as.numeric(0:9))
  expect_warning(na_if_all(df, lm(1 ~ 1)), "Argument.*lm")
  expect_warning(na_if_at(df, "a", lm(1 ~ 1)), "Argument.*lm")
  expect_warning(na_if_if(df, is.integer, lm(1 ~ 1)), "Argument.*lm")
  expect_warning(na_if_not_all(df, lm(1 ~ 1)), "Argument.*lm")
  expect_warning(na_if_not_at(df, "a", lm(1 ~ 1)), "Argument.*lm")
  expect_warning(na_if_not_if(df, is.integer, lm(1 ~ 1)), "Argument.*lm")
})

test_that("multiple non-coercible arguments produce multiple warnings", {
  df <- data.frame(a = 0:9, b = as.numeric(0:9))
  expect_warning(na_if_all(df, NULL, lm(1 ~ 1)), "NULL.*lm")
  expect_warning(na_if_at(df, "a", NULL, lm(1 ~ 1)), "NULL.*lm")
  expect_warning(na_if_if(df, is.integer, NULL, lm(1 ~ 1)), "NULL.*lm")
  expect_warning(na_if_not_all(df, NULL, lm(1 ~ 1)), "NULL.*lm")
  expect_warning(na_if_not_at(df, "a", NULL, lm(1 ~ 1)), "NULL.*lm")
  expect_warning(na_if_not_if(df, is.integer, NULL, lm(1 ~ 1)), "NULL.*lm")
})

test_that("no ... produces warning", {
  df <- data.frame(a = 0:9, b = as.numeric(0:9))
  expect_warning(na_if_all(df), "No values")
  expect_warning(na_if_at(df, "a"), "No values")
  expect_warning(na_if_if(df, is.integer), "No values")
  expect_warning(na_if_not_all(df), "No values")
  expect_warning(na_if_not_at(df, "a"), "No values")
  expect_warning(na_if_not_if(df, is.integer), "No values")
})
