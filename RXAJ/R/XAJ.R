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
  View(sumResultBalance)
  save(sumResultBalance,file = "sumResultBalance")
  save(dayResult,file = "dayResult")

  resultData<-data.frame(basinData[[4]]$Date,dayResult[[11]],dayResult[[12]],basinData[[5]]$Qmea)
  colnames(resultData)<-c("Date","P","Qcal","Qmea")
  return(resultData)
}

initHourData<-function(dayStart,floodData){
  if(!load(dayReasult)){
    
    stop("Error in read the Day Model Result ,please run the follow check list:\n 1.set the workstation \n 2.run the dayModel")

  }
  
  
  numDiff<-difftime(floodData$timeStart,dayStart,units = "days")
  
  floodData$initialValue$WU<-dayResult$outWu[numDiff,]
  floodData$initialValue$WL<-dayResult$outWl[numDiff,]
  floodData$initialValue$WD<-dayResult$outWd[numDiff,]
  floodData$initialValue$QS<-dayResult$outQs0[numDiff,]
  floodData$initialValue$QI<-dayResult$outQi0[numDiff,]
  floodData$initialValue$QG<-dayResult$outQg0[numDiff,]
  floodData$initialValue$S0<-dayResult$outS0[numDiff,]
  floodData$initialValue$Fr0<-dayResult$outFr0[numDiff,]

}


# 
# hXAJ<-function(modelParameter,basinInfo,basinData){
#   
#   res<-.Call("hXAJ",modelParameter,basinInfo,basinData)
#   
#   
# }
