home <-
  tabPanel('Home',
           tags$div(class='titlePanel',
           tags$h1(class='title','About the App')),
           br(rows=2),
           tags$div(class="bodyTextContainer",
                    HTML("<p>Welcome and thank you for stopping by my Climate Change App!
                         This app is designed to educate, inform, and hopefully inspire action. 
                         Each tab and graph has an icon link that leads to the data source. 
                         There is also adjustability and exploration to be done with each graph 
                         so make sure to click any buttons that look interesting. 
                         There's also access to the slides used to present this app. Enjoy!</p>"),
                    downloadLink('climatechange','Download Presentation'))
           )