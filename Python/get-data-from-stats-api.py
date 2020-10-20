# -*- coding: utf-8 -*-

# get modules
import stats_odata as odata

# setup variables

service = "https://api.stats.govt.nz/opendata/v1"

endpoint = "< a service endppoint >"
entity = "< an entity in the data model >"
query_option = "< a query string >"

api_key = "< your subsription key >"
proxies = {'https': '< your proxy host >:< proxy port >'} 

# call the service
df = odata.get_odata(service, endpoint, entity, query_option, api_key, proxies)


# Example use:
# Get the top 10 observations and resources for the EmploymentIndicators dataset
#
#
# Top 10 Observations
#
# service = 'https://api.stats.govt.nz/opendata/v1'
# endpoint = 'EmploymentIndicators'
# entity = 'Observations' 
# query_option = "$top=10"
#
# api_key = "< your subsription key >"
# proxies = {'https': 'your-proxy.co.nz:8080'}  ## proxies = {} if none
#
# Observations = odata.get_odata(service, endpoint, entity, query_option, api_key, proxies)
#
#
# Top 10 Resources
#
# service = 'https://api.stats.govt.nz/opendata/v1'
# endpoint = 'EmploymentIndicators'
# entity = 'Resources' 
# query_option = "$top=10"
#
# api_key = "< your subsription key >"
# proxies = {'https': 'your-proxy.co.nz:8080'}  ## proxies = {} if none
#
# Resources = odata.get_odata(service, endpoint, entity, query_option, api_key, proxies)