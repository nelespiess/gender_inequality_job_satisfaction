###
# Project: Gender differences in job satisfaction among university graduates
# Purpose: Load data
# Author:
# Date:  01/09/2025
####

library(haven)
library(stringr)

## Structure:
# Load the data

# Set the path to Soep files
path_soep39 <- "K:/Soep/Soep_V39"
path_soep_data <- file.path(path_soep39, "STATA/SOEP-CORE.v39eu_Stata/Stata_DE/soepdata")

# List all the soep files
soep_files <- list.files(path_soep_data)

# Load the soep files
for (file in soep_files) {
  print(file)
  tmp <- haven::read_dta(file.path(path_soep_data, file))
  #assign(str_remove(file, ".dta$"), df)
  save(tmp, file = file.path("raw", paste0(str_remove(file, ".dta$"), ".Rda")))
  rm(tmp)
}


### END ####################################