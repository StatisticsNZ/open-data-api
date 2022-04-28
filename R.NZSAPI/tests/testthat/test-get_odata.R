test_that("100 row df returned", {
  tmp_df <- get_odata(endpoint = "InternationalTravel", entity = "Observations")
  expect_type(tmp_df, "list")
  expect_equal(nrow(tmp_df), 1000)
})

