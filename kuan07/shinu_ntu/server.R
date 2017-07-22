library('httr')
library('dplyr')
library(jsonlite)
library(stringr)
api1 = function(city, dist){
  ## token
  input.body <- '{
  "CustID":"F299588108",
  "UserID":"F299588108",
  "PIN":"8108",
  "Token":"123456789"
}
' %>% jsonlite::fromJSON()

login_url='http://54.65.120.143:8888/hackathon/login'

token_output<-httr::POST(url = login_url,
                         body = input.body,
                         encode = "json")
token=content(token_output)$Token

## data
data <- list(CustID = 'F299588108', Token = token ,City=city,Dist=dist)

url='http://54.65.120.143:8888/hackathon/HouseValuation'
HouseValuation_output<-httr::POST(url = url,
                                  body = data,
                                  encode = "json")
datmat <- HouseValuation_output %>% content(as="text") %>% 
  gsub(pattern = '["\n\r\t{}]',replacement = "") %>% strsplit(split = ",") %>% 
  .[[1]] %>% str_split(":") %>% unlist %>% matrix(ncol =2,byrow = TRUE)
dat <- data.frame()
dat <- rbind(dat,datmat[,2])
colnames(dat) <- datmat[,1]

# 公寓每坪單價(萬)
ApartmentPrice = as.numeric(as.character(dat$ApartmentPrice))

#大樓每坪單價(萬)
MansionPrice = as.numeric(as.character(dat$MansionPrice))

return(list(ApartmentPrice=ApartmentPrice,MansionPrice=MansionPrice))
}
api2 = function(CustID){
  ## token
  input.body <- '{
  "CustID":"F299588108",
  "UserID":"F299588108",
  "PIN":"8108",
  "Token":"123456789"
}' %>% jsonlite::fromJSON()

  login_url='http://54.65.120.143:8888/hackathon/login'
  
  token_output<-httr::POST(url = login_url,
                           body = input.body,
                           encode = "json")
  token=content(token_output)$Token
  
  ## data
  data <- list(Token = token, CustID=CustID)
  
  url='http://54.65.120.143:8888/hackathon/CreditCardLimit'
  CreditCardLimit_output<-httr::POST(url = url,
                                     body = data,
                                     encode = "json")
  datmat <- CreditCardLimit_output %>% gsub(pattern = '["\n\r\t{}]',replacement = "") %>% 
    str_split(pattern='\\[',n = 2) %>% .[[1]] %>% .[2] %>% str_split(pattern='\\]',n = 2) %>% .[[1]] %>% .[1] %>% 
    str_split(":") %>% .[[1]] %>% strsplit(split = ",") %>% unlist %>% matrix(ncol =2,byrow = TRUE)
  dat <- data.frame()
  dat <- rbind(dat,datmat[,2])
  colnames(dat) <- datmat[,1]
  
  CreditCardLimit = as.numeric(as.character(dat$CreditCardLimit))
  AvailableCredit = as.numeric(as.character(dat$AvailableCredit))
  CreditInterestRate = as.numeric(as.character(dat$CreditInterestRate))
  
  return(list(CreditCardLimit=CreditCardLimit,AvailableCredit=AvailableCredit,CreditInterestRate=CreditInterestRate))
}
shinyServer(function(input, output) {

  output$table1 <- renderTable({
    dataset <- api1(input$city, input$dist)
    ApartmentPrice = dataset$ApartmentPrice
    MansionPrice = dataset$MansionPrice
    a1 <- data.frame(ApartmentPrice=ApartmentPrice, MansionPrice=MansionPrice)
    print(a1)
  })
  output$table2 <- renderTable({
    dataset <- api2(as.character(input$CustID))
    CreditCardLimit = dataset$CreditCardLimit
    AvailableCredit = dataset$AvailableCredit
    CreditInterestRate = dataset$CreditInterestRate
    a1 <- data.frame(CreditCardLimit=CreditCardLimit, AvailableCredit=AvailableCredit,CreditInterestRate=CreditInterestRate)
    print(a1)
  })

})
