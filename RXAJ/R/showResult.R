# library(recharts)
##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title this function is used for showing the simulation in chart
##' @param Date the date series
##' @param P the precipitation series
##' @param Qcal the calculated discharge series
##' @param Qmea the measured discharge series
##' @return a chart object which will be showed in Plots windows
##' @author CHEN Longzan
showResult<-function(Date,P,Qcal,Qmea){
  
  ext<-list(
    
    xAxis=list(
      type="category",
      data=Date
      
    ),
    
    yAxis=list(
      list(
        type ="value",
        name="discharge(m3·s-1)",
        splitNumber="5",
        min = "0",
        max ="1000"
      ),
      list(
        type = "value",
        name = "precipitation(mm)",
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
##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title This function is used for calculating the Nash-Sutcliffe efficiency coefficient
##' @param Qcal the calculated discharge
##' @param Qmea the measured discharge
##' @return the Nash-Sutcliffe efficiency coefficient
##' @author CHEN Longzan
NSE<-function(Qcal,Qmea){
  
  return(1-sum((Qmea-Qcal)^2)/sum((Qmea-mean(Qmea))^2))
  
  
}
##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title change the model parameter
##' @param parameterValue the parameter value series which corresponded to the parameter name series
##' @param paraIndex the name of parameter which will be modified
##' @param value the new value of parameter which will be modified
##' @return the new parameter series
##' @author CHEN　Longzan
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

