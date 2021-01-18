causes <-
  tabPanel('Causes',
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
           ),
            fluidRow(
               column(6,
                  tags$div(
                     HTML('<h4 class="plotTitle">CO2 fossil fuel emissions by country (in million metric tons)<br>Top Offenders</br>')),
                  plotlyOutput('donut1')
                  ),
               column(6,
                      tags$div(
                         HTML('<h4 class="plotTitle">CO2 fossil fuel emissions by country (in million metric tons)<br>Those contributing <2%</br>')),
                      plotlyOutput('donut2')
                      ),
               fluidRow(
                  column(12,
                     tags$div(
                        HTML('<h4 class="plotTitle">Area of forest in sq km (1990-2016)</h4>')),
                        plotlyOutput('forest')
                     )
                         )
            )
           )

