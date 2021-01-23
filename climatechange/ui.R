#UI Source pages 
source("tabs/causes.r")
source('tabs/effects.r')
source('tabs/action.r')
source('tabs/homepage.r')






# Define UI for application
shinyUI(

    # Application title
    navbarPage(title='Climate Change',
               theme='style.css',
               home,
               causes,
               effects,
               action,
               selected=home
        )
    )
