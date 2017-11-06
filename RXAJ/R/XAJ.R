setwd("E:/RXAJ/RXAJ/src")
library(Rcpp) 
library(reshape2)
library(lubridate)
library(recharts)

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
  showResult(basinData[[4]]$Date,dayResult[[11]],dayResult[[12]],basinData[[5]]$Qmea)

  return()
}

dXAJ(modelParameter =hhData[[1]]$dayParameterValue,basinInfo = hhData[[2]],basinData = hhData[[3]])

hXAJ<-function(modelParameter,basinInfo,basinData){
  
  res<-.Call("hXAJ",modelParameter,basinInfo,basinData)
  
  
}


showResult<-function(Date,P,Qcal,Qmea){
  
  ext<-list(
    
    xAxis=list(
      type="category",
      data=Date
      
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
        data = Qmea,
        yAxisIndex = "0"
        
      ),
      list(
        name= "Qcal",
        type ="line",
        data = Qcal,
        yAxisIndex = "0"
        
        
      ),
      list(
        name = "precipitation",
        type="bar",
        data =P,
        yAxisIndex = "1"
        
        
      )

    )
  
  ePlot(series,ext)
}