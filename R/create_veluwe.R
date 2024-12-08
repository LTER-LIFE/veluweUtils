#' Create geospatial sf objects of the Veluwe
#' 
#' @description This function is used to create geospatial \link[sf]{sf} objects of the Veluwe.  
#' 
#' @param scope Character indicating the preferred geospatial scope of the Veluwe. Options: "natura2000", "concave", "corop", "quarter", "nphv", "npvz". See Details for more info.
#' 
#' @details This function is used to create a geospatial \link[sf]{sf} object of the Veluwe. There are multiple options:
#' 
#' * `natura2000`: The Veluwe Natura2000 area. Natura 2000 is a network of nature protection areas in the European Union. The Veluwe is the largest Natura 2000 area in the Netherlands on land. It consists of sites that are classified under the Birds Directive and Habitat Directive. More info: \url{https://biodiversity.europa.eu/natura2000/en/natura2000}
#' * `concave`: A concave hull of the Veluwe Natura2000 area. A \href{https://postgis.net/docs/ST_ConcaveHull.html}{concave hull} is a concave polygon containing all the line segments of the Natura2000 area. Consider it the minimum outer smooth of the Natura2000 area.
#' * `corop`: The Veluwe COROP region. \href{https://en.wikipedia.org/wiki/COROP}{COROP} is the \href{https://ec.europa.eu/eurostat/web/nuts}{NUTS} level-3 statistical classification of the Netherlands, which is used for statistical and demographic purposes. It comprises the natural areas as well as socio-economic areas that are considered part of the Veluwe.
#' * `quarter`: The \href{https://en.wikipedia.org/wiki/Veluwe_Quarter}{Veluwe Quarter} was one of four quarters in the Duchy of Guelders. It comprises the Veluwe COROP region plus five municipalities that make up the Veluwezoom (from west to east: Renkum, Arnhem, Rozendaal, Rheden, Brummen).
#' * `nphv`: De Hoge Veluwe National Park, a privately owned area that is part of the Natura2000 area. More info: \url{https://www.hogeveluwe.nl/en/}
#' * `npvz`: Veluwezoom National Park, the oldest national park of the Netherlands and owned by Natuurmonumenten. More info: \url{https://en.wikipedia.org/wiki/Veluwezoom_National_Park}
#'
#' @returns a \link[sf]{sf} object
#'
#' @examples
#' rlang::check_installed(c("ggplot2"))
#' 
#' nphv <- create_veluwe(scope = "nphv")
#' 
#' ggplot2::ggplot() +
#'   ggplot2::geom_sf(data = nphv)
#'
#' @import concaveman
#' @import httr
#' @import ows4R
#' @import sf
#' @importFrom dplyr filter
#' @importFrom rlang arg_match .data
#' @export

create_veluwe <- function(scope = c("natura2000", "concave", "corop", 
                                    "quarter", "nphv", "npvz")) {
  
  scope <- rlang::arg_match(scope)
  
  if(scope == "nphv" | scope == "npvz") {
    
    # Instantiate a WFSClient to the national parks dataset at PDOK
    # WFSClient: an R interface to Open Geospatial Consortium (OGC) Web Feature Service (WFS)
    # PDOK: platform for open geospatial datasets of the Dutch government
    wfs <- ows4R::WFSClient$new(url = "https://service.pdok.nl/rvo/nationaleparken/wfs/v2_0?request=GetCapabilities&service=WFS",
                                serviceVersion = "2.0.0")
    
    caps <- wfs$getCapabilities()
    
    # Retrieve name of geometry object that holds Dutch national parks
    feature_name <- caps$getFeatureTypes(pretty = TRUE)$name
    
    # Parse and build up WFS query for national parks in url
    url <- httr::parse_url("https://service.pdok.nl/rvo/nationaleparken/wfs/v2_0?request=GetCapabilities&service=WFS")
    
    url$query <- list(service = "wfs",
                      version = "2.0.0",
                      request = "GetFeature",
                      outputFormat = "application/json",
                      typeName = feature_name)
    
    request <- httr::build_url(url)
    
    # Read geojson object of either of the national parks
    cat("Reading geojson of", veluweUtils::np_lookup |> 
          dplyr::filter(.data$scope == {{scope}}) |> 
          dplyr::pull(.data$name) ,"National Park...")
    output <- sf::st_read(request) |>
      dplyr::left_join(veluweUtils::np_lookup, by = c("naam" = "name")) |> 
      dplyr::filter(.data$scope == {{scope}})
    
  }
  
  if(scope == "natura2000" | scope == "concave") {
    
    wfs <- ows4R::WFSClient$new(url = "https://service.pdok.nl/rvo/natura2000/wfs/v1_0?request=getcapabilities&service=wfs",
                                serviceVersion = "2.0.0")
    
    caps <- wfs$getCapabilities()
    
    # Retrieve name of geometry object that holds Dutch Natura2000 areas
    feature_name <- caps$getFeatureTypes(pretty = TRUE)$name
    
    # Parse and build up WFS query for Natura2000 areas in url
    url <- httr::parse_url("https://service.pdok.nl/rvo/natura2000/wfs/v1_0?request=getcapabilities&service=wfs")
    
    url$query <- list(service = "wfs",
                      version = "2.0.0",
                      request = "GetFeature",
                      outputFormat = "application/json",
                      typeName = feature_name)
    
    request <- httr::build_url(url)
    
    # Read geosjon object of the Veluwe Natura2000
    cat("Reading geojson of Natura2000...")
    output <- sf::read_sf(request) |> 
      dplyr::filter(.data$naamN2K == "Veluwe")
    
    if(scope == "concave") {
      
      cat("Creating concave hull of Natura2000...")
      output <- output |> 
        sf::st_combine() |> 
        sf::st_cast("POINT") |> 
        sf::st_sf() |> 
        concaveman::concaveman(concavity = 1.6)
      
    }
    
  }
  
  if(scope == "corop" | scope == "quarter") {
    
    # Parse and build up WFS query for CBS statistical areas in url
    url <- httr::parse_url("https://service.pdok.nl/cbs/gebiedsindelingen/2024/wfs/v1_0?request=GetCapabilities&service=WFS")
    
    url$query <- list(service = "wfs",
                      version = "1.0.0",
                      request = "GetFeature",
                      outputFormat = "application/json",
                      typeName = veluweUtils::cbs_lookup |> 
                        dplyr::filter(.data$scope == {{scope}}) |> 
                        dplyr::pull(.data$feature))
    
    request <- httr::build_url(url)
    
    # Read geosjon object of the Veluwe administrative areas
    cat("Reading geojson of administrative areas...")
    output <- sf::st_read(request) |> 
      dplyr::filter(.data$statnaam %in% {veluweUtils::cbs_lookup |> 
          dplyr::filter(.data$scope == {{scope}}) |> 
          dplyr::pull(.data$name) |> 
          unlist()})
    
    if(scope == "quarter") {
      
      # Combine municipalities into one `sf` object
      output <- sf::st_union(output)
      
    }
  
  }
  
  return(output)
  
}
