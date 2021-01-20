effects <-
  tabPanel('Effects',
           fluidRow(
             column(6,
                    tags$div(
                      (HTML('<h4 class="plotTitle">Sea Level Rise</h4>')),
                      plotlyOutput('seaplot'),
                    )
             ),
             column(6,
                    tags$div(
                      (HTML('<h4 class="plotTitle">Floods Reported</h4>')),
                      plotlyOutput('floodg')
                    )
             )
           ),
           fluidRow(
             column(12,
                    tags$div(
                      (HTML('<h4 class="plotTitle">Natural Disaster occurence by Country</h4>')),
                      plotlyOutput('disasterg'),
                    )
             )
           )
    
  )