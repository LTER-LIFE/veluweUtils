# Scripts to create package data (stored in /data)
# Create look-up table that matches scope ids from create_veluwe() to names of the national parks
# as used in the national park dataset at PDOK

library(tibble)
library(usethis)

np_lookup <- tibble::tibble(
  scope = c("nphv", "npvz"),
  naam = c("De Hoge Veluwe", "Veluwezoom")
)

usethis::use_data(np_lookup, overwrite = TRUE)
