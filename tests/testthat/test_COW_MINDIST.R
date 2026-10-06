# Test if the dataset meets the many packages universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", distance[["COW_MINDIST"]])))
  expect_false(any(grepl("^N/A$", distance[["COW_MINDIST"]])))
  expect_false(any(grepl("^\\s$", distance[["COW_MINDIST"]])))
  expect_false(any(grepl("^\\.$", distance[["COW_MINDIST"]])))
  expect_false(any(grepl("N\\.A\\.$", distance[["COW_MINDIST"]])))
  expect_false(any(grepl("n\\.a\\.$", distance[["COW_MINDIST"]])))
})

# Date columns should be in mdate class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(distance[["COW_MINDIST"]])))
  expect_false(any(lubridate::is.POSIXct(distance[["COW_MINDIST"]])))
  expect_false(any(lubridate::is.POSIXlt(distance[["COW_MINDIST"]])))
})
