#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
 # creating a conditional slider when is "predict" is checked on
  output$boundaries<-renderUI({
    
    if (input$fitPr){
    x    <- mtcars[, input$xaxis]
  
    if (input$methodPred=="enter with slider") {
    sliderInput("Xpred",paste("move slider to enter ",input$xaxis, " value"),min=min(x),max=max(x), value=((min(x)+max(x))/2))
    }
    else
    if (input$methodPred=="enter with value") {
      textInput("Xpred",paste("enter value for",input$xaxis), (min(x)+max(x))/2)
      }
    
    }
  })
  
#  creating a plot for the main page with different appearences
  
    output$distPlot <- renderPlot({
#taking data from data set
      data1=mtcars
#getting values for x and y axes      
    x <- data1[, input$xaxis]
    y<- data1[, input$yaxis]
 #creating a plot with ggplot
    pL<-ggplot(data=data1, aes(x=x,y=y))+geom_point(color='red')+labs(title='data from mtcars',x=input$xaxis, y=input$yaxis)
    
    
# creating a fitting line with different models  
     if (input$fitbox) {
    
     if (input$fitMtd=="linear") 
      {fit <- lm(y~poly(x,1,raw=TRUE), data=data1)
     data1<-mutate(data1,my_model = predict(fit))
     space=data.frame(x=seq(min(x),max(x),length.out=100))
     data2<-data.frame(my_model=predict(object = fit, newdata = space),x=space)
     
    
     }
    
       if (input$fitMtd=="poly2") 
      {fit <- lm(y~poly(x,2,raw=TRUE), data=data1)
      data1<-mutate(data1,my_model = predict(fit))
      space=data.frame(x=seq(min(x),max(x),length.out=100))
      data2<-data.frame(my_model=predict(object = fit, newdata = space),x=space)
       }
      
      if (input$fitMtd=="poly3") 
      {fit <- lm(y~poly(x,3,raw=TRUE), data=data1)
      data1<-mutate(data1,my_model = predict(fit))
      space=data.frame(x=seq(min(x),max(x),length.out=100))
      data2<-data.frame(my_model=predict(object = fit, newdata = space),x=space)
      
      
      }
      
      if (input$fitMtd=="exp") 
      {fit <- lm(y~log(x), data=data1)
      data1<-mutate(data1,my_model = predict(fit))
      space=data.frame(x=seq(min(x),max(x),length.out=100))
      data2<-data.frame(my_model=predict(object = fit, newdata = space),x=space)
    
      }
#summary(fit)$r.squared
        # draw the histogram with the specified number of bins
       # plot(x, y)


 pL<-pL+geom_line(data=data2,aes(x,my_model))
 
 output$Rsq<-renderText(c("R^2= ",as.character(round(summary(fit)$r.squared, digits=4))))  
 
 if (input$fitPr){
   datPR<-data.frame(x1=as.numeric(input$Xpred),y1=predict(object=fit,newdata=data.frame(x=as.numeric(input$Xpred))))
   
  pL<-pL+geom_vline(xintercept = as.numeric(input$Xpred), lty=2)+geom_point(data=datPR,aes(x1,y1), col='blue') 
  output$text<-renderText(c("predicted value of", input$yaxis,"is", round(predict(object=fit,newdata=data.frame(x=as.numeric(input$Xpred))),digits=2))) 
 }
 
  }
# printing plot     
pL  
    })

})
