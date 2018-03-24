
##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title provided the initial data which need by hour model
##' @param dayStart the date of the hour-model start
##' @param floodData the whole flood data 
##' @return the new flood data
##' @author CHEN Longzan
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

