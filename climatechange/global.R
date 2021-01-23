library(shiny)
library(tidyverse)
library(dismo)
library(plotly)
library(rnaturalearth)
library(rgeos)
library(sf)

#I'm not sure if I need to do this, however my RStudio keeps adjusting my working directory every time I open it.
setwd("~/nss_projects/MidcourseProject/climatechangeapp/climatechange")

#Global temperature found at https://datahub.io/core/global-temp#data
global_temp <- read_csv('data/globaltempannual.csv')
global_tempmonth <- read_csv('data/global_monthly_tempanom.csv')


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
            '#9ac1b4','#bbd6cc', '#ddeae5','#eef0e9', '#E7E8E9')
color3 <- c('c7e9eb','9aa87f','eef0e9')

#Global sea levels https://datahub.io/core/sea-level-rise#resource-epa-sea-level
sealevel <- read_csv('data/epa-sea-level.csv')

#hydroelectric % https://data.worldbank.org/indicator/EG.ELC.HYRO.ZS?end=2015&start=1960&view=chart
#renewable non hydroelectric % https://data.worldbank.org/indicator/EG.ELC.RNWX.ZS?view=chart
hydro <- read_csv('data/hydro.csv')
nonhydro <- read_csv('data/nonhydro.csv')

#fish: https://data.worldbank.org/indicator/EN.FSH.THRD.NO?view=chart
fish <- read_csv('data/fish.csv')
#mammal: https://data.worldbank.org/indicator/EN.MAM.THRD.NO?view=chart
mammal <- read_csv('data/mammal.csv')
#bird: https://data.worldbank.org/indicator/EN.BIR.THRD.NO?view=chart
bird <- read_csv('data/bird.csv')
#plant: https://data.worldbank.org/indicator/EN.HPT.THRD.NO?view=chart
plant <- read_csv('data/plant.csv')

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
#Effects: Storms & Natural Disasters https://public.emdat.be/data

disaster <- read_csv('data/naturaldisasters.csv')



#CAUSES data
#Carbon produced by fossil fuels
ff_co2 <- ff_co2 %>% 
  rename('Bunker.fuel'='Bunker fuels (Not in Total)')

ff_co2 <- ff_co2 %>% 
  mutate(Total_ff = Total+Bunker.fuel)

global_ff <- 
  ff_co2 %>% 
  filter(Year>=1900) %>% 
  group_by(Year) %>% 
  summarise(Total = sum(Total_ff))


#Global CO2 emissions by country
CO2 <- CO2 %>%
  select(Date,Trend) %>%
  rename('CO2_levels'='Trend')
CO2$Date <- as.POSIXct(CO2$Date, format="%Y/%m/%d")
CO2$Date <- format(CO2$Date, format="%b %Y")
CO2$Date <- factor(CO2$Date, levels = CO2[["Date"]])
datevals <- c('Feb 1960','Feb 1965','Feb 1970','Feb 1975','Feb 1980','Feb 1985','Feb 1990','Feb 1995','Feb 2000','Feb 2005','Feb 2010','Feb 2015')
showvals <- c('1960', '1965', '1970', '1975', '1980','1985','1990','1995','2000','2005','2010','2015')

donut1 <-
  ff_co2 %>%
  filter(Year==2014) %>%
  arrange(desc(Total_ff)) %>%
  head(100) %>%
  select(Country,Total_ff) %>% 
  mutate(Country= case_when(
    Total_ff <= 181333 ~'Countries with less than 2% contribution',
    Total_ff > 181333 ~Country
  )
  )

donut2 <-
  ff_co2 %>%
  filter(Year==2014) %>%
  arrange(desc(Total_ff)) %>%
  head(100) %>%
  select(Country,Total_ff) %>% 
  filter(Total_ff <= 181333) %>% 
  mutate(Country= case_when(
    Total_ff <= 40232 ~'Countries with less than 1% contribution',
    Total_ff > 40232 ~Country
  )
  )

#Deforestation
forest_area <-forest_area %>% 
  dplyr::rename_all(function(x) paste0("Y", x)) %>% 
  rename('CODE'='YCountry Code','Country'='YCountry Name')

countrycodes <- countrycodes %>% 
  rename('CODE'='Three_Letter_Country_Code') %>% 
  select('Continent_Name','Country_Name','CODE')

forest_bycont <- right_join(countrycodes,forest_area, by='CODE') %>% 
  group_by(Continent_Name) %>% 
  mutate_if(is.numeric,replace_na,0) %>% 
  summarise_if(is.numeric,funs(sum)) %>% 
  head(-1) %>% 
  pivot_longer(cols=Y1990:Y2016, names_to='Year',values_to='km_forest') %>% 
  pivot_wider(names_from=Continent_Name,values_from=km_forest) %>% 
  rename('North_America'='North America','South_America'='South America') 

numbers <- '([0-9]{4})'

forest_bycont$Year <- str_extract_all(forest_bycont$Year,numbers)


#EFFECTS data:
#Sea level
sealevel <-
  sealevel %>%
  select(-`NOAA Adjusted Sea Level`) %>%
  rename('Upper_Error'='Upper Error Bound', 'Lower_Error' = 'Lower Error Bound', 'Avg_level_rise'='CSIRO Adjusted Sea Level')

#Flooding
flooding <- disaster %>% 
  rename('Disaster_type'='Disaster Type') %>% 
  filter(Disaster_type=='Flood') %>% 
  count(Year) %>% 
  filter(Year >= 1960)

#Natural disasters
disaster <- disaster %>% 
  filter(Year >= 1990) %>% 
  select(Year,Country,ISO) %>% 
  group_by(Year) %>% 
  add_count(Country,name='Number_disasters')

disaster <- disaster[!duplicated(disaster), ]

#Species threatened
fish <- fish %>% 
  rename('Country'='Country Name','ISO'='Country Code','Species'='Fish Species')

mammal <- mammal %>% 
  rename('Country'='Country Name','ISO'='Country Code','Species'='Mammal')

bird <- bird %>% 
  rename('Country'='Country Name','ISO'='Country Code','Species'='Bird')

plant <- plant %>% 
  rename('Country'='Country Name','ISO'='Country Code','Species'='Plants')

#ACTION data:
hydro <- hydro %>%
  rename('hydro'='2015','Country'='Country Name') %>%
  select(Country,hydro)

nonhydro <- nonhydro %>%
  rename('nonhydro'='2015','Country'='Country Name','ISO'='Country Code') %>%
  select(Country,nonhydro)


energy <- full_join(hydro,nonhydro,by='Country') %>%
  mutate('nonrenewable'=100-(hydro+nonhydro)) %>%
  drop_na()


#Global temperature focus:
# global_tempmonth <- 
#   global_tempmonth %>% 
#   group_by(Date) %>% 
#   summarise(Anomoly_Avg=mean(Mean))
# 
# tempplot <- global_tempmonth %>% 
#   ggplot(aes(x=Date, y=Anomoly_Avg))+geom_line()




#Overall 1,324,449 square kilometers of forest were lost from 1990-2016

                     


#Effects: have a dropdown where they can take a look at each individual issue, Michael idea: Value box, on average on whatever year is chosen, on average in x year, sealevel rose x amount
#What's in the value box can vary based on whatever you're looking at
#Temperature:
global_tempmonth <- 
  global_tempmonth %>% 
  group_by(Date) %>% 
  summarise(Anomoly_Avg=mean(Mean))





#Action: renewable energy: 
# nope <- c('Fragile and conflict affected situations','Central Europe and the Baltics','East Asia & Pacific (excluding high income)','Early-demographic dividend',
#           'East Asia & Pacific','Europe & Central Asia (excluding high income)','Europe & Central Asia','Euro area','European Union','Fragile and conflict affected situations',
#           'High income','Heavily indebted poor countries (HIPC)','IBRD only','IDA & IBRD total','IDA total','IDA blend','IDA only','Latin America & Caribbean (excluding high income)',
#           'Latin America & Caribbean','Least developed countries: UN classification','Low income','Lower middle income','Low & middle income','Late-demographic dividend',
#           'Middle East & North Africa','Middle income','Middle East & North Africa (excluding high income)','North America','OECD members','Other small states','Pre-demographic dividend',
#           'Post-demographic dividend', 'South Asia','Sub-Saharan Africa (excluding high income)','Sub-Saharan Africa','Small states','East Asia & Pacific (IDA & IBRD countries)',
#           'Europe & Central Asia (IDA & IBRD countries)','Latin America & the Caribbean (IDA & IBRD countries)','Middle East & North Africa (IDA & IBRD countries)',
#           'South Asia (IDA & IBRD)','Sub-Saharan Africa (IDA & IBRD countries)','Upper middle income')























