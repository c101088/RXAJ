library(recharts)
library(Rcpp) 
library(lubridate)
##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title The flood model of XAJ model
##' @param hourModelParameter the model parameter
##' @param basinInfo the basin information
##' @param floodData the hour model data series
##' @return floodResult: the hour model result series
##' @author CHEN Longzan 
hXAJ<-function(hourModelParameter,basinInfo,floodData){
  cat("The simulation started from ",as.character(floodData[[1]])," and ended at ",as.character(floodData[[2]]),"\n")
  floodResult<-.Call("hXAJc",PACKAGE = "RXAJ",hourModelParameter,basinInfo,floodData)
  
  floodResult<-data.frame(floodData$hourQ$YMDHM,floodResult$outP,floodData1$hourQ$Qmea,floodResult$stationQcal)
  colnames(floodResult)<-c("Date","P","Qmea","Qcal")
  return(floodResult)
}
