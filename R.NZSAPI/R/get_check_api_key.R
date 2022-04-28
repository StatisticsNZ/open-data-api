#' Get the users NZ Statistics API key
#'
#' @return A string containing the API key.
get_api_key <- function() check_api_key()



#' Check API key exists under the alias 'nz_stat_api_key' in .Renvrion file,
#' and throw error if it doesn't.
#'
#' @return An error or a string containing the API key.
check_api_key <- function(){
  api_key <- Sys.getenv("nz_stat_api_key")
  if(api_key==""){
    stop(
      # Error message
      paste0(
        "API key named 'nz_stat_api_key' not found in ~/.Renviron file.\n"
        ,"Follow instructions in this github link to obtain an API key:\n"
        , "https://github.com/StatisticsNZ/open-data-api"
        , "\n"
        , "Once key is obtained save it as 'nz_stat_api_key' in ~/.Renviron file."
      )
      , call. = FALSE
    )
  }
  api_key
}



