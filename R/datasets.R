#' Look-up table for names of national parks on the Veluwe
#'
#' @description Look-up table to be used in \link{create_veluwe} in case the user selected one of the two national parks on the Veluwe. Table matches the scope ids to the name of the national park in the PDOK dataset.
#'
#' @format A data frame with {2} rows and {2} variables:
#' \describe{
#'   \item{scope}{Character indicating the id of the geographic scope of the Veluwe as used in \link{create_veluwe}}
#'   \item{naam}{Name of }
#' }
#' @source data-raw/create-datasets.R
"np_lookup"