# Test if the dataset meets the many packages universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", regimes[["UNGA"]])))
  expect_false(any(grepl("^N/A$", regimes[["UNGA"]])))
  expect_false(any(grepl("^\\s$", regimes[["UNGA"]])))
  expect_false(any(grepl("^\\.$", regimes[["UNGA"]])))
  expect_false(any(grepl("N\\.A\\.$", regimes[["UNGA"]])))
  expect_false(any(grepl("n\\.a\\.$", regimes[["UNGA"]])))
})

# Date columns should be in mdate class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(regimes[["UNGA"]])))
  expect_false(any(lubridate::is.POSIXct(regimes[["UNGA"]])))
  expect_false(any(lubridate::is.POSIXlt(regimes[["UNGA"]])))
})
