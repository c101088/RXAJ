library(recharts)
library(Rcpp) 
library(lubridate)


##'  \description{} The Day model of XINANJIANG hydrology model
##'
##' \details{} This function is the entrance of day-model, you may use it directly.
##' @title The day model of XAJ
##' @param dayModelParameter the model parameter series which corresponded to the parameter name series
##' @param basinInfo the basin information 
##' @param dayData the day model data series
##' @return resultData which including date,precipitation,calculated discharge,measured discharge
##' @author CHEN Longzan 
dXAJ<-function(dayModelParameter,basinInfo,dayData){
  cat("The simulation started from ",as.character(dayData[[1]])," and ended at ",as.character(dayData[[2]]),"\n")
  dayResult<-.Call("dXAJc",PACKAGE = "RXAJ",dayModelParameter,basinInfo,dayData)

  totalR<-dayResult[[12]]
  totalR<-totalR*24*3.6/basinInfo[[2]]
  sumResult<-data.frame(dayData[[4]]$Date,dayResult[[11]],dayResult[[10]],totalR,dayResult[[4]])
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
  
  resultData<-data.frame(dayData[[4]]$Date,dayResult[[11]],dayResult[[12]],dayData[[5]]$Qmea)
  colnames(resultData)<-c("Date","P","Qcal","Qmea")
  return(resultData)
}
