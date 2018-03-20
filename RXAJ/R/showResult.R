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

changeModelParameter<-function(parameterValue,paraIndex,value){
  parameterName<-c("KC","UM","LM","C","WM","B","IM","SM","EX","KG","KI","CI","CG","CS","L","KE","XE")
  funFlag = FALSE
  if (length(parameterValue)!= 17){
    
    stop("The parameterValue is not correct!!")
  }
  
  
  if (!is.numeric(value)){
    
    stop("The value should be numeric!")
  }
  for(i in 1:length(parameterValue)){
    if(parameterName[i]==paraIndex){
      funFlag = TRUE
      parameterValue[i]<-value
    }
    
    
  }
  if(funFlag ==FALSE){
  stop("dThe paraInt correct,please check the uppercase!")
    
  }
  return(parameterValue)
}

