setwd("E:/RXAJ/RXAJ/R")
source(showResult.R)
setwd("E:/RXAJ/RXAJ/src")
library(Rcpp) 
library(reshape2)
library(lubridate)

sourceCpp("dXAJ.cpp")

dXAJ<-function(modelParameter,basinInfo,basinData){
  # browser()
  dayResult<-.Call("dXAJ",modelParameter,basinInfo,basinData)
#  View(dayResult[[1]])
#  print("666!")

  # totalR<-dayResult[[12]]
  # totalR<-totalR*24*3.6
  # sumResult<-as.data.frame(basinData[[4]]$Date,dayResult[[11]],dayResult[[10]],totalR,dayResult[[4]][-1,])
  # sumResultBalance<-sumResult
  # sumResultBalance$Date<-year(sumResultBalance$Date)
  # sumResultBalance<-melt(sumResultBalance,id=c("Date"))
  # sumResultBalance<-dcast(sumResultBalance,Date~variable,sum)
  # View(sumResult)
  #showResult(basinData[[4]]$Date,dayResult[[11]],dayResult[[12]],basinData[[5]]$Qmea)
  basinData[[]]
  return(showResult(basinData[[4]]$Date[1:365],dayResult[[11]][1:365],dayResult[[12]][1:365],basinData[[5]]$Qmea[1:365]))
}

dXAJ(modelParameter =hhData[[1]]$dayParameterValue,basinInfo = hhData[[2]],basinData = hhData[[3]])
# 
# hXAJ<-function(modelParameter,basinInfo,basinData){
#   
#   res<-.Call("hXAJ",modelParameter,basinInfo,basinData)
#   
#   
# }

