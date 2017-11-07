library(recharts)
setwd("E:/RXAJ/RXAJ/R")
source("showResult.R",encoding = "utf-8")
setwd("E:/RXAJ/RXAJ/src")
library(Rcpp) 
library(reshape2)
library(lubridate)

sourceCpp("dXAJ.cpp")

dXAJ<-function(modelParameter,basinInfo,basinData){
  # browser()
  cat("The simulation started from ",as.character(basinData[[1]])," and ended at ",as.character(basinData[[2]]),"\n")
  dayResult<-.Call("dXAJ",modelParameter,basinInfo,basinData)

  totalR<-dayResult[[12]]
  totalR<-totalR*24*3.6/basinInfo[[2]]
  sumResult<-data.frame(basinData[[4]]$Date,dayResult[[11]],dayResult[[10]],totalR,dayResult[[4]])
  colnames(sumResult)<-c("Date","P","E","R","W")
  sumResultBalance<-sumResult
  sumResultBalance$Date<-year(sumResultBalance$Date)
  sumResultBalance<-melt(sumResultBalance,id=c("Date"))
  sumResultBalance<-dcast(sumResultBalance,Date~variable,sum)
  sumResultBalance[,6]<-sumResultBalance[,2]-sumResultBalance[,3]-sumResultBalance[,4]-sumResultBalance[,5]
  colnames(sumResultBalance)[6]<-"sum"
  save(sumResultBalance,file = "sumResultBalance")
  
  return(dayResult)
}

dayResult<-dXAJ(modelParameter =hhData[[1]]$dayParameterValue,basinInfo = hhData[[2]],basinData = hhData[[3]])
NSE(dayResult$stationQcal,basinData[[5]]$Qmea)
showResult(basinData[[4]]$Date[1:365],dayResult[[11]][1:365],dayResult[[12]][1:365],basinData[[5]]$Qmea[1:365])
# 
# hXAJ<-function(modelParameter,basinInfo,basinData){
#   
#   res<-.Call("hXAJ",modelParameter,basinInfo,basinData)
#   
#   
# }
