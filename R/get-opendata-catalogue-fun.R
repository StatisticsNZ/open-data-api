
library("tidyverse")
library("httr")
library("jsonlite")

# function to call the stats nz open data catalogue

get_odata_catalogue <-  function(service, endpoint, service_api_key) {
  
catalogue_url <- URLencode(paste0(service, "/", endpoint))

# Add the proxy authentication
config_proxy <- use_proxy(
  url = curl::ie_get_proxy_for_url(service), 
  auth = "any", 
  username = ""
)

# Look at the available tables
opendata_catalogue <- 
  GET(
  url = catalogue_url,
  config_proxy,
  add_headers(.headers = c('Cache-Control' = 'no-cache',
                           'Ocp-Apim-Subscription-Key' = service_api_key)),
  timeout(60)
) %>%
  content(as = "text") %>%
  fromJSON()

opendata_catalogue <- as.data.frame(opendata_catalogue$dataset) %>%
  unnest_longer(distribution)


structure(opendata_catalogue,
          comment = "Odata Catalogue")

}
