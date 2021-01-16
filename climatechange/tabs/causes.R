causes <-
  tabPanel('Causes',
   sidebarPanel(
#formatting needs adjusting once all graphs are in
      plotlyOutput('globalffg'),
      plotlyOutput('donut1')
   ), 
   
   mainPanel(
     plotlyOutput('CO2g'),
     plotlyOutput('ff100g'),
     plotlyOutput('donut2')
   )
  )
