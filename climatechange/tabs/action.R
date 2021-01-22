action <-
  tabPanel('Action',
           sidebarLayout(
             sidebarPanel(
               selectInput('Country1','Pick a Country',
                           energy$Country),
               selectInput('Country2','Pick a Country',
                           energy$Country),
               selectInput('Country3','Pick a Country',
                           energy$Country)),
             mainPanel(
               plotlyOutput('energy1'),
               plotlyOutput('energy2'),
               plotlyOutput('energy3')
             )
           
           
           )
  )
