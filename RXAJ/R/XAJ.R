library(reshape2)
library(lubridate)

dXAJ<-function(modelParameter,basinInfo,basinData){
  
  dayResult<-.Call("dXAJ",modelParameter,basinInfo,basinData)
  
  totalR<-dayResult[[12]]
  totalR<-totalR*24*3.6
  sumResult<-as.data.frame(basinData[[4]]$Date,dayResult[[11]],dayResult[[10]],totalR,dayResult[[4]])
  sumResultBalance<-sumResult
  sumResultBalance$Date<-year(sumResultBalance$Date)
  sumResultBalance<-melt(sumResultBalance,id=c("Date"))
  sumResultBalance<-dcast(sumResultBalance,Date~variable,sum) 
  
  
  
  return()
}

hXAJ<-function(modelParameter,basinInfo,basinData){
  
  res<-.Call("hXAJ",modelParameter,basinInfo,basinData)
  
  
}

