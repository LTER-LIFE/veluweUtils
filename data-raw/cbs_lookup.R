# Script to create look-up table `cbs_lookup`
# Look-up table matches scope ids from `create_veluwe()` to feature names 
# in CBS statistical area dataset at PDOK, and the names of the administrative areas.

# Load packages
library(tibble)
library(usethis)

# Create look-up table
cbs_lookup <- tibble::tibble(
  scope = c("corop", "quarter"),
  feature = c("coropgebied_gegeneraliseerd", "gemeente_gegeneraliseerd"),
  name = list("Veluwe", 
              c("Apeldoorn", "Barneveld", "Ede", "Elburg", "Epe", "Ermelo", "Harderwijk", "Hattem",
                "Heerde", "Nijkerk", "Nunspeet", "Oldebroek", "Putten", "Scherpenzeel", "Voorst",
                "Wageningen", "Renkum", "Arnhem", "Rozendaal", "Rheden", "Brummen")
  )
)

usethis::use_data(cbs_lookup, overwrite = TRUE)