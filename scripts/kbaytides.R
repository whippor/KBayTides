#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#                                                                             ##
# KBAY DRONE TIDES                                                            ##
# Script created 2024-03-27                                                   ##
# Data source: NOAA Tides                                                     ##
# R code prepared by Ross Whippo                                              ##
# Last updated 2024-03-27                                                     ##
#                                                                             ##
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# SUMMARY:
# A script that extracts the low and 3m tide height times from the NOAA Seldovia
# tide station outputs: 
# https://tidesandcurrents.noaa.gov/noaatidepredictions.html?id=9455500

# Required Files (check that script is loading latest version):
# .txt files extracted from NOAA Tides for Seldovia Station

# TO DO 

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# TABLE OF CONTENTS                                                         ####
#                                                                              +
# LOAD PACKAGES                                                                +
# READ IN AND PREPARE DATA                                                     +
# MANIPULATE DATA                                                              +
#                                                                              +
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# LOAD PACKAGES                                                             ####
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library(tidyverse)
library(hms)
library(ggplotify)
library(ggthemes)

# function for "%notin%
`%notin%` <- Negate(`%in%`)

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# READ IN AND PREPARE DATA                                                  ####
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# read in tide data serially
June2025 <- read_delim("data/raw/Seldovia9455500_Jun2025.txt", 
                       delim = "\t", escape_double = FALSE, 
                       trim_ws = TRUE, skip = 13) %>%
  select(Date, Day, Time) %>%
  rename(Value = Time) %>%
  rename(Time = Day)
July2025 <- read_delim("data/raw/Seldovia9455500_Jul2025.txt", 
                       delim = "\t", escape_double = FALSE, 
                       trim_ws = TRUE, skip = 13) %>%
  select(Date, Day, Time) %>%
  rename(Value = Time) %>%
  rename(Time = Day)
Aug2025 <- read_delim("data/raw/Seldovia9455500_Aug2025.txt", 
                       delim = "\t", escape_double = FALSE, 
                       trim_ws = TRUE, skip = 13) %>%
  select(Date, Day, Time) %>%
  rename(Value = Time) %>%
  rename(Time = Day)
Sep2025 <- read_delim("data/raw/Seldovia9455500_Sep2025.txt", 
                       delim = "\t", escape_double = FALSE, 
                       trim_ws = TRUE, skip = 13) %>%
  select(Date, Day, Time) %>%
  rename(Value = Time) %>%
  rename(Time = Day)

# combine all months
JunAug2025 <- June2025 %>%
  bind_rows(July2025, Aug2025, Sep2025)
JunAug2025$Datetime <- as.POSIXct(paste(JunAug2025$Date,
                                        JunAug2025$Time),
                                  format = "%Y-%m-%d %H:%M:%S")
JunAug2025$Date <- as.Date(JunAug2025$Date)
JunAug2025$Value <- as.numeric(gsub("\\*", "", JunAug2025$Value))

JunAug2025$HourMinute <- format(JunAug2025$Datetime, "%H:%M")
JunAug2025$Weekday <- wday(JunAug2025$Date, label = TRUE, abbr = TRUE)
JunAug2025$Month <- format(JunAug2025$Date, "%Y-%m")

JunAug2025_filtered <- JunAug2025 %>%
  filter(Value < 0)

ggplot(JunAug2025_filtered, aes(x = HourMinute, y = Date, fill = Value)) +
  geom_tile(color = "white") +
  scale_fill_viridis() +
  labs(title = "Negative Tides",
       x = "Time of Day",
       y = "Date",
       fill = "Value") + 
  facet_wrap(~ Month, scales = "free_y") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 


   #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# MANIPULATE DATA                                                           ####
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++








############### SUBSECTION HERE

####
#<<<<<<<<<<<<<<<<<<<<<<<<<<END OF SCRIPT>>>>>>>>>>>>>>>>>>>>>>>>#

# SCRATCH PAD ####