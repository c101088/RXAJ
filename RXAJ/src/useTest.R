load("hhData")

resultData<-dXAJ(modelParameter =hhData[[1]]$dayParameterValue,basinInfo = hhData[[2]],basinData = hhData[[3]])
NSE(dayResult$stationQcal,basinData[[5]]$Qmea)
showResult(resultData$Date,resultData$P,resultData$Qcal,resultData$Qmea)

load("dayResult")
floodData3<-initHourData("2003-1-1",floodData3)
resultData<-hXAJ(modelParameter = hhData[[1]]$hourParameterValue,basinInfo = hhData[[2]],basinData = floodData3)
showResult(hhData$floodData3$hourQ$YMDHM,resultData$outP,resultData$stationQcal,floodData3$hourQ$Qmea)