causes <-
  tabPanel('Causes',
           sidebarLayout(
             sidebarPanel(
               selectInput('cause',"What data would you like to see?",
                           list('CO2 emissions globally','CO2 emissions by country','Deforestation')),
               br(rows=3),
               h3('Sources'),
               br(),
               conditionalPanel(
                 condition = "input.cause == 'CO2 emissions globally'",
                 fluidRow(
                   img(src = "images/cdiac.png", height=90,width=325)
                 )
               ),
               conditionalPanel(
                 condition = "input.cause == 'CO2 emissions by country'",
                 fluidRow(
                   img(src = "images/cdiac.png", height=90,width=325)
                 )
               ),
               conditionalPanel(
                 condition = "input.cause == 'Deforestation'",
                 fluidRow(
                   img(src = "images/deforestation.png", height=150,width=152)
                 )
               )
             ),
             mainPanel(
               conditionalPanel(
                 condition = "input.cause == 'CO2 emissions globally'",
                 fluidRow(
                   column(6,
                          tags$div(
                            (HTML('<h4 class="plotTitle">Global atmospheric CO2 levels (1958-2018)</h4>')),
                            plotlyOutput('CO2g'),
                          )
                   ),
                   column(6,
                          tags$div(
                            (HTML('<h4 class="plotTitle">Global CO2 Emissions from Fossil Fuels (1900-2014)</h4>')),
                            plotlyOutput('globalffg')
                          )
                   )
                 )
               ),
               conditionalPanel(
                 condition = "input.cause == 'CO2 emissions by country'",
               fluidRow(
                 column(6,
                        tags$div(
                          (HTML('<h4 class="plotTitle">CO2 fossil fuel emissions by country (in million metric tons)<br>Top Offenders</br>'))
                        ),
                        plotlyOutput('donut1g')
                 ),
                 column(6,
                        tags$div(
                          (HTML('<h4 class="plotTitle">CO2 fossil fuel emissions by country (in million metric tons)<br>Those contributing <2%</br>'))
                        ),
                        plotlyOutput('donut2g')
                 )
               )
               ),
               conditionalPanel(
                 condition = "input.cause == 'Deforestation'",
               fluidRow(
                 column(6,
                        tags$div(
                          (HTML('<h4 class="plotTitle">Forest Area by Continent in sq km (1990-2016)')),
                          plotlyOutput('forest1')
                        )
                 ),
                 column(6,
                        tags$div(
                          (HTML('<h4 class="plotTitle">Forest Area by Continent in sq km (1990-2016)')),
                          plotlyOutput('forest2')
                        )
                 )
               )
               )
             )
           )
  )

