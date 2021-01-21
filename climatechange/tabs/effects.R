effects <-
  tabPanel('Effects',
           sidebarLayout(
             sidebarPanel(               
               selectInput('effect',"What data would you like to see?",
                           list('Sea level & Flooding','Natural Disasters','Threatened Species'))
             ),
           mainPanel(
             conditionalPanel(
               condition = "input.effect == 'Sea level & Flooding'",
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
           )),
           conditionalPanel(
             condition = "input.effect == 'Natural Disasters'",
              fluidRow(
                column(12,
                    tags$div(
                      (HTML('<h4 class="plotTitle">Natural Disaster occurence by Country</h4>')),
                      plotlyOutput('disasterg'),
                    )
             )
           ))
    
  )
  )
)
