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
    CO2$Date <- as.POSIXct(CO2$Date, format="%Y/%m/%d")
    CO2$Date <- format(CO2$Date, format="%b %Y")
    
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
        CO2$Date <- factor(CO2$Date, levels = CO2[["Date"]])
        CO2g <- plot_ly(CO2, x=~Date ,y=~CO2_levels, type='scatter', mode='lines',line = list(shape = 'linear', color="#455E14", width= 4))
        CO2g <- CO2g %>% layout(title='Global atmospheric CO2 levels (1958-2018)',
                                yaxis=list(title='CO2 levels (ppm)'))
        CO2g
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
