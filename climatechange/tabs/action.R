action <-
  tabPanel('Action',
           sidebarLayout(
             sidebarPanel(
               textInput('Country',"Enter the country whose energy data you'd like to see",'United States of America')
             ),
             mainPanel(
               plotlyOutput('energyg')
             )
           
           
           )
  )
