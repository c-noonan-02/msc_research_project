# clear environment
rm(list = ls())


#### rebird method ####
# import packages
library(rebird)
library(sf)

##### Import Spatial File Using the sf package #####

# read in Braid Burn Local Nature Reserve KML file
braid_burn_site <- st_read("./research_project_proposal/rebird_pilot/data/braid_burn_LNR.kml")

# check the file
plot(braid_burn_site)

# save the bounding box
braid_burn_bbox <- st_bbox(braid_burn_site)


##### Extract Species Data Using the rebird package #####

# plug bounding box values into the ebird function
braid_burn_species <- ebirdgeo(
  lat = (braid_burn_bbox$ymin + braid_burn_bbox$ymax) / 2,
  lng = (braid_burn_bbox$xmin + braid_burn_bbox$xmax) / 2,
  dist = 0.6 # diameter of site measured as ~700m on digimaps, but this is the smallest it could handle
)

# check data
head(braid_burn_species)


#### auk method ####
library(auk)

##### Import Spatial File Using the sf package #####

# would need to submit an abstract to eBird for permission for the EBD data set - speak to Ally first

# code below is dummy code until data is obtained

# import eBird EBD file
EBD_file <- "./research_project_proposal/rebird_pilot/data/EBD_data.txt"
# filter the file
EBD_filters <- auk_ebd(EBD_file)

# select filters
EBD_filters <- EBD_filters %>%
  auk_date(date = c("2024-04-01", "2024-06-30")) %>%
  auk_country("United Kingdom") %>%
  auk_protocol("Stationary") %>%
  auk_complete()

# filter the data
EBD_filtered_data <- "EBD_data_filtered.txt"
sampling_filtered <- "sampling_filtered.txt"

auk_filter(EBD_filters,
           file = EBD_filtered_data,
           file_sampling = sampling_filtered,
           overwrite = TRUE)

# read the eBird data into R
braid_burn_species <- read_ebd(EBD_filtered_data)