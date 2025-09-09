

### Structure:
# 1. Print_separator


# This function prints a separation bar to the console
print_separator <- function(degree=2) {
  if (degree==1) {
    cat("..........................\n")
    
  } else if(degree==2) {
    cat("--------------------------\n")
  } else {
  cat("==========================\n")
  }
}


