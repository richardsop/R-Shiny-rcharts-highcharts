require(rCharts)
shinyUI(pageWithSidebar(
  headerPanel("highcharts"),
  
  #sidebarPanel(
    #selectInput(inputId = "x",
     #           label = "Choose X",
      #          choices = c('L', 'T', 'VT'),
      #          selected = "L")
    #selectInput(inputId = "y",
     #           label = "Choose Y",
     #           choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
     #           selected = "SepalWidth")
  sidebarPanel(
    uiOutput("choose_Tunnel2"),
    uiOutput("choose_type"),
    uiOutput("choose_weeks5")
  ),
  mainPanel(
    showOutput("myChart", "highcharts")
  )
))