#' Information of available data on the Statistics NZ open data catalogue
#'
#' @param slim_df A boolean TRUE/FALSE argument. When set to __TRUE__ the resultant dataframe
#' only contains columns: _title_, _description_ and _endpoint_ of the available endpoints.
#' Otherwise, all information/metadata is returned. The default argument is set to __FALSE__
#'
#' @return A dataframe
#' @export
#'
#' @examples
get_odata_catalogue <- function(slim_df=FALSE) {

  # Get & check api key
  api_key <- get_api_key()

  # Look at the available tables
  opendata_catalogue <- httr::GET(
    url = "https://api.stats.govt.nz/opendata/v1/data.json"
    , httr::use_proxy(url = curl::ie_get_proxy_for_url("https://api.stats.govt.nz/opendata/v1"), auth = "any", username = "")
    , httr::add_headers(.headers = c('Cache-Control' = 'no-cache', 'Ocp-Apim-Subscription-Key' = api_key))
    , httr::timeout(60)
  ) |>
    httr::content(as = "text") |>
    jsonlite::fromJSON()

  opendata_catalogue <- as.data.frame(opendata_catalogue$dataset) |>
    tidyr::unnest_longer(distribution) |>
    dplyr::mutate(endpoint = stringr::str_remove(identifier, "https://api.stats.govt.nz/odata/v1/"))

  if(slim_df==TRUE) opendata_catalogue <- dplyr::select(opendata_catalogue, title, description, endpoint)
  structure(opendata_catalogue, comment = "Odata Catalogue")
}
