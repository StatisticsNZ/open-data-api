test_that("Testing slim catalogue", {
  stat_cat <- get_odata_catalogue(slim_df=TRUE)
  expect_equal(ncol(stat_cat), 3)
})


test_that("Testing catalogue", {
  stat_cat <- get_odata_catalogue()
  expect_gt(ncol(stat_cat), 3)
})
