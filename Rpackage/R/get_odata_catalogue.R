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
