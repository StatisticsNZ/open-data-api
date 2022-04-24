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
get_odata <- function(endpoint, entity="Observations", query_option="") {

  # Get & check api key
  api_key <- get_api_key()

  # Limit to 1000 obs if "$top=<num>" is not defined
  if(!stringr::str_detect(query_option, "top=\\d+") & !stringr::str_detect(deparse(sys.calls())[[1]], "get_odata_entities")){
    message("No row limit set. Returning top 1000 observations.")
    query_option <- paste0(query_option, "$top=1000")
  }

  # Function inner variables
  odata_url <- utils::URLencode(paste0("https://api.stats.govt.nz/opendata/v1/", endpoint, "/", entity, "?", query_option))
  num_obs <- grepl("$top", query_option, fixed=TRUE)

  # continue getting results while there are additional pages
  while (!is.null(odata_url)) {
    result <- httr::GET(
      odata_url
      , httr::use_proxy(url = curl::ie_get_proxy_for_url("https://api.stats.govt.nz/opendata/v1"), auth = "any", username = "")
      , httr::add_headers(.headers = c("Content-Type" = "application/json;charset=UTF-8", "Ocp-Apim-Subscription-Key" = api_key))
      , httr::timeout(60)
    )

    # catch errors
    if (httr::http_type(result) != "application/json") stop("API did not return json. Try decreasing the number of observations requested.", call. = FALSE)

    if (httr::http_error(result)) {
      stop(
        sprintf(
          "The request failed - %s \n%s \n%s "
          , httr::http_status(result)$message
          , jsonlite::fromJSON(httr::content(result, "text"))$value
          , odata_url
        )
        , call. = FALSE
      )
    }

    # parse and concatenate result while retaining UTF-8 encoded characters
    parsed <- jsonlite::fromJSON(httr::content(result, "text", encoding = "UTF-8"), flatten = TRUE)
    response  <- rbind(parsed$value, if(exists("response")) response)
    odata_url <- parsed$'@odata.nextLink'
    cat("\r", nrow(response), "obs retrieved")

    # break when top(n) obs are specified
    if (num_obs) break
  }

  structure(response, comment = "Odata response")
}



