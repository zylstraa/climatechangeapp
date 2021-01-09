causes <-
  tabPanel('Causes',
   sidebarPanel(
#notice this is a GG PLOT not plotly, will need to be adjusted
      plotOutput('tempplot')
   ), 
   
   mainPanel(
     plotlyOutput('CO2plot')
   )
  )
