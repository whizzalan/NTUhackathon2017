
library(dplyr)
library(magrittr)


function(input, output, clientData, session) {
    output$plot <- renderPlot({
 
        year_rate = as.numeric(input$pred_rate_input_id)
        
        year_count = as.numeric(input$pred_duration_input_id)
        income = as.numeric(input$pred_income_input_id)
        # total: ㄈ昂價*成數
        pred_loan_rate_input = as.numeric(input$pred_loan_rate_input_id)
        pred_house_price_input = as.numeric(input$pred_house_price_input_id)
        total = pred_house_price_input*pred_loan_rate_input/100
        ex_total = as.numeric(input$pred_loan_input_id)   
        
        plot2(year_rate, year_count, income, total, ex_total)
    })
    output$plot1 <- renderPlot({
        
        year_rate = as.numeric(input$pred_rate_input_id)
        
        year_count = as.numeric(input$pred_duration_input_id)
        income = as.numeric(input$pred_income_input_id)
        pred_loan_rate_input = as.numeric(input$pred_loan_rate_input_id)
        pred_house_price_input_id = as.numeric(input$pred_house_price_input_id)
        total = pred_house_price_input_id*pred_loan_rate_input
        ex_total = as.numeric(input$pred_loan_input_id)  
        house_price = as.numeric(input$pred_house_price_input_id)
        plot1(total,house_price)
    })
    observe({
        income_company_input = input$income_company_input_id
        income_category_input = input$income_category_input_id
        income_city_input = input$income_city_input_id
        income_title_input = input$income_title_input_id

        form_data = paste0('{"company":"', income_company_input, '","category":"', income_category_input, '","position":"', 
                           income_city_input, '","title":"', income_title_input, '"}')
        updateTextInput(session, "pred_income_input_id",
                        value = round(get_sarlary('http://127.0.0.1:5000/salary', form_data)/12, 0)
        )
        house_region_input = input$house_region_input_id
        house_age_input = as.numeric(input$house_age_input_id)
        house_floor_input = as.numeric(input$house_floor_input_id)
        house_tall_input = as.numeric(input$house_tall_input_id)
        house_type_input = input$house_type_input_id
        house_transfer_input = as.numeric(input$house_transfer_input_id)
        df = data.frame(鄉鎮市區 = house_region_input , 
                            屋齡 = house_age_input, 
                            樓層 = house_floor_input,
                            總樓層數 = house_tall_input , 
                            建物型態 = house_type_input ,
                            建物移轉總面積平方公尺=house_transfer_input
                            )

        result = final.model(model = model, dat = df)
        updateTextInput(session, "pred_house_price_input_id",
                        value = round(as.numeric(result)*house_transfer_input)
        )
        
    })
}

