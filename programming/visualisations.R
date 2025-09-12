## GGPLOT2 ####################

# Books with GGPLOT2: 
# https://socviz.co/makeplot.html#how-ggplot-works
# https://clauswilke.com/dataviz/

# Videos:
# https://clanfear.github.io/CSSS508/


## Set a thme --------------------

source("code/graphic_scheme.R")

## Line graph --------------------

# Create a line graph
plot_line <- ggplot(data = SWE[SWE$Year>=1750, ], aes(x=Year, y=ex, colour=ex)) +
  geom_line() +
  scale_colour_gradient(low="darkred", high="darkblue") # Make Times new roman font and increase font size

# Make a polar coordinate symstem
plot_line +
  coord_polar()

## Save the plot ========================

# Save a plot
ggsave(filename="results/trend_ex_swe.svg")
ggsave(filename="results/trend_ex_swe.png")

## Balkendiagram ========================

ggplot(data=subset(SWE, Year > 1950), aes(x=Year, y=ex)) +
  geom_col(aes(fill=ex)) + # colour is border, fill is filling
  scale_fill_gradient(low="darkred", high="darkblue")


## Histogram ============================

ggplot(data=SWE, aes(x=ex)) +
  geom_histogram()

## Change the axis ======================

plot_line +
  scale_x_continuous("Year", expand=c(0, 0), breaks=seq(1750, 2050, by=10)) +
  scale_y_continuous("Life expectancy at birth") +
  labs(title="Life expectancy at birt", subtitle="Sweden 1750-2024", caption="Source: Human Mortality Database.")
  theme(
    axis.text.x = element_text(size=8)
  )
  
## Plot two groups =====================
  
DEUTE$country <- "East"
DEUTW$country <- "West"
SWE$country <- "Sweden"
lt <- rbind(DEUTE, DEUTW, SWE)

lts <- mget(ls(pattern="^[A-Z]{3}$"))
lts <- lapply(lts, function(x) apply(x, 2, as.numeric))
lts <- lapply(lts, as.data.frame)
lts <- bind_rows(lts, .id="Country")

# Create legend data
lts_legend <- lts %>% 
  group_by(Country) %>% 
  mutate(last_year = max(Year, na.rm=T)) %>% 
  filter(Year == last_year)

ggplot(data=subset(lts, Year>1960), aes(x=Year, y=ex, group=Country, colour=Country)) +
  geom_line(linewidth=0.8) +
  geom_text(data=lts_legend, aes(label=Country, x=Year+1)) +
  scale_x_continuous(expand=c(0, 0), n.breaks=20) +
  #scale_colour_viridis_d() +
  guides(colour=guide_legend(nrow=3))
  

# As text
ggplot(data=subset(lts, Year>1960), aes(x=Year, y=ex, group=Country, colour=Country)) +
  geom_text(aes(label=Country)) +
  scale_x_continuous(expand=c(0, 0), n.breaks=20) +
  #scale_colour_viridis_d() +
  guides(colour=guide_legend(nrow=3))


ggplot(data=subset(lts, Year>1960), aes(x=Year, y=ex, group=Country)) +
  geom_line(colour="grey") +
  geom_line(data=lts[lts$Country=="PRT"&lts$Year>1960, ], colour="red", lwd=2) +
  geom_text(data=lts[lts$Country=="PRT"&lts$Year==1960, ], aes(x=1963), label="Portugal", hjust="left", colour="red") +
  scale_x_continuous(expand=c(0, 0), n.breaks=20) +
  scale_y_continuous(n.breaks=15)

## END ############################  