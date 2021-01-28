#UI Source pages 
source("tabs/causes.R")
source('tabs/effects.R')
source('tabs/action.R')
source('tabs/homepage.R')






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
