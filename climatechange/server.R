# Define server logic required to draw a histogram
shinyServer(function(input, output) {

#Data CAUSES:
    ff_co2 <-
        ff_co2 %>% 
        rename('Bunker.fuel'='Bunker fuels (Not in Total)')
    ff_co2 <- ff_co2 %>% 
        mutate(Total_ff = Total+Bunker.fuel)
    
    global_ff <- 
        ff_co2 %>% 
        filter(Year>=1900) %>% 
        group_by(Year) %>% 
        summarise(Total = sum(Total_ff))
    
    CO2 <- CO2 %>%
        select(Date,Trend) %>%
        rename('CO2_levels'='Trend')
    #adjusting how the date/time frame is formatted
    CO2$Date <- as.POSIXct(CO2$Date, format="%Y/%m/%d")
    CO2$Date <- format(CO2$Date, format="%b %Y")
    #plotting the information, formatting so plotly doesn't order things alphabetically
    CO2$Date <- factor(CO2$Date, levels = CO2[["Date"]])
    #I only want the year to show, not every month/year combo
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
    
#Plot CAUSES:
    output$globalffg <- renderPlotly({
        globalffg <- plot_ly(global_ff, x=~Year, y=~Total, type='scatter', mode='lines', 
                             line = list(shape = 'linear', color="#455E14", width= 4))
        globalffg <- globalffg %>% layout(title = "Global CO2 Emissions from Fossil Fuels (1900-2014)",
                                          xaxis = list(title = "Year"),
                                          yaxis = list (title = "Million metric tons of Carbon"))
        globalffg
    })
    
    output$CO2g <- renderPlotly({
        CO2g <- plot_ly(CO2, x=~Date ,y=~CO2_levels, type='scatter', mode='lines',line = list(shape = 'linear', color="#576e2b", width= 2))
        CO2g <- CO2g %>% layout(title='Global atmospheric CO2 levels (1958-2018)',
                                xaxis=list(tickvals=datevals,ticktext=showvals),                          
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
    
    
    output$donut1 <- renderPlotly({
        color1 <- c('#677c40','#788b55','#89996a','#9aa87f','#abb695','#bbc5aa', '#eef0e9')
        donut1g <- donut1 %>% plot_ly(labels =~Country, values=~Total_ff, marker=list(colors=color1,line=list(color='#FFFFFF',width=1)))
        donut1g <- donut1g %>% add_pie(hole=0.6)
        donut1g <- donut1g %>% layout(title='CO2 fossil fuel emissions by country (in million metric tons)', showlegend=F, axis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                                  yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        donut1g
    })
    
    #plotting the 2nd donut graph
    output$donut2 <- renderPlotly({
        color2 <- c('#101a17','#182d27','#1e4237','18383a','1b5356','1b7073', 
                '#245749', '#296e5b','#2e856e','355b35',
                '3b613b', '416740', '476d46', '4d734c', '537952', '598058','#569985','#78ad9c',
                '158e93','00adb3','53bbbf','7cc9cc',
                'e0f1f2','c0e4e5','9fd6d8',
                '#9ac1b4','#bbd6cc', '#ddeae5','#eef0e9', '#E7E8E9')
    
        donut2g <- donut2 %>% plot_ly(labels =~Country, values=~Total_ff,marker=list(colors=color2,line=list(color='#FFFFFF',width=1)))
        donut2g <- donut2g %>% add_pie(hole=0.6)
        donut2g <- donut2g %>% layout(title='CO2 fossil fuel emissions by country (in million metric tons)', showlegend=F, axis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                                  yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        donut2g
    })
        
#Data global temperature cleanup (causes), just kidding move this to effects
    global_tempmonth <- 
        global_tempmonth %>% 
        group_by(Date) %>% 
        summarise(Anomoly_Avg=mean(Mean))
    
#Plot global temperature plotting output (causes)
    output$tempplot <- renderPlot({
        tempplot <- global_tempmonth %>% 
            ggplot(aes(x=Date, y=Anomoly_Avg))+geom_line()
        tempplot
    })
    
#Data global CO2 levels cleanup (causes), commenting out because this is covered by globalffg
#     CO2 <- 
#         CO2 %>% 
#         select(-c('Decimal Date','Average','Interpolated','Number of Days')) %>% 
#         rename('ppm_CO2'='Trend')
#     
# #Plot global CO2 levels (causes)
#     output$CO2plot <- renderPlotly({
#         CO2plot <- plot_ly(CO2, x=~Date,y=~ppm_CO2,type='scatter',mode='lines', line=list(color='Blue'),
#                            showlegend=FALSE, name='CO2 air levels (ppm)')
#         CO2plot
#     })
    

    
#Data global sea levels cleanup (effects)
    sealevel <- 
        sealevel %>% 
        select(-`NOAA Adjusted Sea Level`) %>% 
        rename('Upper_Error'='Upper Error Bound', 'Lower_Error' = 'Lower Error Bound', 'Avg_level_rise'='CSIRO Adjusted Sea Level')
    
#Plot global sea levels (effects)
    output$seaplot <- renderPlotly({
        seaplot <- plot_ly(sealevel, x=~Year, y=~Upper_Error,type='scatter', mode='lines',
                           line=list(color='transparent'),
                           showlegend=FALSE, name='Upper Error')
        seaplot <- seaplot %>% add_trace(y=~Lower_Error, type='scatter', mode='lines',
                                         fill='tonexty', fillcolor='rgba(0,100,80,0.2)', line=list(color='transparent'),
                                         showlegend=FALSE,name='Lower Error')  
        seaplot <- seaplot %>% add_trace(y=~Avg_level_rise, type='scatter', mode='lines',
                                         line=list(color='rgb(0,100,80)'),
                                         name='Average level rise')
        seaplot
    })

#Data national fossil fuel emissions cleanup (national)
    country_choice <- ff_co2 %>% 
        filter(Country=='UNITED STATES OF AMERICA')
    
#Plot national fossil fuel emissions (national)
    output$ffCO2 <- renderPlotly({
        ff_emiss <- plot_ly(country_choice, x=~Year,y=~Total, mode='lines')
        ff_emiss
    })
})
