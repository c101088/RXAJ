resultData<-dXAJ(modelParameter =hhData[[1]]$dayParameterValue,basinInfo = hhData[[2]],basinData = hhData[[3]])
NSE(dayResult$stationQcal,basinData[[5]]$Qmea)
showResult()