library(stringr)
library(ggplot2)

## Load the data ===============================

# Set the path to Soep files
path_soep_ld <- "K:/Soep/Lehrdatensatz/SOEP-CORE_v33.1i_teaching_stata_en"

# List all the soep files
soep_files <- list.files(path_soep_ld, pattern=".dta$")

# Load the soep-files
for (file in soep_files) {
  
  # Remove the file extension
  old_filename <- str_remove(file, ".dta$")
  new_filename <- paste0(old_filename, ".rds")
  
  cat(old_filename, "\n")
    
    # Load the STATA-files
    tmp <- haven::read_dta(file.path(path_soep_ld, file))
    
    # Save the STATA files
    assign(old_filename, tmp)
    
    # Remove the file from the environment
    rm(tmp)
}


## Data manipulation ========================

## hcomsum: Data from household consume module

hconsum <- as.data.frame(hconsum)

# Take a glimpse at the data
str(hconsum)

# 
hconsum[10:20, c(1, 3)]

hist(hconsum[, "consum1a"], breaks=20)
abline(v=mean(hconsum$consum1a), col="red")

# Select a single column
hconsum[, "consum1a"]
hconsum$consum1a
hconsum[["consum1a"]]

# Filter a single observation
hconsum[1, ]

# Filter several rows
hconsum[1:10, ]

# Remove outliers in consum1a
hconsum <- hconsum[hconsum$consum1a < 2500, ]

## Load hkind data ============================

hkind <- as.data.frame(hkind)

## Merge data 
hh_data <- merge(x=hconsum, y=hkind, by="hhnr", all.x=TRUE, all.y=TRUE)

## Spalten reduzieren
hh_data <- hh_data[, c("hhnr", "consum1a", "hhhgr", "hkzahl")]

## Remove observations with missing values in household size
hh_data <- hh_data[!is.na(hh_data$hhhgr), ]

# Plot seperately by group
hist(hh_data$consum1a[hh_data$hkzahl>2], xlim=c(0, 2000), col="red")
hist(hh_data$consum1a[hh_data$hkzahl<=2], add=T, col="white", breaks=50)


# Changing variables =========================

hh_data$home_food <- NA
hh_data$home_food[hh_data$consum1a<100] <- "low"
hh_data$home_food[hh_data$consum1a>2000] <- "high"
hh_data$home_food[hh_data$consum1a>=100&hh_data$consum1a<=2000] <- "middle"

hh_data$consum1a_new <- hh_data$consum1a
hh_data$consum1a_new[hh_data$consum1a>1000] <- 1000

# Append data ================================

list.files()


# 
lt_aus <- read.table("data/AUS.fltper_1x1.txt", skip=1, header=T)
lt_aut <- read.table("data/AUT.fltper_1x1.txt", skip=1, header=T)

# Filter Geburtenrate age 0
lt_aus_e0 <- lt_aus[lt_aus$Age==0,]

# select Year and Ex
lt_aus_ex <- lt_aus_e0[,c("Year", "ex")]

# Funktion erstellen

clean_lt <- function(lt){
  
  # Filter Geburtenrate age 0
  lt_e0 <- lt[lt$Age==0,]
  
  # select Year and Ex
  lt_ex <- lt_e0[,c("Year", "ex")]
  
  return(lt_ex)
}

clean_lt(lt_aus) 
clean_lt(lt_aut)

# Path hmd
path_hmd <- "U:/data/global/human_mortality_database/lt_female/fltper_1x1"
hmd_files <- list.files(path_hmd, full.names = T)
countries <- str_remove(list.files(path_hmd), ".fltper_1x1.txt$")

for (i in seq_along(hmd_files)) {
  tmp <- read.table(hmd_files[i], header=T, skip=1)
  
  tmp <- clean_lt(tmp)
  
  assign(countries[i], tmp)
}


# Plot
plot(NA, xlim=c(1950, 2025), ylim=c(60, 90),
     xlab="Jahr", ylab="ex")
lines(KOR$Year, KOR$ex)
lines(SWE$Year, SWE$ex)
lines(NOR$Year, NOR$ex)
lines(DEUTNP$Year, DEUTNP$ex, lwd=2)

### END ####################################