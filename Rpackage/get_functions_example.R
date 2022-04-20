
library(tidyverse)

# get function to make request to service

source(here::here("R", "functions.R"))

(stat_cat <- get_odata_catalogue(slim_df=TRUE))

df <- get_odata(
  endpoint = filter(stat_cat, title == "International Travel")$endpoint
  , entity = "Observations"
  , query_option = "$top10000"
)



