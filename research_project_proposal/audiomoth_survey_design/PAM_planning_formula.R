# clear environment
rm(list=ls())

# load required packages
library(dplyr)
library(readr)

# import table 3 from Winiarksa, Szymanski and Osiejuk (2024)
european_bird_data <- read.csv("data/Winiarska_et_al_2024_table3.csv")
View(european_bird_data)

# create a new column that represents the radius of detection range at the highest probability available (i.e. either 0.95 or 0.90)
# do this using the coalesce() function to extract the first non-missing value from a set of columns
european_bird_data <- european_bird_data %>%
  mutate(deciduous_detection_distance = coalesce(prob_0.95, prob_0.9, prob_0.8, prob_0.5, prob_0.2, prob_0.1, prob_0.05))
head(european_bird_data)

# extract data for a new dataframe, which will store the values needed to calculate the PAM planning formula 
european_bird_planning <- subset(european_bird_data, select = c(species, deciduous_territory_radius_min, deciduous_detection_distance))
colnames(european_bird_planning) <- c("species", "deciduous_t", "deciduous_d")
head(european_bird_planning)

# check if radius of home ranges is greater than the radius of detection ranges
european_bird_planning <- european_bird_planning %>%
  mutate(condition = ifelse(deciduous_t > deciduous_d, "t > d", "t < d"))
head(european_bird_planning)

# then calculate the recommended distance between recording devices (D)
european_bird_planning <- european_bird_planning %>%
  mutate(deciduous_D = ifelse(condition == "t > d", 4*deciduous_d, 3*deciduous_d))
head(european_bird_planning)

# check the minimum, non-NA recommended deciduous_D for this subset of species
min(european_bird_planning$deciduous_D, na.rm = TRUE)

# save the final dataframe to project files
write_csv(european_bird_planning, "data/PAM_recommended_distances.csv")
