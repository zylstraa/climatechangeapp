library(shiny)
library(tidyverse)
library(dismo)
library(plotly)

#I'm not sure if I need to do this, however my RStudio keeps adjusting my working directory every time I open it.
setwd("~/nss_projects/MidcourseProject/climatechangeapp/climatechange")

# #Temperature data: this is extremely granular so I am commenting it out for the time being. If I need to, I can come back to it.
# 
# 
# #Reading in the top 5 most populous cities in the US temperature data:
# USA_NYC <- read_csv('data/NYC.csv')
# USA_LA <- read_csv('data/LA.csv')
# USA_Chicago <- read_csv('data/Chicago.csv')
# USA_Houston <- read_csv('data/Houston.csv')
# USA_Phoenix <- read_csv('data/Phoenix.csv')
# 
# #Let's use temperature information from 1950 on (due to weather balloons and satellite readings for temperature coming about in the 1950s)--
# #commenting this all out since it looks like 70 years isn't a big enough time frame. will keep it from the 1850s since that's when temperature data
# #started to be collected
# # USA_NYC <- 
# #   USA_NYC %>% 
# #   filter(Date >= '1950-01-01')
# # 
# # USA_LA <- 
# #   USA_LA %>% 
# #   filter(Date >= '1950-01-01')
# # 
# # USA_Chicago <- 
# #   USA_Chicago %>% 
# #   filter(Date >= '1950-01-01')
# # 
# # USA_Houston <- 
# #   USA_Houston %>% 
# #   filter(Date >= '1950-01-01')
# # 
# # USA_Phoenix <- 
# #   USA_Phoenix %>% 
# #   filter(Date >= '1950-01-01')
# 
# 
# 


#Global temperature found at https://datahub.io/core/global-temp#data
global_temp <- read_csv('data/globaltempannual.csv')
global_tempmonth <- read_csv('data/global_monthly_tempanom.csv')

#Global sea levels https://datahub.io/core/sea-level-rise#resource-epa-sea-level
sealevel <- read_csv('data/epa-sea-level.csv')

#Global CO2 levels in the air https://datahub.io/core/co2-ppm
CO2 <- read_csv('data/co2airlevels.csv')

#National Fossil fuel emissions data source https://datahub.io/core/co2-fossil-by-nation#data
ff_co2 <- read_csv('data/fossilfuelco2bycountry.csv')






#Global temperature focus:
# global_tempmonth <- 
#   global_tempmonth %>% 
#   group_by(Date) %>% 
#   summarise(Anomoly_Avg=mean(Mean))
# 
# tempplot <- global_tempmonth %>% 
#   ggplot(aes(x=Date, y=Anomoly_Avg))+geom_line()

#Global sea level focus (CHANGE: I want to make year just the actual year rather than MArch 15th)
# sealevel <- 
#   sealevel %>% 
#   select(-`NOAA Adjusted Sea Level`) %>% 
#   rename('Upper_Error'='Upper Error Bound', 'Lower_Error' = 'Lower Error Bound', 'Avg_level_rise'='CSIRO Adjusted Sea Level')

# seaplot <- plot_ly(sealevel, x=~Year, y=~Upper_Error,type='scatter', mode='lines',
#                    line=list(color='transparent'),
#                    showlegend=FALSE, name='Upper Error')
# seaplot <- seaplot %>% add_trace(y=~Lower_Error, type='scatter', mode='lines',
#                                  fill='tonexty', fillcolor='rgba(0,100,80,0.2)', line=list(color='transparent'),
#                                  showlegend=FALSE,name='Lower Error')  
# seaplot <- seaplot %>% add_trace(y=~Avg_level_rise, type='scatter', mode='lines',
#                                  line=list(color='rgb(0,100,80)'),
#                                  name='Average level rise')
# seaplot

#Global CO2 levels
# CO2 <- 
#   CO2 %>% 
#   select(-c('Decimal Date','Average','Interpolated','Number of Days')) %>% 
#   rename('ppm_CO2'='Trend')
# 
# CO2plot <- plot_ly(CO2, x=~Date,y=~ppm_CO2,type='scatter',mode='lines', line=list(color='Blue'),
#                    showlegend=FALSE, name='CO2 air levels (ppm)')
# CO2plot


#National ff emissions
# country_choice <- ff_co2 %>% 
#   filter(Country=='UNITED STATES OF AMERICA')

# ff_emiss <- plot_ly(country_choice, x=~Year,y=~Total, mode='lines')
# ff_emiss


#First CAUSE TAB graph: global total over time CO2 fossil fuel emissions
# ff_co2 <-
#   ff_co2 %>% 
#   rename('Bunker.fuel'='Bunker fuels (Not in Total)')
# 
# ff_co2 <- ff_co2 %>% 
#   mutate(Total_ff = Total+Bunker.fuel)
# 
# global_ff <- 
#   ff_co2 %>% 
#   filter(Year>=1900) %>% 
#   group_by(Year) %>% 
#   summarise(Total = sum(Total_ff))
# 
# globalffg <- plot_ly(global_ff, x=~Year, y=~Total, type='scatter', mode='lines', 
#                      line = list(shape = 'linear', color="#455E14", width= 4))
# globalffg <- globalffg %>% layout(title = "Global CO2 Emissions from Fossil Fuels (1900-2014)",
#         xaxis = list(title = "Year"),
#        yaxis = list (title = "Million metric tons of Carbon"))
# globalffg

#Second CAUSE TAB graph: country per capita metric tons of fossil fuels emitted
#Filtering from year 1990
ff_co2pc <- 
  ff_co2 %>% 
  rename('Per_Capita'='Per Capita') %>% 
  filter(Year>=1950)

percapg <- plot_ly(ff_co2pc, x=~Year, y=~Per_Capita,type='scatter',mode='lines',linetype=~Country)
percapg <- percapg %>% layout(showlegend=FALSE)
percapg

#I am trying to get it so that only the top 25 countries (according to the most recent year) are shown but i have yet to get it to work. Stopping here Jan 9th
top50 <-
  ff_co2pc %>% 
  filter(Year==2014)

