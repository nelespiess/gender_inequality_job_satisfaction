###
# Project: Gender differences in job satisfaction among university graduates
# Purpose: Clean the data
# Author:
# Date:  01/09/2025
####

# List the files
datafiles <- list.files("raw")

source("code/functions.R")


# Functions =========================================

# List paths
list.paths <- function(path) {
  list.files(path=path, full.names=TRUE)
}



# Funktion that summarises a data frame
describe_df <- function(df, selfmade=TRUE) {
  
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
  
  
  if(!is.data.frame(df)) stop("Input must be a data.frame object!")
  
  if (selfmade) {
    
  print_separator()
  
  # 1. Dimensions of the data
  cat("Dimensions: Rows= ", nrow(df), "; Columns= ", ncol(df), "\n")
  
  print_separator()
  
  # 2. Variable names
  col_names <- names(df)
  print(col_names)
  
  print_separator()
  
  # 3. Data-formats
    # Creat containers
    other_vars <- logic_vars <- char_vars <- num_vars <- 0
    
    for (var in col_names) {
      type_var <- class(df[[var]][1])
      if(type_var== "numeric") {
        num_vars <- num_vars + 1
      } else if (type_var== "character") {
        char_vars <- char_vars + 1
      } else if (type_var == "logical") {
        logic_vars <- logic_vars + 1
      } else {
        other_vars <- other_vars + 1
      }
    }
    
    cat("Numeric variables:", num_vars, "\n")
    cat("Character variables:", char_vars, "\n")
    cat("Logical variables:", logic_vars, "\n")
    cat("Other variables:", other_vars, "\n")
    
  print_separator()
  
  # 4 Missings
  cat("Missings:", paste0(col_names, ": ",  round(colMeans(is.na(df)) * 100, 2), "%\n"))
  
  } else {
    
    str(df)
  }
}


# Look at the data
describe_df(df=biojob)

# Investigate the values of the variable -> negative values might be missings
unique(biojob$inteduc4)

# Recode negative values to missings
biojob_na <- biojob
biojob_na[biojob<0] <- NA

# Look at the data again
describe_df(biojob_na)

# 1. Bioedu ---------------------------------------

# Load the data
bioedu <- readRDS("raw/bioedu.rds")

# What are the dimensions of the data?
dim(bioedu)

# What are the column names?
names(bioedu)

# Exists each individual only ones? no!
sum(duplicated(bioedu$pid))

# What is the distribution of university graduates?
table(bioedu$bex8cert)
mean(bioedu$bex8cert>0)

# Extract the ids of university graduates
pid_graduates <- bioedu$pid[bioedu$bex8cert>0]

# 2. Biojob ------------------------------------

# Load the biojob data
biojob <- readRDS("raw/biojob.rds")

# Filter the jobs of the graduates
biojob$university_graduate <- ifelse(biojob$pid%in%pid_graduates, 1, 0)

# Plot the distribution
dist <- as.data.frame(prop.table(table(prestige=biojob$isei88, graduate=biojob$university_graduate), 2)*100)

dist <- dist[!(dist$prestige%in%c("-2", "-1")), ]

# Plot the prestige by graduate
plot(x=dist$prestige[dist$graduate==0], y=dist$Freq[dist$graduate==0], ylim=c(0, 30), type="l", col="red")
lines(x=dist$prestige[dist$graduate==1], y=dist$Freq[dist$graduate==1], col="blue")
legend(legend=c("Non-graduates", "Graduates"), lty=1, col=c("red", "blue"))

### END #########################################