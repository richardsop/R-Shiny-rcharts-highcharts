library(shiny)
library(RJSONIO)
library(plyr)
library(digest)
library(ggplot2)
library(labeling)
library(rCharts)
library(RODBC)
library(reshape2)
library(graphics)
library(shinythemes)
library(ISOweek)
dataP <- read.csv("2015_sept.csv")
data1 <- head(dataP,20000)
data1$Date <- as.POSIXct(data1$sTijd_date)
data1$Type <- data1$Type

shinyServer(function(input, output) {
  
  output$choose_type <- renderUI({
    selectInput("select1", label = h4("Type"), 
                choices = c("Select an option",as.character(sort(unique(data1$Type)))), selected = "Select an option", 
                multiple=FALSE, selectize=FALSE)
    
    #selectInput("select1", label = h4("Type"), 
    #            choices = as.character(sort(unique(data1$Type))), 
    #            multiple=FALSE, selectize=FALSE)
  })
  
  #output$choose_type <- renderUI({
  output$choose_Tunnel2 <- renderUI({
    selectInput("select10", label = h4("Tunnel"),  as.character(sort(unique(data1$Tunnel))))
  })
  
  
  output$choose_weeks5 <- renderUI({
    # If missing input, return to avoid error later in function
    #if(is.null(input$select23))
    #return()
    
    dateRangeInput("dates", 
                   label = "Date Range", 
                   start = Sys.Date() - 195, 
                   min = "2014-01-01",
                   max = Sys.Date() + 1)
  })
  

  
  output$myChart <- renderChart2({
    #if(is.null(input$select10) ){
    #if(as.character(sort(unique(data1$Type)))[1] != input$select1) {
      #h1 <- Highcharts$new()  
    dataPlot <- count(subset(data1, (Tunnel == input$select10) & (data1$Date >= as.POSIXct(as.character(input$dates[1])) & 
                                              (data1$Date <= as.POSIXct(as.character(input$dates[2])))) | (Type %in%  input$select1) ),  c("DI", "sTijd_date"))
    #}
   #else {
      #dataPlot <- count(subset(data1, (Tunnel == input$select10) & (data1$Date >= as.POSIXct(as.character(input$dates[1])) & (data1$Date <= as.POSIXct(as.character(input$dates[2])))) & (Type %in%  input$select1)),  c("DI", "sTijd_date"))
            
         #dataPlot <- count(subset(data1, (Tunnel == input$select10) & (data1$Date >= as.POSIXct(as.character(input$dates[1])) & (data1$Date <= as.POSIXct(as.character(input$dates[2])))) & (Type %in%  input$select1) ),  c("DI", "sTijd_date"))
      
      dataPlot<-dataPlot[,c("DI", "sTijd_date", "freq")]
      dataPlot1 <- dcast(dataPlot, ISOweek(sTijd_date) ~ DI, sum)
      #dataPlot1 <- dcast(dataPlot, ISOweek(sTijd_date) ~ DI_Code, sum)
      names(dataPlot1)[1]<-"hWeek"
      
      #more descriptive title	
      plot_title = input$select10
      
      h1 <- Highcharts$new()
      h1$chart(type = "column")
      

      
      h1$plotOptions(column = list(stacking = "normal"))    
      h1$set(width = 1200, height = 800, pointSize = 0) 
      h1$title(text = paste("Aantal meldingen voor", plot_title))
      #h1$exporting(enabled=T)
      colTotal=ncol(dataPlot1)
      names=colnames(dataPlot1)
      for (i in 2:colTotal){
        name<-names[i]
        data1<-dataPlot1[,i]
        h1$series(name = name, data = data1)   
      }
      h1$yAxis(title = list(text = "Logging counts"))
      if(length(dataPlot1$hWeek)==1){
        h1$xAxis(categories  = "Week", title = list(text = as.character(dataPlot1$hWeek)))
        
      }    else{
        h1$xAxis(categories  = dataPlot1$hWeek, title = list(text = "Week"))
      }
      h1$legend(symbolWidth = 80)

    #}
    h1$exporting(enabled=T)
    return(h1)
  })
})