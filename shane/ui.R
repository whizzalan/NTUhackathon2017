navbarPage("HackNTU",
           tabPanel("",
                tags$head(tags$link(rel = "stylesheet", 
                                    type = "text/css", 
                                    href = "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css")), 
                tags$head(tags$link(rel = "stylesheet", 
                                    type = "text/css", 
                                    href = "//fonts.googleapis.com/css?family=Lobster")),  
                tags$head(tags$link(rel = "stylesheet", 
                                    type = "text/css", 
                                    href = "//fonts.googleapis.com/css?family=Indie+Flower")),     
                tags$head(includeScript("main.js")), 
                sidebarLayout(
                    sidebarPanel(
                        helpText("  Personal Income"),
                        textInput("income_company_input_id", 
                                  label = h4("公司名稱"), 
                                  value = "中信金控"
                        ),
                        selectInput("income_category_input_id", 
                                    label = h4("產業類別"), 
                                    choices = as.list(income_category_input), 
                                    selected = 1
                        ),
                        selectInput("income_city_input_id", 
                                  label = h4("公司地點"), 
                                  choices = as.list(income_city_input), 
                                  selected = 1
                                  
                        ),
                        textInput("income_title_input_id", 
                                  label = h4("職位名稱"), 
                                  value = "儲備幹部"
                        ),                        
                        helpText("  House Price"),
                        selectInput("house_region_input_id", 
                                    label = h4("鄉鎮市區"), 
                                    choices = as.list(house_region_input), 
                                    selected = 1
                                    
                        ),
                        textInput("house_age_input_id", 
                                  label = h4("屋齡 (年)"), 
                                  value = 8
                        ),
                        textInput("house_floor_input_id", 
                                  label = h4("樓層"), 
                                  value = 5
                        ), 
                        selectInput("house_type_input_id", 
                                    label = h4("建物型態"), 
                                    choices = as.list(house_type_input), 
                                    selected = 2
                                    
                        ),
                        textInput("house_transfer_input_id", 
                                  label = h4("建物移轉總面積 (平方公尺)"), 
                                  value = 130
                        ),
                        textInput("house_tall_input_id", 
                                  label = h4("總樓層數"), 
                                  value = 5
                        ),  
                        selectInput("house_room_input_id", 
                                  label = h4("房間數"), 
                                  choices = as.list(0:8), 
                                  selected = 4
                        ),     
                        selectInput("house_car_input_id", 
                                  label = h4("車位數"), 
                                  choices = as.list(0:6), 
                                  selected = 1
                        )                         
                    ),
                mainPanel(
                    fluidRow(
                        column(4,
                               
                               textInput("pred_loan_input_id", 
                                         label = h4("預期貸款總額"),
                                         value = 10000000
                               )
                               ),
                        column(4,
                               
                               textInput("pred_duration_input_id", 
                                         label = h4("預期還款年限"),
                                         value = 20
                               )
                        ),   
                        column(4,
                               textInput("pred_rate_input_id", 
                                         label = h4("房貸利率 (%)"),
                                         value = 2
                               )
                        ),     
                        column(4,
                               
                               textInput("pred_house_price_input_id", 
                                         label = h4("房價總額")
                                        
                               )
                        ),   
                        column(4,
                               
                               textInput("pred_loan_rate_input_id", 
                                         label = h4("可貸成數 (%)"),
                                         value = 70
                               )
                        ),      
                        column(4,
                               textInput("pred_income_input_id", 
                                         label = h4("月收入")
                    
                        )
                        ),
                        
                            plotOutput("plot"),
                            plotOutput("plot1")
                        
                        )
                    )
                 
        )
    )
)
   