action <-
  tabPanel('Action',
           sidebarLayout(
             sidebarPanel(
               selectInput('Country1','Pick a Country',
                           energy$Country)),
             mainPanel(
               plotlyOutput('energy1')
             )
           
           
           )
  )
