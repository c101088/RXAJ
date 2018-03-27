library(devtools)
library(roxygen2)
library(Rcpp)
setwd("E:\\RXAJ\\RXAJ")
file.edit("NAMESPACE")
roxygenize()
document()
check()
load_all()

search()

use_vignette("RXAJ_User_Manual")



knit("E:\\RXAJ\\RXAJ\\vignettes\\RXAJ_User_Manual.Rmd")
purl("E:\\RXAJ\\RXAJ\\vignettes\\RXAJ_User_Manual.Rmd")


resultData<-dXAJ(dayModelParameter =hhData[[1]]$dayParameterValue,basinInfo = hhData[[2]],dayData = hhData[[3]])
showResult(resultData$Date,resultData$P,resultData$Qcal,resultData$Qmea)
resultData<-hXAJ(hourModelParameter = hhData[[1]]$hourParameterValue,basinInfo = hhData[[2]],floodData = floodData3)