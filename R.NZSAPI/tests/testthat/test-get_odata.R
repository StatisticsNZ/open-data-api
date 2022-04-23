test_that("df returned", {
  expect_type(
    get_odata(
      endpoint = "InternationalTravel"
      , entity = "Observations"
      , query_option = "$top100"
    )
    , "list"
  )
})

