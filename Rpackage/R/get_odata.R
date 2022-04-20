#' Call the Statistics NZ open data API
#'
#' @param endpoint A string scaler referencing the service endpoint to be queried.
#' In this case a "service endpoint" can be thought of as a database. Endpoint names
#' can be found in the _endpoint_ column of the dataframe, which is generated using
#' the `get_odata_catalogue()` function.
#' @param entity A string scaler referencing which entity in the data model to be used.
#' There are two options: "Observations" or "Resources".
#' Observations returns actual data observations relevant to your query.
#' Resources returns metadata associated with your query.
#' @param query_option A query string used to filter and aggregate results. Refer to
#' [Github](https://github.com/StatisticsNZ/open-data-api/blob/main/Example-R-requests.md)
#' for examples.
#'
#' @return A dataframe.
#' @export
#'
#' @examples
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
