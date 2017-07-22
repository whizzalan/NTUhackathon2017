data = read.csv('Taipei_land.csv', header=TRUE, fileEncoding = 'big5')
data1 = read.csv('taipei_land_當期.csv', header=TRUE, fileEncoding = 'utf-8')
data = rbind(data, data1[,-31])
rm(data1)
data = data[,-1]
data$交易年月日 = as.Date(data$交易年月日)
data = subset(data, (多層==0 | (多層==1 & 建物型態=='透天厝')) & is.na(單價每平方公尺)==FALSE & 主要用途=='住家用' & 交易年月日>='2016-01-01')
data = data[,-c(2,3,4,6,7,8,10,12,13,18:20,22,24:26,28,29)]

##
data$建物移轉總面積平方公尺 = data$建物移轉總面積平方公尺*0.3
data$單價每平方公尺 = data$單價每平方公尺/0.3
data$建物型態 = as.character(data$建物型態)
data$建物型態 = sapply(1:nrow(data), function(i){
  if (data$建物型態[i]=='透天厝') return('1')
  else return('0')
})
data$有無管理組織 = as.character(data$有無管理組織)
data$有無管理組織 = sapply(1:nrow(data), function(i){
  if (data$有無管理組織[i]=='有') return('1')
  else return('0')
})
I = which(data$建物型態==1)
data$樓層[I] = 1

##
model = randomForest(單價每平方公尺~., data=data)
predict_ans = function(city, house_age, floor, type, area, rooms, manage, car){
  data = data.frame(鄉鎮市區=city, 屋齡=house_age, 樓層=floor, 建物型態=type
                        , 建物移轉總面積平方公尺=area
                        , 建物現況格局.房=rooms, 有無管理組織=manage, 車位數=car)
  p = predict(model,data)
  return(round(p))
}
