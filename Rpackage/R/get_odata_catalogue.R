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
