library(recharts)
library(Rcpp) 
library(lubridate)
##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title the hour model of XAJ model
##' @param modelParameter the model parameter
##' @param basinInfo the basin information
##' @param basinData the hour model data series
##' @return the hour model result series
##' @author CHEN Longzan 
hXAJ<-function(modelParameter,basinInfo,basinData){
  
  res<-.Call("hXAJc",PACKAGE = "RXAJ",modelParameter,basinInfo,basinData)
  
  
}
