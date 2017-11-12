resultData<-dXAJ(modelParameter =hhData[[1]]$dayParameterValue,basinInfo = hhData[[2]],basinData = hhData[[3]])
NSE(dayResult$stationQcal,basinData[[5]]$Qmea)
showResult()

resultData<-hXAJ(modelParameter = hhData[[1]]$hourParameterValue,basinInfo = hhData[[2]],basinData = floodData1)
showResult(hhData$floodData1$hourQ$YMDHM,resultData$outP,resultData$stationQcal,floodData1$hourQ$Qmea)