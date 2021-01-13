library(shiny)
library(tidyverse)
library(dismo)
library(plotly)

#I'm not sure if I need to do this, however my RStudio keeps adjusting my working directory every time I open it.
setwd("~/nss_projects/MidcourseProject/climatechangeapp/climatechange")

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


# First CAUSE TAB graph: global total over time CO2 fossil fuel emissions
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

#Second CAUSE TAB graph: CO2 levels in the air globally
#choosing to use 'Trend' because it has the same information as interpolated and average but is corrected for seasonality
# CO2 <- CO2 %>% 
#   select(Date,Trend) %>% 
#   rename('CO2_levels'='Trend')
# #adjusting how the date/time frame is formatted
# CO2$Date <- as.POSIXct(CO2$Date, format="%Y/%m/%d")
# CO2$Date <- format(CO2$Date, format="%b %Y")
#plotting the information, formatting so plotly doesn't order things alphabetically
# CO2$Date <- factor(CO2$Date, levels = CO2[["Date"]])
# CO2g <- plot_ly(CO2, x=~Date ,y=~CO2_levels, type='scatter', mode='lines',line = list(shape = 'linear', color="#455E14", width= 4))
# CO2g <- CO2g %>% layout(title='Global atmospheric CO2 levels (1958-2018)',
#                         yaxis=list(title='CO2 levels (ppm)'))
# CO2g


#Third CAUSE TAB graph: globally country per capita metric tons of fossil fuels emitted, still adjusting this plot stopping here Jan 12
ff_co2pc <- 
  ff_co2 %>% 
  rename('Per_Capita'='Per Capita') %>% 
  group_by(Year) 

percapg <- plot_ly(ff_co2pc, x=~Per_Capita, y=~Total_ff,text=~Country,type='scatter',mode='markers',marker = list(size =~Per_Capita, opacity = 0.5, color = 'rgb(255, 65, 54)'))
percapg <- percapg %>% layout(showlegend=FALSE)
percapg

# #This will be a donut graph showing the percentage each country is responsible for
# ff_co2 <-
#   ff_co2 %>%
#   rename('Bunker.fuel'='Bunker fuels (Not in Total)')
# 
# ff_co2 <- ff_co2 %>%
#   mutate(Total_ff = Total+Bunker.fuel)
#code above is duplicated and won't be needed to be copied into server
# ff100 <-
#   ff_co2 %>% 
#   filter(Year==2014) %>% 
#   arrange(desc(Total_ff)) %>% 
#   head(100) %>% 
#   select(Country,Total_ff)
#plotting the donut graph
# ff100g <- ff100 %>% plot_ly(labels =~Country, values=~Total_ff)
# ff100g <- ff100g %>% add_pie(hole=0.6)
# ff100g <- ff100g %>% layout(title='CO2 fossil fuel emissions by country', showlegend=F, axis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
#                             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
# ff100g

#Also would like to add interactivity where you can compare up to 3 countriess
