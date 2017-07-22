dat=read.csv(file = "Taipei_land.csv", fileEncoding ="big5")[,-29]
dat1=dat[-which(dat$羆基じ==0 | dat$计==0 | dat$羆基じ==dat$ó羆基じ),]  #⊿ユ肂,氨ó
dat1=dat1[-c(which(dat$羆基じ<10000),1:2),]
dat1=dat1[-which(grepl("克",as.character(dat1$称爹))),]

dat2=dat1[-union(which(is.na(dat1$虫基–キよそへ)),which(dat1$糷==1 & dat1$篈!="硓ぱ")),]

money=dat2$羆基じ-dat2$ó羆基じ
time=as.numeric(as.POSIXct(as.character(dat2$ユるら)))
mm=money/dat2$簿锣羆縩キよそへ
dat3=cbind(dat2,time,mm)
dat3$top=ifelse(dat3$加糷==dat3$羆加糷计,1,0)
dat3$加糷=as.factor(dat3$加糷)
dat3$羆加糷计=as.factor(dat3$羆加糷计)

dat4=dat3[which(dat3$璶ノ硚%in%c("產ノ","坝ノ","瓣チ")),]
dat4=dat4[,c(1,5,9,10,11,12,14,29:31)]

train=dat4[which(dat4$time<as.numeric(as.POSIXct("2017/1/1"))),]
test=dat4[which(dat4$time>=as.numeric(as.POSIXct("2017/1/1"))),]
## random forest
library("randomForest")
rm(dat);rm(dat1);rm(dat2);rm(dat3);rm(dat4);rm(mm);rm(money);rm(time)
gc()
model=randomForest(mm~.,dat=train)
# mean(abs(test$mm-predict(fit,test)))
# mean(abs(test$mm-mean(test$mm)))



final.model=function(model=model,dat){
    # dat <- test
    
    dat$time=as.numeric(Sys.time())
    dat$top=ifelse(dat$加糷==dat$羆加糷计,1,0)
    dat$璶ノ硚= factor(x=c("產ノ"), levels = levels(train$璶ノ硚))
    dat$闹=as.numeric(as.character(dat$闹))
    dat$加糷= factor(dat$加糷, levels = train$加糷 %>% levels)
    dat$羆加糷计= factor(dat$羆加糷计,levels = train$羆加糷计 %>% levels )
    dat$簿锣羆縩キよそへ=as.numeric(as.character(dat$簿锣羆縩キよそへ))
    result=predict(model,dat)
    return(result)
}
