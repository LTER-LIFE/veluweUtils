#' Look-up table for names of national parks on the Veluwe
#'
#' @description Look-up table to be used in \link{create_veluwe} in case the user selected one of the two national parks on the Veluwe. Table matches the scope ids to the name of the national park in the PDOK dataset.
#'
#' @format A data frame with {2} rows and {2} variables:
#' \describe{
#'   \item{scope}{Character indicating the id of the geographic scope of the Veluwe as used in \link{create_veluwe}}
#'   \item{name}{Character indicating the name of national park as used in the PDOK dataset.}
#' }
#' @source data-raw/np_lookup.R
"np_lookup"

#' Look-up table for CBS statistical areas on the Veluwe
#'
#' @description Look-up table to be used in \link{create_veluwe} in case the user selected one of the two administrative scopes of the Veluwe. Table matches the scope ids to the feature names in the CBS dataset and the names of the administrative aras.
#'
#' @format A data frame with {2} rows and {3} variables:
#' \describe{
#'   \item{scope}{Character indicating the id of the geographic scope of the Veluwe as used in \link{create_veluwe}}
#'   \item{feature}{Character indicating the name of the feature in CBS dataset at PDOK.}
#'   \item{name}{Character vector indicating the names of administrative areas.}
#' }
#' @source data-raw/cbs_lookup.R
"cbs_lookup"