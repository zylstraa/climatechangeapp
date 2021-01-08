library(shiny)
library(tidyverse)
library(dismo)
library(plotly)

#I'm not sure if I need to do this, however my RStudio keeps adjusting my working directory every time I open it.
setwd("~/nss_projects/MidcourseProject/climatechangeapp/climatechange")

#Reading in the top 5 most populous cities in the US temperature data:
USA_NYC <- read_csv('data/NYC.csv')
USA_LA <- read_csv('data/LA.csv')
USA_Chicago <- read_csv('data/Chicago.csv')
USA_Houston <- read_csv('data/Houston.csv')
USA_Phoenix <- read_csv('data/Phoenix.csv')

#Let's use temperature information from 1950 on (due to weather balloons and satellite readings for temperature coming about in the 1950s)--
#commenting this all out since it looks like 70 years isn't a big enough time frame. will keep it from the 1850s since that's when temperature data
#started to be collected
# USA_NYC <- 
#   USA_NYC %>% 
#   filter(Date >= '1950-01-01')
# 
# USA_LA <- 
#   USA_LA %>% 
#   filter(Date >= '1950-01-01')
# 
# USA_Chicago <- 
#   USA_Chicago %>% 
#   filter(Date >= '1950-01-01')
# 
# USA_Houston <- 
#   USA_Houston %>% 
#   filter(Date >= '1950-01-01')
# 
# USA_Phoenix <- 
#   USA_Phoenix %>% 
#   filter(Date >= '1950-01-01')


#I should combine all of these into on plot labeled 'USA' but keeping their individual cities identifiable

#Exploratory plots to see what looks best
ggplot(USA_NYC,aes(x=Date,y=tmax)) + geom_line()

