
# get function to make request to service

source("get-odata-fun.R")


Results <-  Filter(function(x)!all(is.na(x)),
                        get_odata(
                          service = "https://api.stats.govt.nz/opendata/v1",
                          endpoint = "< a service endpoint >",
                          entity = "< an entity in the data model >",
                          query_option = "< a query string >",
                          service_api_key = "< your subscription key >"))


## Example use:
## Get the top 10 observations and resources for the EmploymentIndicators dataset

# Observations <-  Filter(function(x)!all(is.na(x)),
#                         get_odata(
#                           service = "https://api.stats.govt.nz/opendata/v1",
#                           endpoint = "EmploymentIndicators",
#                           entity = "Observations",
#                           query_option = "$top=10",
#                           service_api_key = "< your subscription key >"))
 
 
# Resources <-  Filter(function(x)!all(is.na(x)),
#                      get_odata(
#                        service = "https://api.stats.govt.nz/opendata/v1",
#                        endpoint = "EmploymentIndicators",
#                        entity = "Resources",
#                        query_option = "$top=10",
#                        service_api_key = "< your subscription key >"))