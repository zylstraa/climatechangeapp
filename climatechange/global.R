library(shiny)
library(tidyverse)
library(dismo)
library(plotly)
library(shinydashboard)

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

#deforestation: CAUSES https://data.worldbank.org/indicator/AG.LND.FRST.K2?view=chart
forest_area <- read_csv('data/forest_area.csv')

#country codes w/ continent list: https://datahub.io/JohnSnowLabs/country-and-continent-codes-list
countrycodes <- read_csv('data/countrycodes.csv')

#color palettes used:
color1 <- c('#677c40','#788b55','#89996a','#9aa87f','#abb695','#bbc5aa', '#eef0e9')
color2 <- c('#101a17','#182d27','#1e4237','18383a','1b5356','1b7073', 
            '#245749', '#296e5b','#2e856e','355b35',
            '3b613b', '416740', '476d46', '4d734c', '537952', '598058','#569985','#78ad9c',
            '158e93','00adb3','53bbbf','7cc9cc',
            'e0f1f2','c0e4e5','9fd6d8',
            '#9ac1b4','#bbd6cc', '#ddeae5','#eef0e9', '#E7E8E9'
)



#Natural disasters source: https://public.emdat.be/data (containing:
# Volcanic activity
# Ash fall
# Lahar
# Pyroclastic flow
# Lava flow
# 
# Mass movement (dry)
# Rockfall
# Landslide
# Avalanche
# Subsidence
# 
# Earthquake
# Ground movement
# Tsunami
# 
# Meteorological
# 
# Extreme temperature
# Cold wave
# Heat wave
# Severe winter conditions
# Fog
# 
# Storm
# Convective storm
# Extra-tropical storm
# Tropical cyclone
# 
# 
# Wave action
# Rogue wave
# Seiche
# 
# Landslide
# Avalanche
# Landslide
# Subsidence
# Rockfall
# Mudslide
# 
# Flood
# Coastal flood
# Flash flood
# Wildfire
# Forest fire
# Land fire (Brush, Bush, Pasture)
# Glacial lake outburst
# 
# Drought
# Famine
disaster <- read_csv('data/naturaldisasters.csv')



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
# #plotting the information, formatting so plotly doesn't order things alphabetically
# CO2$Date <- factor(CO2$Date, levels = CO2[["Date"]])
# #I only want the year to show, not every month/year combo
# datevals <- c('Feb 1960','Feb 1965','Feb 1970','Feb 1975','Feb 1980','Feb 1985','Feb 1990','Feb 1995','Feb 2000','Feb 2005','Feb 2010','Feb 2015')
# showvals <- c('1960', '1965', '1970', '1975', '1980','1985','1990','1995','2000','2005','2010','2015')
# CO2g <- plot_ly(CO2, x=~Date ,y=~CO2_levels, type='scatter', mode='lines',line = list(shape = 'linear', color="#576e2b", width= 2))
# CO2g <- CO2g %>% layout(title='Global atmospheric CO2 levels (1958-2018)',
#                         xaxis=list(tickvals=datevals,ticktext=showvals),                          
#                           yaxis=list(title='CO2 levels (ppm)'),
#                         showlegend=FALSE)
# CO2g <- CO2g %>% 
#   add_segments(x = 'Feb 1958', xend = 'Feb 2018', y = 350, yend = 350,text='Healthy CO2 level',
#                               line=list(width=2.5,dash='dash',color='#B5E550')) %>%
#   add_segments(x = 'Feb 1958', xend = 'Feb 2018', y = 400, yend = 400, text='Dangerous CO2 level',
#                line=list(width=2.5,dash='dash',color='#FC284A'))
# CO2g <- CO2g %>% 
#   add_text(x='Feb 1965',y=353,text='Healthy C02 level') 
# CO2g <- CO2g %>% 
#   add_text(x='Feb 1965',y=403,text='Dangerous C02 level')
# CO2g
#I don't know if I actually want to use this yet: Third CAUSE TAB graph: globally country per capita metric tons of fossil fuels emitted, still adjusting this plot stopping here Jan 12
# ff_co2pc <- 
#   ff_co2 %>% 
#   rename('Per_Capita'='Per Capita') %>% 
#   group_by(Year) 
# 
# percapg <- plot_ly(ff_co2pc, x=~Per_Capita, y=~Total_ff,text=~Country,type='scatter',mode='markers',marker = list(size =~Per_Capita, opacity = 0.5, color = 'rgb(255, 65, 54)'))
# percapg <- percapg %>% layout(showlegend=FALSE)
# percapg

#This will be a donut graph showing the percentage each country is responsible for, make two graphs: all countries w/ <2% lumped as 'other' and another where the smaller percentage countries are viewed closer
# ff_co2 <-
#   ff_co2 %>%
#   rename('Bunker.fuel'='Bunker fuels (Not in Total)')
# 
# ff_co2 <- ff_co2 %>%
#   mutate(Total_ff = Total+Bunker.fuel)
#code above is duplicated and won't be needed to be copied into server
# donut1 <-
#   ff_co2 %>%
#   filter(Year==2014) %>%
#   arrange(desc(Total_ff)) %>%
#   head(100) %>%
#   select(Country,Total_ff) %>% 
#   mutate(Country= case_when(
#   Total_ff <= 181333 ~'Countries with less than 2% contribution',
#   Total_ff > 181333 ~Country
#   )
#     )
# 
# donut2 <-
#   ff_co2 %>%
#   filter(Year==2014) %>%
#   arrange(desc(Total_ff)) %>%
#   head(100) %>%
#   select(Country,Total_ff) %>% 
#   filter(Total_ff <= 181333) %>% 
#   mutate(Country= case_when(
#     Total_ff <= 40232 ~'Countries with less than 1% contribution',
#     Total_ff > 40232 ~Country
#   )
#   )

#plotting the 1st donut graph (lumping <2% into its own group)
# color1 <- c('#677c40','#788b55','#89996a','#9aa87f','#abb695','#bbc5aa', '#eef0e9')
# donut1g <- donut1 %>% plot_ly(labels =~Country, values=~Total_ff, marker=list(colors=color1,line=list(color='#FFFFFF',width=1)))
# donut1g <- donut1g %>% add_pie(hole=0.6)
# donut1g <- donut1g %>% layout(title='CO2 fossil fuel emissions by country (in million metric tons)', showlegend=F, axis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
#                             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
# donut1g
# 
# #plotting the 2nd donut graph

# donut2g <- donut2 %>% plot_ly(labels =~Country, values=~Total_ff,marker=list(colors=color2,line=list(color='#FFFFFF',width=1)))
# donut2g <- donut2g %>% add_pie(hole=0.6)
# donut2g <- donut2g %>% layout(title='CO2 fossil fuel emissions by country (in million metric tons)', showlegend=F, axis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
#                               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
# donut2g






#Have to add a letter onto the column names so that it can be input into plotly as a column name and not a number
# forest_area <-forest_area %>% 
#   dplyr::rename_all(function(x) paste0("Y", x)) %>% 
#   rename('CODE'='YCountry Code','Country'='YCountry Name')
# 
# countrycodes <- countrycodes %>% 
#   rename('CODE'='Three_Letter_Country_Code') %>% 
#   select('Continent_Name','Country_Name','CODE')
# 
# forest_bycont <- right_join(countrycodes,forest_area, by='CODE') %>% 
#   group_by(Continent_Name) %>% 
#   mutate_if(is.numeric,replace_na,0) %>% 
#   summarise_if(is.numeric,funs(sum)) %>% 
#   head(-1) %>% 
#   pivot_longer(cols=Y1990:Y2016, names_to='Year',values_to='km_forest') %>% 
#   pivot_wider(names_from=Continent_Name,values_from=km_forest) %>% 
#   rename('North_America'='North America','South_America'='South America') 
# 
# numbers <- '([0-9]{4})'
# 
# forest_bycont$Year <- str_extract_all(forest_bycont$Year,numbers)
  
# Africa <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~Africa, name='Africa',line=list(color='#bbc5aa',width=2))
# Asia <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~Asia, name='Asia',line=list(color='89996a',width=3, dash='dash'))
# Europe <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~Europe, name='Europe',line=list(color='abb695',width=3,dash='dot'))
# NorthAm <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~North_America, name='North America',line=list(color='7cc9cc',width=2))
# Oceania <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~Oceania, name='Oceania',line=list(color='ddeae5',width=4))
# SouthAm <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~South_America, name='South America',line=list(color='476d46',width=2))
# forestmap <- subplot(Africa,Asia,Europe,NorthAm,Oceania,SouthAm,nrows=6,shareX=TRUE)
# forestmap <- forestmap %>% layout(title='Area of forest in sq km (1990-2016)')
# forestmap

#Overall 1,324,449 square kilometers of forest were lost from 1990-2016

                     


#Effects: have a dropdown where they can take a look at each individual issue, Michael idea: Value box, on average on whatever year is chosen, on average in x year, sealevel rose x amount
#What's in the value box can vary based on whatever you're looking at

#Effects: Storms & Natural Disasters
disaster %>% count(Year) %>% ggplot(aes(x=Year,y=n))+geom_line()
#scattermapbox plotly: scatter plots over a map. Add slider to pick by Year, alsoforest allow to zoom in on one country (interactivity dropdown)






#Effects: Sea level rising, current plot information works well visually, need to adjust colors 
# sealevel <- 
#   sealevel %>% 
#   select(-`NOAA Adjusted Sea Level`) %>% 
#   rename('Upper_Error'='Upper Error Bound', 'Lower_Error' = 'Lower Error Bound', 'Avg_level_rise'='CSIRO Adjusted Sea Level')
# output$seaplot <- renderPlotly({
#   seaplot <- plot_ly(sealevel, x=~Year, y=~Upper_Error,type='scatter', mode='lines',
#                      line=list(color='transparent'),
#                      showlegend=FALSE, name='Upper Error')
#   seaplot <- seaplot %>% add_trace(y=~Lower_Error, type='scatter', mode='lines',
#                                    fill='tonexty', fillcolor='rgba(0,100,80,0.2)', line=list(color='transparent'),
#                                    showlegend=FALSE,name='Lower Error')  
#   seaplot <- seaplot %>% add_trace(y=~Avg_level_rise, type='scatter', mode='lines',
#                                    line=list(color='rgb(0,100,80)'),
#                                    name='Average level rise')
#   seaplot


#Effects: Temperature rising (have this be a big number visualization)










