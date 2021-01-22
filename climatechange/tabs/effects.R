effects <-
  tabPanel('Effects',
           sidebarLayout(
             sidebarPanel(               
               selectInput('effect',"What data would you like to see?",
                           list('Sea level & Flooding','Natural Disasters','Threatened Species')),
               br(rows=3),
               h3('Sources'),
               br(),
               conditionalPanel(
                 condition = "input.effect == 'Sea level & Flooding'",
                 fluidRow(
                   tags$a(img(src = "images/epa.png", height=90,width=325),href='https://www.epa.gov/climate-indicators/climate-change-indicators-sea-level')
                 ),
                 fluidRow(
                   tags$a(img(src = "images/emdat.png", height=90,width=325),href='https://www.emdat.be/')
                 )
               ),
               conditionalPanel(
                 condition = "input.effect == 'Natural Disasters'",
                 fluidRow(
                   tags$a(img(src = "images/emdat.png", height=90,width=325),href='https://www.emdat.be/')
                 )
               ),
               conditionalPanel(
                 condition = "input.effect == 'Threatened Species'",
                 fluidRow(
                   tags$a(img(src = "images/fish.png", height=90,width=325),href='https://www.fishbase.se/search.php')
                  ),
                 fluidRow(
                   tags$a(img(src = "images/mammal.png", height=223,width=240),href='https://www.iucnredlist.org/')
                 )
             )
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
           )),
           conditionalPanel(
             condition = "input.effect == 'Threatened Species'",
             tabsetPanel(type = "tabs",
                  tabPanel('Fish',
                      fluidRow(
                        column(12,
                               tags$div(
                                 (HTML('<h4 class="plotTitle">Number of Fish Species considered Threatened (2018)</h4>')),
                                 plotlyOutput('fishg'))
                      ))),
                  tabPanel('Mammal',
                           fluidRow(
                             column(12,
                                tags$div(
                                  (HTML('<h4 class="plotTitle">Number of Mammal Species considered Threatened (2018)</h4>')),
                                  plotlyOutput('mammalg')
                                    )
                           ))
                        ),
                  tabPanel('Bird',
                           fluidRow(
                             column(12,
                             tags$div(
                               (HTML('<h4 class="plotTitle">Number of Bird Species considered Threatened (2018)</h4>')),
                               plotlyOutput('birdg')
                             )
                           ))
                           ),
                  tabPanel('Plants',
                           fluidRow(
                             column(12,
                                tags$div(
                                  (HTML('<h4 class="plotTitle">Number of Plant Species considered Threatened (2018)</h4>')),
                                  plotlyOutput('plantg')
                                    ))
                           ))
    
  )
  )
)
) )
