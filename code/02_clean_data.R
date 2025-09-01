###
# Project: Gender differences in job satisfaction among university graduates
# Purpose: Clean the data
# Author:
# Date:  01/09/2025
####

print("Hello, Nele!")


# List the files
datafiles <- list.files("raw")


# 1. Bioedu ---------------------------------------

# Load the data
bioedu <- readRDS("raw/bioedu.Rda")

# What are the dimensions of the data?
dim(tmp)

# What are the column names?
names(tmp)

# Exists each individual only ones? no!
sum(duplicated(tmp$pid))

# What is the distribution of university graduates?
table(tmp$bex8cert)
mean(tmp$bex8cert>0)

# Extract the ids of university graduates
pid_graduates <- tmp$pid[tmp$bex8cert>0]

# 2. Biojob ------------------------------------

# Load the biojob data
biojob <- readRDS("raw/biojob.Rda")

# Filter the jobs of the graduates
tmp$university_graduate <- ifelse(tmp$pid%in%pid_graduates, 1, 0)

# Plot the distribution
dist <- as.data.frame(prop.table(table(prestige=tmp$isei88, graduate=tmp$university_graduate), 2)*100)

dist <- dist[!(dist$prestige%in%c("-2", "-1")), ]

# Plot the prestige by graduate
plot(x=dist$prestige[dist$graduate==0], y=dist$Freq[dist$graduate==0], ylim=c(0, 30), type="l", col="red")
lines(x=dist$prestige[dist$graduate==1], y=dist$Freq[dist$graduate==1], col="blue")
legend(legend=c("Non-graduates", "Graduates"), lty=1, col=c("red", "blue"))

### END #########################################