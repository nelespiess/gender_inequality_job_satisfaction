###
# Project: Nele Spiess
# Purpose: Meta-file
# Author:
# Date:  01/09/2025
####


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




### END ###########################################