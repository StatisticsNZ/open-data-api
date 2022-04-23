
library(tidyverse)
library(devtools)
library(testthat)
# create_package(here::here("Rpackage"))

map(c("get_odata_catalogue", "get_odata"), use_r)
load_all()
# use_mit_license()
document()
use_testthat()
map(c("get_odata_catalogue", "get_odata", "get_check_api_key"), use_test)
map(c("tidyr", "httr", "jsonlite", "stringr", "dplyr"), use_package)

check()

install()
library(R.NZSAPI)

# Write function to get entities for each end point
# Fix query_option row limiter. Set default to 1000 rows.

(stat_cat <- get_odata_catalogue(slim_df=FALSE))

get_odata_entities()

df <- get_odata(
  endpoint = filter(stat_cat, title == "International Travel")$endpoint
  , query_option = "$top10000"
)


# TEsT --------------------------------------------------------------------

library("httr")
library("jsonlite")


# function to call the stats nz open data api

get_odata <-  function(service, endpoint, entity, query_option, service_api_key) {

  config_proxy <- use_proxy(
    url = curl::ie_get_proxy_for_url(service),
    auth = "any",
    username = ""
  )

  odata_url <- URLencode(paste0(service, "/", endpoint, "/", entity, "?", query_option))
  top_query <- grepl("$top",query_option,fixed=TRUE)

  # continue getting results while there are additional pages

  while (!is.null(odata_url)) {

    result <- GET(odata_url,
                  config_proxy,
                  add_headers(.headers = c("Content-Type" = "application/json;charset=UTF-8",
                                           "Ocp-Apim-Subscription-Key" = service_api_key)),
                  timeout(60)
    )


    # catch errors

    if (http_type(result) != "application/json") {
      stop("API did not return json", call. = FALSE)
    }


    if (http_error(result)) {
      stop(
        sprintf(
          "The request failed - %s \n%s \n%s ",
          http_status(result)$message,
          fromJSON(content(result, "text"))$value,
          odata_url
        ),
        call. = FALSE
      )
    }


    # parse and concatenate result while retaining UTF-8 encoded characters

    parsed <- jsonlite::fromJSON(content(result, "text", encoding = "UTF-8"), flatten = TRUE)
    response  <- rbind(parsed$value, if(exists("response")) response)
    odata_url <- parsed$'@odata.nextLink'


    cat("\r", nrow(response), "obs retrieved")

    # break when top(n) obs are specified

    if (top_query) {
      break
    }

  }

  structure(response,
            comment = "Odata response")

}


ServiceEntities <-  Filter(function(x)!all(is.na(x)),
                     get_odata(
                       service = "https://api.stats.govt.nz/opendata/v1",
                       endpoint = "NationalAccounts",
                       entity = "",
                       query_option = "",
                       service_api_key = Sys.getenv("nz_stat_api_key")))

print(ServiceEntities)
