require(shiny)
require(ggplot2)
shinyUI(
  fluidPage(
    h1("CTBC: HouseValuation & CreditCardLimit API"),
    
    fluidRow(
      column(3,
             h4("Feature Setting:"),
             wellPanel(
               textInput("city", "city",value ='基隆市'),
               textInput("dist", "dist",value ='仁愛區'),
               textInput("CustID", "CustID",value ='F299588108'),
               actionButton("goButton", span("RUN", style="font-size: 30px"),icon("hand-o-right","fa-3x"))
               
             
      )),
      column(9,
             tabsetPanel(
               tabPanel("api output",
                        icon=icon("list-alt"),
                        h4("HouseValuation:"),
                        tableOutput("table1"),
                        br(),
                        br(),
                        h4("CreditCardLimit:"),
                        tableOutput("table2")
               )
             )
      )
    ))
)

