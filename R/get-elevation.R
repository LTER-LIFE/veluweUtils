#' Get elevation data for the Veluwe
#' 
#' @description This function is used to retrieve elevation data from \href{https://www.ahn.nl/}{Actueel Hoogtebestand Nederland} (AHN). AHN provides data as a digital terrain model (DTM) or as a digital surface model (DSM).
#' 
#' @param veluwe \link[sf]{sf} object of the Veluwe. Output from \link{create_veluwe}.
#' @param topo Character indicating the topographic model. Options: "dtm", "dsm". See Details for more info.
#' 
#' @details This function is used to retrieve elevation data from \href{https://www.ahn.nl/}{Actueel Hoogtebestand Nederland} (AHN). AHN provides two products. Both products are a 5 x 5 meter raster, averaged over 50 x 50 cm cells, each of which is assigned a value by interpolating LiDAR aerial survey points using squared inverse distance weighting. More info (in Dutch): \url{https://www.ahn.nl/producten}.
#' 
#' * `dtm`: the digital terrain model (DTM) represents elevation of the elevation of the ground.
#' * `dsm`: the digital surface model (DSM) represents elevation of the tallest surfaces at a point (e.g., trees, buildings).
#' 
#' @returns a spatial raster
#' 
#' @importFrom terra rast
#' @export

get_elevation <-  function(veluwe,
                           topo = c("dtm", "dsm")) {
  
  topo <- rlang::arg_match(topo)
  
  # Instantiate a WCSClient to the elevation dataset at PDOK
  # WCSClient: an R interface to Open Geospatial Consortium (OGC) Web Coverage Service (WCS)
  # PDOK: platform for open geospatial datasets of the Dutch government
  wcs <- ows4R::WCSClient$new(url = "https://service.pdok.nl/rws/ahn/wcs/v1_0?request=GetCapabilities&service=WCS",
                              serviceVersion = "2.0.0")
  
  caps <- wcs$getCapabilities()
  
  # Find id of preferred topographic model
  coverage_ids <- purrr::map_chr(.x = caps$getCoverageSummaries(),
                                 .f = ~{
                                   
                                   .x$CoverageId
                                   
                                 })
  
  topo_id <- coverage_ids[stringr::str_detect(string = coverage_ids, pattern = topo)]
  
  # Parse and build up WCS query in url
  url <- httr::parse_url("https://service.pdok.nl/rws/ahn/wcs/v1_0?request=GetCapabilities&service=WCS")
  
  url$query <- list(service = "wcs",
                    version = "1.0.0", 
                    request = "GetCoverage",
                    coverage = topo_id,
                    crs = paste0("EPSG:", sf::st_crs(veluwe)$epsg),
                    bbox = paste(sf::st_bbox(veluwe), collapse=","),
                    width = "4000",
                    height = "4000",
                    format = "image/tiff")
  
  request <- httr::build_url(url)
  
  # Read spatial raster of evelation data using the Veluwe as a bounding box
  raster <- terra::rast(request)
  
  return(raster)
  
}