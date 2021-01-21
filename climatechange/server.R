# Define server logic required to draw a histogram
shinyServer(function(input, output) {

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
    
    
#Plot CAUSES:
    output$globalffg <- renderPlotly({

        globalffg <- plot_ly(global_ff, x=~Year, y=~Total, type='scatter', mode='lines', 
                             line = list(shape = 'linear', color="#455E14", width= 4))
        globalffg <- globalffg %>% layout(xaxis = list(title = "Year"),
                                          yaxis = list (title = "Million metric tons of Carbon"))
        globalffg
        
    })
    
    output$CO2g <- renderPlotly({
        CO2g <- plot_ly(CO2, x=~Date ,y=~CO2_levels, type='scatter', mode='lines',line = list(shape = 'linear', color="#576e2b", width= 2))
        CO2g <- CO2g %>% layout(xaxis=list(tickvals=datevals,ticktext=showvals),                          
                                yaxis=list(title='CO2 levels (ppm)'),
                                showlegend=FALSE)
        CO2g <- CO2g %>% 
            add_segments(x = 'Feb 1958', xend = 'Feb 2018', y = 350, yend = 350,text='Healthy CO2 level',
                         line=list(width=2.5,dash='dash',color='#B5E550')) %>%
            add_segments(x = 'Feb 1958', xend = 'Feb 2018', y = 400, yend = 400, text='Dangerous CO2 level',
                         line=list(width=2.5,dash='dash',color='#FC284A'))
        CO2g <- CO2g %>% 
            add_text(x='Feb 1965',y=353,text='Healthy C02 level') 
        CO2g <- CO2g %>% 
            add_text(x='Feb 1965',y=403,text='Dangerous C02 level')
        CO2g
    })
    
    output$donut1g <- renderPlotly({
        donut1g <- donut1 %>% plot_ly(labels =~Country, values=~Total_ff, marker=list(colors=color1,line=list(color='#FFFFFF',width=1)))
        donut1g <- donut1g %>% add_pie(hole=0.6)
        donut1g <- donut1g %>% layout(showlegend=F, axis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                                  yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        donut1g
    })
    
    output$donut2g <- renderPlotly({

        donut2g <- donut2 %>% plot_ly(labels =~Country, values=~Total_ff,marker=list(colors=color2,line=list(color='#FFFFFF',width=1)))
        donut2g <- donut2g %>% add_pie(hole=0.6)
        donut2g <- donut2g %>% layout(showlegend=F, axis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                                  yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        donut2g
        
    })
    
    output$forest1 <- renderPlotly({
        Africa <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~Africa, name='Africa',line=list(color='#bbc5aa',width=2))
        Asia <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~Asia, name='Asia',line=list(color='89996a',width=3, dash='dash'))
        Europe <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~Europe, name='Europe',line=list(color='abb695',width=3,dash='dot'))
        forestmap1 <- subplot(Africa,Asia,Europe,nrows=3,shareX=TRUE)
        forestmap1
    })
    
    output$forest2 <- renderPlotly({
        NorthAm <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~North_America, name='North America',line=list(color='7cc9cc',width=2))
        Oceania <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~Oceania, name='Oceania',line=list(color='ddeae5',width=4))
        SouthAm <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~South_America, name='South America',line=list(color='476d46',width=2))
        forestmap2 <- subplot(NorthAm,Oceania,SouthAm, nrows=3,shareX=TRUE)
        forestmap2
    })

    
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
    
    
#EFFECTS plot:
    output$seaplot <- renderPlotly({
        seaplot <- plot_ly(sealevel, x=~Year, y=~Upper_Error,type='scatter', mode='lines',
                           line=list(color='transparent'),
                           showlegend=FALSE, name='Upper Error')
        seaplot <- seaplot %>% add_trace(y=~Lower_Error, type='scatter', mode='lines',
                                         fill='tonexty', fillcolor='BDE9EB', line=list(color='transparent'),
                                         showlegend=FALSE,name='Lower Error')
        seaplot <- seaplot %>% add_trace(y=~Avg_level_rise, type='scatter', mode='lines',
                                         line=list(color='00ADB3'),
                                         name='Average rise')
        seaplot <- seaplot %>% layout(yaxis=list(title='Sea Level Rise (inches)'))
        seaplot
    })
    
    output$floodg <- renderPlotly({
        floodg <- plot_ly(flooding, x=~Year, y=~n, type='scatter',mode='lines',line=list(color='#4794a1',width=3))
        floodg <- floodg %>%  add_trace(x = 2013, y = 9, marker = list(color = '#FE8373',size = 50,opacity = 0.2),showlegend = FALSE)
        floodg <- floodg %>% add_text(x=2013,y=5,text='Time of Drought',showlegend=FALSE)
        floodg <- floodg %>% layout(yaxis=list(title='Number of floods'),showlegend=FALSE)
        floodg
    })
    
    output$disasterg <- renderPlotly({
        disasterg <- plot_ly(disaster,type='choropleth',scope='North America',locations=~ISO,z=~Number_disasters,
                             text=~Country,frame=~Year,zauto=FALSE,zmin=1,zmax=35,color='YlOrRd')
        disasterg
    })


    
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

#ACTION reactive:
    energyd1 <- reactive({
        energyd1 <- energy %>%
            filter(Country==input$Country1) %>%
            pivot_longer(cols=c(hydro,nonhydro,nonrenewable),names_to='Energy_type')
    }) 

#ACTION plot:
    output$energy1 <- renderPlotly({
        energyg <- plot_ly(energyd1(), type='pie',labels=~Energy_type,values=~value,
                           marker = list(colors = color3,line = list(color = '#FFFFFF', width = 1)))
        energyg
    })


 })
