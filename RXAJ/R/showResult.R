# library(recharts)

showResult<-function(Date,P,Qcal,Qmea){
  
  ext<-list(
    
    xAxis=list(
      type="category",
      data=Date
      
    ),
    
    yAxis=list(
      list(
        type ="value",
        name="流量(m3·s-1)",
        splitNumber="5",
        min = "0",
        max ="1000"
      ),
      list(
        type = "value",
        name = "降雨量(mm)",
        inverse="true",
        splitNumber ="5",
        min ="0",
        max = "250"
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

NSE<-function(Qcal,Qmea){
  
  return(1-sum((Qmea-Qcal)^2)/sum((Qmea-mean(Qmea))^2))
  
  
}

q1<-c(1,2,3,4,5)
q2<-c(5,4,3,2,1)
NSE(q1,q2)