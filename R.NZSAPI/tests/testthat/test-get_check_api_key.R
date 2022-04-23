test_that("Test existing API key works", {
  expect_type(get_api_key(), "character")
})

test_that("Test missing API key throws error", {
  expect_error({
    Sys.unsetenv("nz_stat_api_key")
    get_api_key()
  })
  Sys.setenv("nz_stat_api_key"="eff88e36b46f4a0590382ed95c3e7e31")
})



