library(httr)
library(jsonlite)


# Example -
# Get Overseas Merchandise Trade descriptor labels 
#  using the experimental Aria API

# All classification descriptor labels are sourced from the
#   StatsNZ Concept/Classification Management System (http://aria.stats.govt.nz/aria/)

# Request an Aria API access key at aria.admins@stats.govt.nz
#   and ask for: test user access to try via swagger using
#   (https://aria.stats.govt.nz/aria-api/login), or
#   application access using an API key (as per example below)

# Note: Access provided is temporary and will eventually
#   be replaced by a free subscription service 

# Note: The full list of descriptor URL's for a given service can be found in
#   the service entity 'Descriptors' e.g.
# https://api.stats.govt.nz/odata/v1/OverseasMerchandiseTrade/Descriptors



# URL for NZ harmonised system classification
url <-
  "http://aria.stats.govt.nz/aria-api/api/classification/UXevYDdQWwxPgyWx/categories"

# URL for NZ standard country classification 2 alpha
#url <-
#  "http://aria.stats.govt.nz/aria-api/api/classification/YZG4ox6LDG5A8kvh/categories"

# URL for Trade entry code
# url <-
#  "http://aria.stats.govt.nz/aria-api/api/classification/CARS6740/categories"


# using one of the example url's, get descriptors using a requested API-KEY
r <- GET(url,
         add_headers(
           .headers = c("Accept" = "application/json", "X-API-KEY" = "< your Aria API KEY >")
         ))

# return code and descriptor for specified classification
descriptors <-
  jsonlite::fromJSON(content(r, "text", encoding = "UTF-8"), flatten = TRUE)
descriptors <- descriptors$'@graph'
descriptors <- descriptors[c("code", "descriptor")]


#
# Example - Find all 'released' (i.e.current) descriptor label url's for the
# Overseas Merchandise Trade service
# 

# Setup query url -
# return the 'released' (i.e.current) versions of the classification
query_url <- URLencode(
  "https://api.stats.govt.nz/odata/v1/OverseasMerchandiseTrade/Descriptors?$filter=(Status eq 'Released')"
)


omt_descriptor_url <-
  GET(query_url,
      add_headers(
        .headers = c("Accept" = "application/json", "Ocp-Apim-Subscription-Key" =
                       "< your Open Data API KEY >")
      ))

omt_descriptor_url <-
  jsonlite::fromJSON(content(omt_descriptor_url, "text", encoding = "UTF-8"),
                     flatten = TRUE)

omt_descriptor_url  <- omt_descriptor_url$value

                            