###
# Project: Gender differences in job satisfaction among university graduates
# Purpose: Meta-file
# Author:
# Date:  01/09/2025
####

# Install the packages
install <- FALSE
if (install) {
  source("code/packages.R")
}


# 1. Create folder structure -----------------------

# List the folder names
folders <- c("code", "results", "documentation", "text", "raw", "data")

# Create the folders
for (folder in folders) {
  print(folder)
  if (!dir.exists(folder)) {
    dir.create(folder)
  }
  
  cat("Folgender Ordner wurde erstellt:", folder, "\n")
}

# 2. Run the code files ---------------------------

# Load the SOEP-data from K:
source("code/01_load_data.R")

# Cleans SOEP data
source("code/02_clean_data.R")


### END ###########################################