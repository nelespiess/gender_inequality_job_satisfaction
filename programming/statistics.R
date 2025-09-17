### 

library(ggplot2)
library(stargazer)
library(gtsummary)
library(texreg)


# Load the graphic scheme
source("code/graphic_scheme.R")

options(scipen=999)

# Load the wealth data
df_wealth <- readRDS("raw/pwealth.rds")

### ===========================================

Modes <- function(x) {
  ux <- unique(x)
  tab <- tabulate(match(x, ux))
  ux[tab == max(tab)]
}

describe_center <- function(x) {
  list(mean = mean(x, na.rm=T), median=median(x, na.rm=T), mode=Modes(x))
}

describe_variation <- function(x) {
  list(sd = sd(x, na.rm=T), variance = var(x, na.rm=T))
}

## Functions -----------------------------------------

# real estate market value a = e0100a

df_wealth$real_estate <- df_wealth$e0100a

# Descriptive statistics -----------------------------

# Lage-Maße
describe_center(log(df_wealth$real_estate))

# Range
range(df_wealth$real_estate)
max(df_wealth$real_estate)

# Quantile
quantile(df_wealth$real_estate, probs = seq(0, 1, by = 0.25), include.lowest=T)

# Histogram
ggplot(df_wealth, aes(x=real_estate)) +
  geom_histogram() +
  geom_vline(xintercept = quantile(df_wealth$real_estate, probs = seq(0, 1, by = 0.25), include.lowest=T)
) +
  geom_vline(xintercept=as.numeric(describe_center(df_wealth$real_estate)), col="red") +
  scale_x_log10() 


# Streuungsmaße
describe_variation(df_wealth$real_estate)

# Correlations =======================================

# Look at the vehicles
df_wealth$value_vehicles <- df_wealth$v0100a

# Plot the relationship
plot(df_wealth$real_estate, df_wealth$value_vehicles,
     xlab="Real estate", ylab="Value cars")

# Correlations
cor(x=log(df_wealth$real_estate),
    y=log(df_wealth$value_vehicles), 
    method="pearson", use="na.or.complete")

# Inference statistics -------------------------------

# Create the log values
df_wealth$log_real_estate <- ifelse(df_wealth$real_estate==0, 0, log(df_wealth$real_estate))
df_wealth$log_value_vehicles <- ifelse(df_wealth$value_vehicles==0, 0, log(df_wealth$value_vehicles))

# Estimate the baseline model
mod1 <- lm(log_value_vehicles ~ log_real_estate, data=df_wealth)

# Create a summary of the model
summary(mod1)

# ADd this to a plot
abline(mod1, lwd=2, col="red")

# Word output
stargazer(mod1, 
          type="text", 
          out = "results/regression_vehicles_realestate.html")

# Create the regression table
wordreg(mod1, file="results/regression_vehicles_realestate.docx")

### END ##############################################