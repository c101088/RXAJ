library(reshape2)

dXAJ<-function(modelParameter,basinInfo,basinData){
  
  dayResult<-.Call("dXAJ",modelParameter,basinInfo,basinData)
  
  totalR<-dayResult["stationQcal"]
  totalR<-totalR*24*3.6
  sumResult<-as.data.frame(basinData[[4]]$Date,dayResult["totalP"],dayResult["totalE"],dayResult["totalR"])
  sumResultBalance<-sumResult
  sumResultBalance$Date<-sapply(sumResultBalance$Date,function(x){strsplit(x,"-")[[1]][1]})
  dcast()  
  
  
  return()
}

hXAJ<-function(modelParameter,basinInfo,basinData){
  
  res<-.Call("hXAJ",modelParameter,basinInfo,basinData)
  
  
}
