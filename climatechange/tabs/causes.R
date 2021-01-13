causes <-
  tabPanel('Causes',
   sidebarPanel(
#formatting needs adjusting once all graphs are in
      plotlyOutput('globalffg')
   ), 
   
   mainPanel(
     plotlyOutput('CO2g'),
     plotlyOutput('ff100g')
   )
  )
