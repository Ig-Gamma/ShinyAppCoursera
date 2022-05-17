#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Fitting Data from mtcars"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          selectInput('xaxis','X variable',names(mtcars)),
          selectInput('yaxis','Y variable',names(mtcars)),
          checkboxInput('fitbox','fit'),
          conditionalPanel(condition='input.fitbox==true',  
                           selectInput('fitMtd','fitting method',c("linear","poly2","poly3","exp"))
                           ),
        conditionalPanel(condition='input.fitbox==true',  
                         checkboxInput('fitPr','predict')
                           ),
        
        conditionalPanel(condition='input.fitPr==true & input.fitbox==true',  
                        selectInput("methodPred","enter value to predict", c("enter with value","enter with slider"))
                         ),
        conditionalPanel(condition='input.fitPr==true & input.fitbox==true',  
                         uiOutput("boundaries")
                         )
      
        ),

        # Show a plot of the generated distribution
        mainPanel( 
            plotOutput("distPlot"),
            textOutput("Rsq"),
            textOutput("text"),
        )
    )
))
