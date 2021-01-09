globalcauses <-
  tabPanel('Global Causes',
   sidebarPanel(
     plotOutput('tempplot')
   ), 
   
   mainPanel(
     plotlyOutput('CO2plot')
   )
  )
