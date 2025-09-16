### 

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
plot(log(df_wealth$real_estate), log(df_wealth$value_vehicles),
     xlab="Real estate", ylab="Value cars")

# Correlations
cor(x=log(df_wealth$real_estate), y=log(df_wealth$value_vehicles), method="pearson", na.rm=T)

# Inference statistics -------------------------------



### END ##############################################