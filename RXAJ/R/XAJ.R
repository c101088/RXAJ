library(reshape2)
library(lubridate)
library(recharts)
dXAJ<-function(modelParameter,basinInfo,basinData){
  
  dayResult<-.Call("dXAJ",modelParameter,basinInfo,basinData)
  
  totalR<-dayResult[[12]]
  totalR<-totalR*24*3.6
  sumResult<-as.data.frame(basinData[[4]]$Date,dayResult[[11]],dayResult[[10]],totalR,dayResult[[4]])
  sumResultBalance<-sumResult
  sumResultBalance$Date<-year(sumResultBalance$Date)
  sumResultBalance<-melt(sumResultBalance,id=c("Date"))
  sumResultBalance<-dcast(sumResultBalance,Date~variable,sum) 
  
  showResult(sumResult)
  
  return()
}

hXAJ<-function(modelParameter,basinInfo,basinData){
  
  res<-.Call("hXAJ",modelParameter,basinInfo,basinData)
  
  
}


showResult<-function(sumResult){
  
  ext<-list(
    
    xAxis=list(
      type="category",
      data=sumResult$Date
      
    ),
    
    yAxis=list(
      list(
        type ="value",
        name="流量(m3·s-1)"
      ),
      list(
        type = "value",
        name = "降雨量(mm)",
        inverse="true"
      )
      
    )
  )
  
  series<-list(
      list(
        name= "Qmea",
        type ="line",
        data = sumResult$Qmea,
        yAxisIndex = "0"
        
      ),
      list(
        name= "Qcal",
        type ="line",
        data = sumResult$Qcal,
        yAxisIndex = "0"
        
        
      ),
      list(
        name = "precipitation",
        type="bar",
        data = sumResult$P,
        yAxisIndex = "1"
        
        
      )

    )
  
  ePlot(series,ext)
}