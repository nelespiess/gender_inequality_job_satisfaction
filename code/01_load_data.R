###
# Project: Gender differences in job satisfaction among university graduates
# Purpose: Load data
# Author:
# Date:  01/09/2025
####

library(haven)
library(stringr)
library(beepr)

## Structure:
# Load the data

# Set the path to Soep files
path_soep39 <- "K:/Soep/Soep_V39"
path_soep_data <- file.path(path_soep39, "STATA/SOEP-CORE.v39eu_Stata/Stata_DE/soepdata")

# List all the soep files
soep_files <- list.files(path_soep_data, pattern=".dta$")

# Load the soep files
for (file in soep_files) {
  
  # Remove the file extension
  old_filename <- str_remove(file, ".dta$")
  new_filename <- paste0(old_filename, ".rds")
  
  cat(old_filename, "\n")
  
  if (new_filename %in% list.files("raw")) {
    cat("File already exists!\n")
    
  } else {
    
    # Load the STATA-files
    tmp <- haven::read_dta(file.path(path_soep_data, file))
    
    # Save the STATA files
    saveRDS(tmp, file = file.path("raw", new_filename))
    
    # Remove the file from the environment
    rm(tmp)
    
  }
}

# Load the raw SOEP files ---------------------------

path_soep_raw <- file.path(path_soep39, "STATA/SOEP-CORE.v39eu_Stata/Stata_DE/soepdata/raw")

# Load the file names
soep_raw_files <- list.files(path_soep_raw)


for (file in soep_raw_files) {
  
  # Remove the file extension
  old_filename <- str_remove(file, ".dta$")
  new_filename <- paste0(old_filename, ".rds")
  
  cat(old_filename, "\n")
  
  if (new_filename %in% list.files("raw")) {
    
    cat("File already exists!\n")
    
  } else {
    
    # Load the STATA-files
    tmp <- haven::read_dta(file = file.path(path_soep_raw, file))
    
    # Save the STATA files
    saveRDS(tmp, file = file.path("raw", new_filename))
    
    # Remove the file from the environement
    rm(tmp)
    
  }
}

beep(1)

### END ####################################