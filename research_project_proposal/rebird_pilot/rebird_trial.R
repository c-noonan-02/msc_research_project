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


##### Repeat for Pentland Site #####

# read in Pentland KML file
pentland_site <- st_read("./research_project_proposal/rebird_pilot/data/pentland_site.kml")
# check the file
plot(pentland_site)
# save the bounding box
pentland_bbox <- st_bbox(pentland_site)

# plug bounding box values into the rebird function
pentland_species <- ebirdgeo(
  lat = (pentland_bbox$ymin + pentland_bbox$ymax) / 2,
  lng = (pentland_bbox$xmin + pentland_bbox$xmax) / 2,
  dist = 8
)

# check data
head(pentland_species)




#### auk method ####
library(auk)
library(sf)
library(dplyr)
library(readr)

##### Import Spatial File Using the sf package #####

# import eBird EBD file
ebd_data <- read.csv("./research_project_proposal/rebird_pilot/ebird_data/ebd_data.csv")
View(ebd_data)

# BELOW CODE IS FOR RAW EBD DATASET, IF NEEDING TO FILTER MORE THAN THE OBTAINED DATASET

# # sekect dataset to be filtered
# EBD_filters <- auk_ebd(EBD_file)
# 
# # select filters
# EBD_filters <- EBD_filters %>%
#   auk_date(date = c("2025-01-01", "2025-04-30")) %>% # filter by date - but could do when requesting data anyway
#   auk_country("United Kingdom") %>% # only checklists from UK - should already be done
#   auk_protocol("Stationary") %>% # only stationary surveys, no travelling or incidental etc.
#   auk_complete() # only complete check-lists
# 
# # filter the data
# EBD_filtered_data <- "EBD_data_filtered.txt"
# sampling_filtered <- "sampling_filtered.txt"
# 
# auk_filter(EBD_filters,
#            file = EBD_filtered_data,
#            file_sampling = sampling_filtered,
#            overwrite = TRUE)
# 
# # read the eBird data into R
# braid_burn_species <- read_ebd(EBD_filtered_data)

# read in Pentland KML file - replace with sitefile once made
pentland_site <- st_read("./research_project_proposal/rebird_pilot/data/pentland_site.kml")
# check the file
plot(pentland_site)

# clean the shapefile
pentland_site <- st_make_valid(pentland_site) # removes any invalid geometry

# convert EBD data to an sf object
ebd_sf <- st_as_sf(ebd_data, coords = c("long_coord", "lat_coord"), crs = 4326)

# ensure shapefile matches the CRS used in ebird data (WGS84 (EPSG:4326))
pentland_site <- st_transform(pentland_site, crs = st_crs(ebd_sf))

# filter out any data points in the ebird data that are not within the shapefile
ebd_pentlands <- ebd_sf[st_within(ebd_sf, pentland_site, sparse = FALSE), ]

# convert back to a normal dataframe
ebd_pentlands <- as.data.frame(ebd_pentlands)
head(ebd_pentlands)

# filter (i.e. remove any entries that have not been approved)

# then remove irrelevant column headings
ebd_pentlands <- ebd_pentlands %>%
  select(global_ID, common_name, scientific_name, observation_count, locality, observation_date, observer_ID, sampling_event_ID, geometry)

# extract all unique species observed on site
unique(ebd_pentlands$scientific_name)

# repeat with Baddinsgill site to reality test
