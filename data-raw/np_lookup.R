# Script to create look-up table `np_lookup`
# Look-up table matches scope ids from create_veluwe() to names of the national parks
# as used in the national park dataset at PDOK

# Load packages
library(tibble)
library(usethis)

# Create look-up table
np_lookup <- tibble::tibble(
  scope = c("nphv", "npvz"),
  name = c("De Hoge Veluwe", "Veluwezoom")
)

usethis::use_data(np_lookup, overwrite = TRUE)