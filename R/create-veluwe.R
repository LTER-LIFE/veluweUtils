#' Create geospatial objects of the Veluwe
#' 
#' @description This function is used to create geospatial objects of the Veluwe.  
#' 
#' @param scope Character indicating the desired geospatial scope of the Veluwe. Options: "natura2000", "concave", "corop", "quarter", "nphv". See Details for more info.
#' 
#' @details This function is used to create a geospatial (or geometry) object of the Veluwe. There are multiple options:
#' 
#' * `natura2000`: The Veluwe Natura2000 area. Natura 2000 is a network of nature protection areas in the European Union. The Veluwe is the largest Natura 2000 area in the Netherlands on land. It consists of sites that are classified under the Birds Directive and Habitat Directive. More info: \url{https://biodiversity.europa.eu/natura2000/en/natura2000}
#' * `concave`: A concave hull of the Veluwe Natura2000 area. A concave hull is a concave polygon containing all the line segments of the Natura2000 area. Consider it the minimum outer smooth of the Natura2000 area.
#' * `corop`: The Veluwe COROP region. COROP is the NUTS-3 statistical classification of the Netherlands, which is used for statistical and demographic purposes. It comprises the natural areas as well as socio-economic areas that are considered part of the Veluwe.
#' * `quarter`: The Veluwe Quarter was one of four quarters in the Duchy of Guelders. It comprises the Veluwe COROP region plus five municipalities that make up the Veluwezoom (from west to east: Renkum, Arnhem, Rozendaal, Rheden, Brummen).
#' * `nphv`: De Hoge Veluwe National Park, a privately owned area that is part of the Natura2000 area.
#' 

create_veluwe <- function(scope) {
  
  
  
}