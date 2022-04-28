#' Get catalogues available for each endpoint
#'
#' @return A dataframe.
#' @export
#'
#' @examples
#' (stat_entities <- get_odata_entities())
#'
#'
get_odata_entities <- function() {

  # Get & check api key
  api_key <- get_api_key()

  # Get catalogues
  catalogues <- get_odata_catalogue(slim_df=TRUE)$endpoint

  # Get entities
  entities <- purrr::map_df(
    catalogues
    , ~ dplyr::bind_cols(
      list("endpoint"=.x)
      , get_odata(endpoint = .x, entity = "", query_option = "")
    )
  )
}
