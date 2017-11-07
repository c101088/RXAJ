library(recharts)

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
        splitNumber="6",
        min = "0",
        max ="2000"
      ),
      list(
        type = "value",
        name = "降雨量(mm)",
        inverse="true",
        splitNumber ="6",
        min ="0",
        max = "120"
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