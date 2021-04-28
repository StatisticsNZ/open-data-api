Find the entities in the service data model

```python

import stats_odata as odata

service = "https://api.stats.govt.nz/opendata/v1"
endpoint = "EmploymentIndicators"
entity = ""
query_option = ""
api_key = "xxxxxxxxxxxxxxxxxxxxx"
proxies = {}

ServiceEntities = odata.get_odata(service, endpoint, entity, query_option, api_key, proxies)

print(ServiceEntities)
```

```text
          name      kind          url
1    Resources EntitySet    Resources
2 Observations EntitySet Observations
```

Using the service entity list, get 10 rows for each entity

```python

service = "https://api.stats.govt.nz/opendata/v1"
endpoint = "EmploymentIndicators"
entity = "Observations" 
query_option = "$select=ResourceID,Period,Duration,Label1,Label2,Value,Unit,Measure,Multiplier&$top=10"
api_key = "xxxxxxxxxxxxxxxxxxxxx"
proxies = {}

Observations = odata.get_odata(service, endpoint, entity, query_option, api_key, proxies)
print(Observations)
```

```text
   ResourceID     Period Duration                     Label1              Label2        Value   Unit        Measure Multiplier
1      MEI1.1 1999-04-30      P1M             All industries              Actual 1454212.0000 Number    Filled jobs          0
2      MEI1.1 1999-04-30      P1M             All industries Seasonally adjusted 1450296.0000 Number    Filled jobs          0
3      MEI1.1 1999-04-30      P1M             All industries Seasonally adjusted    3473.7750    NZD Total earnings          6
4      MEI1.1 1999-04-30      P1M             All industries               Trend 1417940.0000 Number    Filled jobs          0
5      MEI1.1 1999-04-30      P1M Goods-producing industries Seasonally adjusted  295021.0000 Number    Filled jobs          0
6      MEI1.1 1999-04-30      P1M Goods-producing industries Seasonally adjusted     820.1100    NZD Total earnings          6
7      MEI1.1 1999-04-30      P1M Goods-producing industries               Trend  288930.0000 Number    Filled jobs          0
8      MEI1.1 1999-04-30      P1M Goods-producing industries               Trend     832.5339    NZD Total earnings          6
9      MEI1.1 1999-04-30      P1M         Primary industries              Actual   80267.0000 Number    Filled jobs          0
10     MEI1.1 1999-04-30      P1M         Primary industries              Actual     130.7833    NZD Total earnings          6
```

```python
service = "https://api.stats.govt.nz/opendata/v1"
endpoint = "EmploymentIndicators"
entity = "Resources"
query_option = "$select=ResourceID,Title,Var1,Var2,Modified,Frequency&$top=10"
api_key = "xxxxxxxxxxxxxxxxxxxxx"
proxies = {}

Resources = odata.get_odata(service, endpoint, entity, query_option, api_key, proxies)

print(Resources)
```

```text
  ResourceID                                         Title                     Var1      Var2             Modified Frequency
1     MEI1.1 Employment Indicators by published industries MEI Published industries Treatment 2020-09-27T21:45:00Z   Monthly

```

Example use of filtering:

```python
service = "https://api.stats.govt.nz/opendata/v1"
endpoint = "EmploymentIndicators"
entity = "Observations"
query_option = """$filter=(
                        ResourceID eq 'MEI1.1' and
                        Period ge 2020-08-31 and
                        Label2 eq 'Actual' and
                        Duration eq 'P1M'
                          )
                &$select=ResourceID,Period,Duration,Label1,Label2,Value,Unit,Measure,Multiplier
                &$top=10"""
api_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"

Observations = odata.get_odata(service, endpoint, entity, query_option, api_key, proxies)

print(Observations)
```

```text
 ResourceID     Period Duration                     Label1 Label2        Value   Unit        Measure Multiplier
1     MEI1.1 2020-08-31      P1M             All industries Actual   10934.7751    NZD Total earnings          6
2     MEI1.1 2020-08-31      P1M Goods-producing industries Actual  421476.0000 Number    Filled jobs          0
3     MEI1.1 2020-08-31      P1M Goods-producing industries Actual    2298.0504    NZD Total earnings          6
4     MEI1.1 2020-08-31      P1M         Service industries Actual 1662420.0000 Number    Filled jobs          0
5     MEI1.1 2020-08-31      P1M             All industries Actual 2185024.0000 Number    Filled jobs          0
6     MEI1.1 2020-08-31      P1M         Primary industries Actual  101128.0000 Number    Filled jobs          0
7     MEI1.1 2020-08-31      P1M         Primary industries Actual     442.6769    NZD Total earnings          6
8     MEI1.1 2020-08-31      P1M         Service industries Actual    8194.0477    NZD Total earnings          6
```

Example use of groupby: find all unique combination of values for Label1, Label2 and Measure

```R
service = "https://api.stats.govt.nz/opendata/v1"
endpoint = "EmploymentIndicators"
entity = "Observations"
query_option = """$filter=(
                        ResourceID eq 'MEI1.1' and
                        Period ge 2020-08-31 and
                        Label2 eq 'Actual' and
                        Duration eq 'P1M'
                          )
                &$apply=groupby((Label1,Label2,Measure))
                &$top=10"""
api_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"

Observations = odata.get_odata(service, endpoint, entity, query_option, api_key, proxies)

print(Observations)
```

```text
                       Label1              Label2        Measure
1              All industries              Actual    Filled jobs
2              All industries              Actual Total earnings
3              All industries Seasonally adjusted    Filled jobs
4              All industries Seasonally adjusted Total earnings
5              All industries               Trend    Filled jobs
6              All industries               Trend Total earnings
7  Goods-producing industries              Actual    Filled jobs
8  Goods-producing industries              Actual Total earnings
9  Goods-producing industries Seasonally adjusted    Filled jobs
10 Goods-producing industries Seasonally adjusted Total earnings
```