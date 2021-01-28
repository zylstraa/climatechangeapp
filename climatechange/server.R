# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
#CAUSES plot:
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
        donut1g <- donut1g %>% layout(axis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                                  yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        donut1g
    })
    
    output$donut2g <- renderPlotly({

        donut2g <- donut2 %>% plot_ly(labels =~Country, values=~Total_ff,marker=list(colors=color2,line=list(color='#FFFFFF',width=1)))
        donut2g <- donut2g %>% add_pie(hole=0.6)
        donut2g <- donut2g %>% layout(axis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                                  yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        donut2g
        
    })
    
    output$forestg <- renderPlotly({
        forestg <- plot_ly(forest_bycont,type='scatter',mode='lines', x=~Year, y=~North_America, name='North America',line=list(color='7cc9cc',width=2))
        forestg <- forestg %>% add_trace(y=~Oceania, name='Oceania',line=list(color='ddeae5',width=4))
        forestg <- forestg %>% add_trace(y=~South_America, name='South America',line=list(color='476d46',width=2))
        forestg <- forestg %>% add_trace(y=~Africa, name='Africa',line=list(color='#bbc5aa',width=2))
        forestg <- forestg %>% add_trace(y=~Europe, name='Europe',line=list(color='abb695',width=3,dash='dot'))
        forestg <- forestg %>% layout(yaxis=list(title='Millions of Square Km'))
        forestg
    })

    
    
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
    
    output$fishg <- renderPlotly({
        fishg <- plot_ly(fish,type='choropleth',locations=~ISO,z=~Species,zauto=FALSE,zmin=0,zmax=260,
                         colorscale='YlOrRd',reversescale=TRUE)
        fishg <- fishg %>% colorbar(title='Threatened Species')
        fishg
    })
    
    output$mammalg <- renderPlotly({
        mammalg <- plot_ly(mammal,type='choropleth',locations=~ISO,z=~Species,zauto=FALSE,zmin=0,zmax=200,
                           colorscale='YlOrRd',reversescale=TRUE)
        mammalg <- mammalg %>% colorbar(title='Threatened Species')
        mammalg
    })
    
    output$birdg <- renderPlotly({
        birdg <- plot_ly(bird,type='choropleth',locations=~ISO,z=~Species,zauto=FALSE,zmin=0,zmax=175,
                         colorscale='YlOrRd',reversescale=TRUE)
        birdg <- birdg %>% colorbar(title='Threatened Species')
        birdg
    })
    
    output$plantg <- renderPlotly({
        plantg <- plot_ly(plant,type='choropleth',locations=~ISO,z=~Species,zauto=FALSE,zmin=0,zmax=1000,
                          colorscale='YlOrRd',reversescale=TRUE)
        plantg <- plantg %>% colorbar(title='Threatened Species')
        plantg
    })


#ACTION reactive:
    energyd1 <- reactive({
        energyd1 <- energy %>%
            filter(Country==input$Country1) %>%
            pivot_longer(cols=c(hydro,nonhydro,nonrenewable),names_to='Energy_type')
    }) 
    
    energyd2 <- reactive({
        energyd2 <- energy %>%
            filter(Country==input$Country2) %>%
            pivot_longer(cols=c(hydro,nonhydro,nonrenewable),names_to='Energy_type')
    }) 
    
    energyd3 <- reactive({
        energyd3 <- energy %>%
            filter(Country==input$Country3) %>%
            pivot_longer(cols=c(hydro,nonhydro,nonrenewable),names_to='Energy_type')
    }) 

    
#ACTION plot:
    
    output$energy1 <- renderPlotly({
        energyg <- plot_ly(energyd1(), type='pie',labels=~Energy_type,values=~value,
                           marker = list(colors = color3,line = list(color = '#FFFFFF', width = 1)))
        energyg
    })
    
    output$energy2 <- renderPlotly({
        energyg <- plot_ly(energyd2(), type='pie',labels=~Energy_type,values=~value,
                           marker = list(colors = color3,line = list(color = '#FFFFFF', width = 1)))
        energyg
    })
    
    output$energy3 <- renderPlotly({
        energyg <- plot_ly(energyd3(), type='pie',labels=~Energy_type,values=~value,
                           marker = list(colors = color3,line = list(color = '#FFFFFF', width = 1)))
        energyg
    })
#Link Download:
    output$climatechange <- downloadHandler(
        filename = "climatechange.pdf",
        content = function(file) {
            file.copy("www/climatechange.pdg", file)
        }
    )

 })
