action <-
  tabPanel('Action',
           sidebarLayout(
             sidebarPanel(
               selectInput('Country','Pick a Country',
                           energy$Country)),
             mainPanel(
               plotlyOutput('energyg')
             )
           
           
           )
  )
