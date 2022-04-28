Install package
```R
# devtools::install_github("StatisticsNZ/open-data-api/R.NZSAPI")
library(R.NZSAPI)
```


Find available datasets
```R
(stat_cat <- get_odata_catalogue(slim_df=TRUE))
```

```text
  title                   description                     endpoint
  <chr>                   <chr>                           <chr>  
1 Employment Indicators   This employment indicator...    EmploymentIndicators
2 Overseas Cargo          Overseas cargo records all...   OverseasCargo
3 Covid19 Indicators      Stats NZ's COVID-19 data...     Covid-19Indicators
4 International Migra...  International migration mea...  InternationalMigration
5 Household Labour Fo...  Statistics New Zealand’s q...   HouseholdLabourForceSurvey
6 2018 Census of Pop...   Example aggregates from the...  2018Census-PopulationDwellings
7 Overseas Merchandis...  Overseas Merchandise Trade...   OverseasMerchandiseTrade
8 International Travel    International travel covers...  InternationalTravel
9 National Accounts       The conceptual framework use... NationalAccounts   

```

Using an endpoint from stat_cat to obtain data observations
```R
stat_df <- get_odata(endpoint = stat_cat$endpoint[1])
```
An example using the _query_option_ argument
```R
stat_df <-  get_odata(
  endpoint = stat_cat$endpoint[1]
  , query_option = "
    $filter=(Label2 eq 'Actual' and Duration eq 'P1M')
    &$select=Label1,Label2,Unit,Measure,Value
    &$apply=groupby((Label1,Label2,Unit,Measure)) 
    &$top=10
  "
)
```
_query_option_ sends a _SQL **like**_ argument to the API for finer control on data returned.
               

Get available meta-data (entity) options for each endpoint
```R
stat_ent <- get_odata_entities()
```

Get meta-data on an endpoint
```R
endpoint_metadata <- get_odata(endpoint = stat_cat$endpoint[1], entity = stat_ent$name[1])
```
