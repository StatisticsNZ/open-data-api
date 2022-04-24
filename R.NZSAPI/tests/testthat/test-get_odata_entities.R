test_that("Test entity dataframe returned", {
  tmp_df <- get_odata_entities()
  expect_type(tmp_df, "list")
})
