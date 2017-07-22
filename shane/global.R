library(shiny)
library(httr)
library(jsonlite)
library("randomForest")
library(ggplot2)
library(magrittr)
library(dplyr)
load('final model.RData')
load('model_and_result.rda')

income_category_input = c('工商服務', '資訊科技', '電子機械', '其他材料', '傳統產業', 
                         '民生服務', '其他產業', '不動產業', '教育政府', '媒體出版', 
                         '醫藥農牧', '貿易流通', '百貨消費')

income_city_input = c('台北', '其它', '新竹', '高雄', '桃園', '香港', '北京', '苗栗', 
                      '台中', '台南', '南投', '彰化', '花蓮', '基隆', '雲林', '嘉義', 
                      '外島', '花東', '海外', '屏東')

house_region_input = c('萬華區', '大安區', '信義區', '北投區', '中山區', '士林區', '文山區', 
                       '內湖區', '中正區', '松山區', '大同區', '南港區')

house_type_input = c("公寓", "住宅大樓", "其他", "店面", "套房", "透天厝", "華廈", "廠辦", "辦公商業大樓")      

get_sarlary = function(url, form_data){
    input.body = fromJSON(form_data)
    res = POST(url = url,
               body = input.body,
               encode = "json")
    return(content(res)$value)
}

# year_rate: 房貸利率
# year_count: 預期還款期限
# income: 月薪
# total: ㄈ昂價*成數
# total: 月薪
## ex_total: 預期貸款總額

plot2 = function(year_rate, year_count, income, total, ex_total){
    ## data prepare
    month_rate = year_rate/1200
    month_count = year_count*12
    rate = month_rate/(1-(1+month_rate)^(-month_count))
    debt1 = round(total*rate) 
    debt2 = round(ex_total*rate) 
    
    ## df
    df <- data.frame(dummy=c('  月薪資', '每月攤還金額(預期)', ' 每月攤還金額(可貸)'),
                     金額=c(income,debt2,debt1))
    
    ##plot
    p<-ggplot(df, aes(x=dummy, y=金額, fill=dummy)) +
        geom_bar(stat="identity")+theme_minimal()+
        theme(axis.title.y = element_text(size=13),
              axis.title.x = element_text(size=13),
              axis.text.x = element_text(color="#000000", size=10),
              axis.text.y = element_text(color="#000000", size=10))+
        scale_fill_manual(values=c("#336666", "#CDAD00", "#CDAD00"))+ 
        geom_text(data = df, aes(x=1, y=income*1.05,label = paste0('(',income,')')), size=4)+ 
        geom_text(data = df, aes(x=3, y=debt2*1.1,label = paste0(round(debt2/income*100,1),'% (',debt2,')')), size=4)+ 
        geom_text(data = df, aes(x=2, y=debt1*1.1,label = paste0(round(debt1/income*100,1),'% (',debt1,')')), size=4)
    p
}

#total:房價*成數
#house_price:房價
plot1 = function(total,house_price){
    total = round(total)
    df <- data.frame(dummy=c('可貸總額'," 房價"),
                     金額=c(total,house_price))
    p<-ggplot(df, aes(x=dummy, y=金額, fill=dummy)) +
        geom_bar(stat="identity")+theme_minimal()+
        theme(axis.title.y = element_text(size=13),
              axis.title.x = element_text(size=13),
              axis.text.x = element_text(color="#000000", size=10),
              axis.text.y = element_text(color="#000000", size=10))+
        scale_fill_manual(values=c("#336666", "#CDAD00"))+ 
        geom_text(data = df, aes(x=1, y=house_price*1.1,label = paste0('(',house_price,')'), size=4))+
        geom_text(data = df, aes(x=2, y=total*1.1,label = paste0(round(total/house_price*100,1),'% (',total,')')), size=4)
    p  
}
library("randomForest")

colnames(train) <- colnames(train) %>% iconv(from = "big5", to = "utf8")
train %<>% mutate(
    鄉鎮市區 = 鄉鎮市區 %>% iconv(from = "big5", to = "utf8") %>% as.factor,
    建物型態 = 建物型態 %>% iconv(from = "big5", to = "utf8") %>% as.factor,
    主要用途 = 主要用途 %>% iconv(from = "big5", to = "utf8") %>% as.factor,
    樓層 = 樓層   %>% as.factor,
    總樓層數 = 總樓層數 %>%  as.factor
)

# final.model(dat = test)
# colnames(test) <- colnames(test) %>% iconv(from = "big5", to = "utf8")
# test %<>% mutate(
#     鄉鎮市區 = 鄉鎮市區 %>% iconv(from = "big5", to = "utf8") %>% as.factor,
#     建物型態 = 建物型態 %>% iconv(from = "big5", to = "utf8") %>% as.factor,
#     主要用途 = 主要用途 %>% iconv(from = "big5", to = "utf8") %>% as.factor,
#     樓層 = 樓層   %>% as.integer,
#     總樓層數 = 總樓層數 %>%  as.integer
# )


final.model=function(model=model, dat){
    # dat = test
    # dat %>% str
    dat$time=as.numeric(Sys.time())
    dat$top=ifelse(dat$樓層==dat$總樓層數,1,0)
    dat$鄉鎮市區= factor(dat$鄉鎮市區, levels = model$forest$xlevels$鄉鎮市區)
    dat$建物型態= factor(dat$建物型態, levels = model$forest$xlevels$建物型態)
    dat$主要用途= factor(x=c("住家用"), levels = model$forest$xlevels$主要用途)
    dat$屋齡=as.numeric(as.character(dat$屋齡))
    dat$樓層= factor(dat$樓層, levels = model$forest$xlevels$樓層)
    dat$總樓層數= factor(dat$總樓層數,levels =model$forest$xlevels$總樓層數)
    dat$建物移轉總面積平方公尺=as.numeric(as.character(dat$建物移轉總面積平方公尺))
    result=predict(model,dat)
    return(result)
}


# attributes(model)



options(shiny.usecairo = FALSE)

# 请忽略以下代码，它只是为了解决ShinyApps上没有中文字体的问题
font_home <- function(path = '') file.path('~', '.fonts', path)
if (Sys.info()[['sysname']] == 'Linux' &&
    system('locate wqy-zenhei.ttc') != 0 &&
    !file.exists(font_home('wqy-zenhei.ttc'))) {
    if (!file.exists('wqy-zenhei.ttc'))
        shiny:::download(
            'https://github.com/rstudio/shiny-examples/releases/download/v0.10.1/wqy-zenhei.ttc',
            'wqy-zenhei.ttc'
        )
    dir.create(font_home())
    file.copy('wqy-zenhei.ttc', font_home())
    system2('fc-cache', paste('-f', font_home()))
}
rm(font_home)