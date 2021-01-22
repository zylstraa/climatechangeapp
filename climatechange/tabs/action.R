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
               fluidRow(
                column(width=4,
                  plotlyOutput('energy1')),
               column(width=4,
                  plotlyOutput('energy2')),
               column(width=4,
                  plotlyOutput('energy3'))
             )
             )
           
           )
  )
