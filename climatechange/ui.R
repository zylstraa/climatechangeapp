#UI Source pages 
source("globalcauses.r")
source('globaleffects.r')







# Define UI for application
shinyUI(

    # Application title
    navbarPage(title='Climate Change: Midcourse Project',
               globalcauses,
               globaleffects,
               #nationaldata,
               selected=globalcauses
        )
    )
