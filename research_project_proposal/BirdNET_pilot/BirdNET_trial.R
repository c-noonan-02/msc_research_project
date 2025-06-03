# clear environment
rm(list = ls())

# install the package
install.packages("devtools")

# Load the reticulate package to set up an environment
library(reticulate)

# set conda environment
use_condaenv("birdnet-env", required = TRUE)

# load birdNET
library(birdnetR)

# Try running a simple test to check BirdNET setup
birdnet_check_setup()



# see available python versions to install
install_python(list = TRUE)
reticulate::install_miniconda()

# install older version
install_python(version = "3.10.13")

reticulate::use_python("C:/Users/charl/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Python 3.11/Python 3.11 (64-bit).lnk")

install.packages("tensorflow")
tensorflow::install_tensorflow()

install_birdnet()


# Initialize a BirdNET model
model <- birdnet_model_tflite()

# Path to the audio file (replace with your own file path)
audio_path <- system.file("extdata", "soundscape.mp3", package = "birdnetR")

# Predict species within the audio file
predictions <- predict_species_from_audio_file(model, audio_path)

# Get most probable prediction within each time interval
get_top_prediction(predictions)
