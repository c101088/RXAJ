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
  try(load("dayResult"),stop("Error in read the Day Model Result ,please run the follow check list:\n 1.set the workstation \n 2.run the dayModel"))
    
  numDiff<-floor(difftime(floodData$timeStart,dayStart,units = "days"))
  cat(numDiff)
  floodData$initialValue[1,]<-dayResult$outWu[numDiff,]
  floodData$initialValue[2,]<-dayResult$outWl[numDiff,]
  floodData$initialValue[3,]<-dayResult$outWd[numDiff,]
  floodData$initialValue[4,]<-dayResult$outQs0[numDiff,]
  floodData$initialValue[5,]<-dayResult$outQi0[numDiff,]
  floodData$initialValue[6,]<-dayResult$outQg0[numDiff,]
  floodData$initialValue[7,]<-dayResult$outS0[numDiff,]
  floodData$initialValue[8,]<-dayResult$outFr0[numDiff,]
  return(floodData)

}


sourceCpp("hXAJ.cpp")
hXAJ<-function(modelParameter,basinInfo,basinData){

  res<-.Call("hXAJ",modelParameter,basinInfo,basinData)


}
