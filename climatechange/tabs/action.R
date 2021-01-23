action <-
  tabPanel('Action',
           sidebarLayout(
             sidebarPanel(
               selectInput('Country1','Pick a Country',
                           energy$Country),
               selectInput('Country2','Pick a Country',
                           energy$Country),
               selectInput('Country3','Pick a Country',
                           energy$Country),
               br(rows=3),
               h3('Sources'),
               br(),
               tags$a(img(src = "images/iea.png", height=150,width=152),href='https://www.iea.org/fuels-and-technologies')),
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
