## code to prepare `DATASET` dataset goes here
library(tidyverse)

# read in data
Yoga_Analysis <- read.csv("./data-raw/Screen Time Data.csv")

Yoga_Analysis$Week.Day <- factor(Yoga_Analysis$Week.Day,
                                    levels=c("Sunday",
                                             "Monday",
                                             "Tuesday",
                                             "Wednesday",
                                             "Thursday",
                                             "Friday",
                                             "Saturday"))

Yoga_Analysis$Yoga <- as.factor(Yoga_Analysis$Yoga)

Yoga_Analysis$Date <- lubridate::mdy(Yoga_Analysis$Date)

Yoga_Analysis <- Yoga_Analysis %>%
  mutate(Yoga = ifelse(Yoga == 1, "Yes", "No")) %>%
  mutate(Yoga = factor(Yoga))

Yoga_Analysis <- Yoga_Analysis %>%
  select(-index)


usethis::use_data(Yoga_Analysis, overwrite = TRUE)
