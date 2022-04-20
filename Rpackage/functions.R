

# Environ -----------------------------------------------------------------

required_packages <- c("tidyr", "httr", "jsonlite", "stringr", "dplyr")

## Load required packages. Install if not already
suppressMessages({
  lapply(required_packages, FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }) 
})

if(Sys.getenv("nz_stat_api_key")=="") message("System variable 'nz_stat_api_key' is not set in /HOME/.Renviron file.")

# get-odata-fun -----------------------------------------------------------
# function to call the stats nz open data api
get_odata <- function(endpoint, entity, query_option) {
  
  # Function inner variables
  odata_url <- URLencode(paste0("https://api.stats.govt.nz/opendata/v1/", endpoint, "/", entity, "?", query_option))
  top_query <- grepl("$top", query_option, fixed=TRUE)
  
  # continue getting results while there are additional pages
  while (!is.null(odata_url)) {
    result <- GET(
      odata_url
      , use_proxy(url = curl::ie_get_proxy_for_url("https://api.stats.govt.nz/opendata/v1"), auth = "any", username = "")
      , add_headers(.headers = c("Content-Type" = "application/json;charset=UTF-8", "Ocp-Apim-Subscription-Key" = Sys.getenv("nz_stat_api_key")))
      , timeout(60)
    )
    
    # catch errors
    if (http_type(result) != "application/json") stop("API did not return json", call. = FALSE)
    
    if (http_error(result)) {
      stop(
        sprintf(
          "The request failed - %s \n%s \n%s "
          , http_status(result)$message
          , fromJSON(content(result, "text"))$value
          , odata_url
        )
        , call. = FALSE
      )
    }
    
    # parse and concatenate result while retaining UTF-8 encoded characters
    parsed <- jsonlite::fromJSON(content(result, "text", encoding = "UTF-8"), flatten = TRUE)
    response  <- rbind(parsed$value, if(exists("response")) response)
    odata_url <- parsed$'@odata.nextLink'
    cat("\r", nrow(response), "obs retrieved")
    
    # break when top(n) obs are specified
    if (top_query) break
  }
  
  structure(response, comment = "Odata response")
}


# get-odata-catalogue-fun -------------------------------------------------
# function to call the stats nz open data catalogue
get_odata_catalogue <- function(slim_df=FALSE) {

    # Look at the available tables
  opendata_catalogue <- GET(
      url = "https://api.stats.govt.nz/opendata/v1/data.json"
      , use_proxy(url = curl::ie_get_proxy_for_url("https://api.stats.govt.nz/opendata/v1"), auth = "any", username = "")
      , add_headers(.headers = c('Cache-Control' = 'no-cache', 'Ocp-Apim-Subscription-Key' = Sys.getenv("nz_stat_api_key")))
      , timeout(60)
    ) %>%
    content(as = "text") %>%
    fromJSON()
  
  opendata_catalogue <- as.data.frame(opendata_catalogue$dataset) %>%
    unnest_longer(distribution) %>% 
    mutate(endpoint = str_remove(identifier, "https://api.stats.govt.nz/odata/v1/"))
  
  if(slim_df==TRUE) opendata_catalogue <- select(opendata_catalogue, title, description, endpoint)
  structure(opendata_catalogue, comment = "Odata Catalogue")
}

