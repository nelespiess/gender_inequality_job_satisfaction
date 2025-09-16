### Uebung Visualisations (ggplot) =====================================

install.packages("ggplot2")
library(ggplot2)

# relevant df: merge_data (pl + bioedu), merge_reg (merge_data + regionl)

### Load Data -----------------------------------------------------

pl
bioedu
regionl

cbPalette <- c("#999999", "#E69F00", "#009E73", "#0072B2", "#D55E00", "#CC79A7")

### Changing of important variables -------------------------------

## Sex

pl$sex <- ifelse(pl$pla0009_h==1, "male", "female")

## Leadership Position 

pl$leadership <- ifelse(pl$plb0067==1, "Yes", "No" )

## working hours

# Creating a combined working hours variable
pl$working_hours <- ifelse(pl$syear<2019, pl$plb0176_h, pl$plb0176_v5)

# Create working time breakets
pl$working_hours_cat <- cut(pl$working_hours,
                            breaks = c(0, 15, 25, 30, 42, 80), 
                            labels = c("gering", "halb", "dreiviertel", "voll", "workaholic"),
                            include.lowest = T)
table(pl$working_hours, pl$working_hours_cat, useNA="always")

## merge dataframe -----------------------------------------------------

merge_data <- merge(x=pl, y=bioedu, by=c("pid", "cid"), all.x=TRUE, all.y=TRUE)
merge_data <- merge_data[, c("pid", "cid", "syear", "plh0173", "pla0009_h", "bex8cert","plb0176_v5", "working_hours_cat", "plb0067", "working_hours")]


# with regionl df

merge_reg <-  merge(x=merge_data, y=regionl, by = c("cid", "syear"), all.x = TRUE, all.y = TRUE)
merge_reg <- merge_reg[, c("cid", "pid", "syear", "plh0173", "pla0009_h", "bex8cert", "bula_ew", "plb0176_v5", "working_hours_cat", "plb0067")]


# Visualisation job satisfaction and different variables =================

# Mean job satisfaction --------------------------------------------------

mean_data <- aggregate(plh0173 ~ syear + pla0009_h, data = merge_data[merge_data$plh0173 >= 0 & merge_data$pla0009_h>0, ], FUN = mean, na.rm = TRUE)

# ggplot

ggplot(mean_data, aes(x = syear, y = plh0173)) +
  geom_line(color = "darkblue", lwd=1) + 
  labs(x = "Year", y = "Mean Job Satisfaction", title = "Mean Job Satisfaction Germany over time") +
  scale_x_continuous(expand= c(0,0)) +
  theme_minimal() +
  theme (
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5), 
    text = element_text(family = "serif"),
    plot.title = element_text(size = 14, face = "bold"), 
    axis.title.x = element_text(size = 12, face = "bold"), 
    axis.title.y = element_text(size = 12, face = "bold")
  )

ggsave("U:/gender_inequality_job_satisfaction-main/results/mean_job_satisfaction.pdf")

## Job Satisfaction and graduates -------------------------

merge_reg$graduates <- NA
merge_reg$graduates[merge_data$bex8cert==-2] <- "No Tertiary Degree"
merge_reg$graduates[merge_data$bex8cert==1] <- "Applied University"
merge_reg$graduates[merge_data$bex8cert==2] <- "University"
merge_reg$graduates[merge_data$bex8cert==3] <- "Doctorate"
merge_reg$graduates[merge_data$bex8cert==4] <- "Vocational College"
merge_reg$graduates[merge_data$bex8cert==5] <- "Other"
table(merge_reg$graduates, useNA = "always")


mean_grad <- aggregate(plh0173 ~ syear + graduates, data = merge_reg[merge_reg$plh0173 >= 0, ], FUN = mean, na.rm=TRUE)
  

ggplot(data=mean_grad, aes(x = syear, y = plh0173, group = graduates, colour = graduates)) +
  geom_line(lwd=1.5) + 
  labs (x = "Year", y = "Mean Job Satisfaction", title = "Mean Job Satisfaction Germany Over Time by Tertiary Degree", colour = "Tertiary Degree") +
  scale_colour_manual(values = cbPalette) +
  scale_x_continuous(expand= c(0,0)) +
  theme_minimal() +
  theme (
    panel.border = element_rect(color = "black", fill = NA, size = 0.5), 
    text = element_text(family = "serif"),
    plot.title = element_text(size = 14, face = "bold"), 
    axis.title.x = element_text(size = 12, face = "bold"), 
    axis.title.y = element_text(size = 12, face = "bold")
  )

ggsave("U:/gender_inequality_job_satisfaction-main/results/mean_job_satisfaction_tertiary_degree.pdf")

# Graduates and Gender

ggplot(data = merge_reg,
       aes(x = sex, fill = graduates)) + 
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "Sex", y = "Percentage", fill = "Tertiary Degree", title = "Differences in Tertiary Degree by Sex") + 
  theme_minimal() + 
  theme (
    panel.border = element_rect(color = "black", fill = NA, size = 0.5), 
    text = element_text(family = "serif"),
    plot.title = element_text(size = 14, face = "bold"), 
    axis.title.x = element_text(size = 12, face = "bold"), 
    axis.title.y = element_text(size = 12, face = "bold")
  )


## Job Satisfaction and gender ----------------------------


# Convert factor and labels

mean_data$pla0009_h <- factor(mean_data$pla0009_h, levels = c(1,2), labels = c("Male", "Female"))

# ggplot

ggplot(data = mean_data, aes(x = syear, y = plh0173, group = pla0009_h, colour = pla0009_h))+
  geom_line(lwd=1) + 
  labs (x = "Year", y = "Mean Job Satisfaction", title = "Mean Job Satisfaction Germany Over Time by Sex", colour = "Sex") +
  scale_x_continuous(expand= c(0,0)) +
  scale_colour_manual (values=c("darkblue", "darkred")) +
  theme_minimal() +
  theme (
    panel.border = element_rect(color = "black", fill = NA, size = 0.5), 
    text = element_text(family = "serif"),
    plot.title = element_text(size = 14, face = "bold"), 
    axis.title.x = element_text(size = 12, face = "bold"), 
    axis.title.y = element_text(size = 12, face = "bold")
  )

ggsave("U:/gender_inequality_job_satisfaction-main/results/mean_job_satisfaction_gender.pdf")

## Job Satisfaction and regional differences --------------

mean_reg <- aggregate(plh0173 ~ syear + bula_ew, data = merge_reg[merge_reg$plh0173 >= 0 & merge_reg$bula_ew>0, ], FUN = mean, na.rm = TRUE)

mean_reg$bula_ew <- factor(mean_reg$bula_ew, levels = c(21,22), labels = c("West", "East"))

ggplot(data = mean_reg, aes(x = syear, y = plh0173, group = bula_ew, colour = bula_ew)) +
  geom_line(lwd = 1) +
  labs(x = "Year", y = "Mean Job Satisfaction", title = "Mean Job Satisfaction Germany Over Time by region", colour = "Region") +
  scale_x_continuous(expand= c(0,0)) +
  scale_colour_manual (values=c("darkblue", "darkred")) +
  theme_minimal() +
  theme (
    panel.border = element_rect(color = "black", fill = NA, size = 0.5), 
    text = element_text(family = "serif"),
    plot.title = element_text(size = 14, face = "bold"), 
    axis.title.x = element_text(size = 12, face = "bold"), 
    axis.title.y = element_text(size = 12, face = "bold")
  )

ggsave("U:/gender_inequality_job_satisfaction-main/results/mean_job_satisfaction_regional.pdf")

## Job Satisfaction and Leadership Position ---------------

mean_lead <- aggregate(plh0173 ~ syear + plb0067, data = merge_reg[merge_reg$plh0173>=0 & merge_reg$plb0067>0, ], FUN = mean, na.rm = TRUE)

mean_lead$plb0067 <- factor(mean_lead$plb0067, levels = c(1,2), labels = c("Yes", "No"))

ggplot(data = mean_lead, aes(x = syear, y = plh0173, group = plb0067, colour = plb0067)) +
  geom_line(lwd = 1) +
  labs(x = "Year", y = "Mean Job Satisfaction", title = "Mean Job Satisfaction Germany Over Time by Leadership Position", colour = "Leadership Position") +
  scale_x_continuous(expand= c(0,0)) +
  scale_colour_manual (values=c("darkblue", "darkred")) +
  theme_minimal() +
  theme (
    panel.border = element_rect(color = "black", fill = NA, size = 0.5), 
    text = element_text(family = "serif"),
    plot.title = element_text(size = 14, face = "bold"), 
    axis.title.x = element_text(size = 12, face = "bold"), 
    axis.title.y = element_text(size = 12, face = "bold")
  )

ggsave("U:/gender_inequality_job_satisfaction-main/results/mean_job_satisfaction_leadership.pdf")

## Leadership Position and gender 


merge_reg$sex <- ifelse(merge_reg$pla0009_h==1, "male", "female")
merge_reg$leadership <- ifelse(merge_reg$plb0067==1, "Yes", "No" )

round(prop.table(table(merge_reg$sex, merge_reg$leadership), margin = 1)*100,1)

## Leadership and Regional differences

merge_reg$regional <- ifelse(merge_reg$bula_ew==21, "West Germany", "East Germany")

round(prop.table(table(merge_reg$regional, merge_reg$leadership), margin = 1)*100,1)
table(merge_reg$regional, merge_reg$leadership)

## Job Satisfaction and Working hours ----------------------------


mean_whr <- aggregate(plh0173 ~ syear + working_hours_cat, data = merge_data[merge_data$plh0173 >= 0, ], FUN = mean, na.rm = TRUE)

plot_whr <- ggplot(data = mean_whr, aes(x = syear, y = plh0173, group = working_hours_cat, colour = working_hours_cat)) +
  geom_line(lwd = 1.5) +
  geom_point()+
  # geom_line(data = mean_whr[mean_whr$working_hours_cat %in% c("halb", "voll"), ], lwd = 1.5) +
  labs(x = "Year", y = "Mean Job Satisfaction", title = "Mean Job Satisfaction Germany Over Time by Amount of Working Hours", colour = "Working Hours") +
  scale_colour_manual(values = cbPalette) +
  scale_x_continuous(expand= c(0,0)) +
  theme_minimal() +
  theme (
    panel.border = element_rect(color = "black", fill = NA, size = 0.5), 
    text = element_text(family = "serif"),
    plot.title = element_text(size = 14, face = "bold"), 
    axis.title.x = element_text(size = 12, face = "bold"), 
    axis.title.y = element_text(size = 12, face = "bold")
  )

ggsave("U:/gender_inequality_job_satisfaction-main/results/mean_job_satisfaction_working_hours.pdf")

table(merge_reg$working_hours_cat)

round(prop.table(table(merge_reg$working_hours_cat, merge_reg$sex),margin = 2)*100,1)

ggplot(data = merge_reg,
       aes(x = sex, fill = working_hours_cat)) + 
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "Sex", y = "Percentage", fill = "Amount of Working Hours Category", title = "Distribution of Working Hours by Sex") + 
  theme_minimal() + 
  theme (
    panel.border = element_rect(color = "black", fill = NA, size = 0.5), 
    text = element_text(family = "serif"),
    plot.title = element_text(size = 14, face = "bold"), 
    axis.title.x = element_text(size = 12, face = "bold"), 
    axis.title.y = element_text(size = 12, face = "bold")
  )

ggsave("U:/gender_inequality_job_satisfaction-main/results/sex_working_hours.pdf")


## END ################################################################