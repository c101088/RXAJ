##This script is used for data preparation

##The model parameter
parameterName<-c("KC","UM","LM","C","WM","B","IM","SM","EX","KG","KI","CI","CG","CS","L","KE","XE")

dayParameterValue<-c(0.5,15,80,0.15,180,0.2,0.03,0,1.2,0,0,0,0,0,0,0,0)
hourParameterValue<-c(0.5,15,80,0.15,180,0.2,0.03,0,1.2,0,0,0,0,0,0,0,0)

modelPapameter<-data.frame(dayParameterValue,hourParameterValue)
rownames(modelPapameter)<-parameterName

##The colname of basinInfo is the station code of each sub-basin

basinInfo<-matrix(nrow = 2,ncol = 9)
basinInfo<-as.data.frame(basinInfo)
basinInfo[1,]<-c(0.082,0.158,0.150,0.051,0.095,0.098,0.134,0.187,0.045)
basinInfo[2,]<-c(1,6,5,5,3,4,2,2,1)
rownames(basinInfo)<-c("sub-basin","sub-river")
colnames(basinInfo)<-c("stationP1","stationP2","stationP3","stationP4","stationP5","stationP6","stationP7","stationP8","stationP9")

##The model time-control
##The colname of floodInfo is the index number of each flood
dayStart<-as.Date("2003-5-1")
dayEnd<-as.Date("2013-5-1")


library(RODBC)
mycon<-odbcConnectAccess2007("E:/Rlanguage/data.mdb")
dayEv<-sqlFetch(mycon,"ST_DAYEV")
dayQ<-sqlFetch(mycon,"ST_DAYRIVER")
dayRain<-sqlFetch(mycon,"ST_DAYRNFL")
hourEv<-sqlFetch(mycon,"ST_EV")
hourQ<-sqlFetch(mycon,"ST_RIVER")

odbcClose(mycon)

dayEv$YMDHM<-as.Date(dayEv$YMDHM)
hourRain<-read.csv("E:/Rlanguage/ST_RNFL.CSV",encoding = "UTF-8")
colnames(hourRain)[1]<-"STCD"
hourRain$YMDHM<-as.POSIXct(hourRain$YMDHM)

##hourRain$YMDHM<-as.POSIXct(hourRain$YMDHM,format="%Y-%m-%d %H:%M:%S")
library(reshape2)
data1<-dcast(data = dayEv,YMDHM~STCD,value.var = "EA")
dayE<-data1[(difftime("2013-12-31",data1$YMDHM,units = "days")>=0) && (difftime("2003-1-1",data1$YMDHM,units = "days")<=0),1:2]
colnames(dayE)<-c("Date","stationE")

data1<-dcast(data = dayRain,YMDHM~STCD,value.var = "PA")
dayP<-data1[(difftime("2013-12-31",data1$YMDHM,units = "days")>=0) && (difftime("2003-1-1",data1$YMDHM,units = "days")<=0) ,1:ncol(data1)]
colnames(dayP)<-c("stationP1","stationP2","stationP3","stationP4","stationP5","stationP6","stationP7","stationP8","stationP9")

dayQ<-dayQ[,-4:-5]
data1<-dcast(data = dayQ,YMDHM~STCD,value.var = "QA")
dayQ<-data1[(difftime("2013-12-31",data1$YMDHM,units = "days")>=0) && (difftime("2003-1-1",data1$YMDHM,units = "days")<=0),1:ncol(data1)]
dayQ<-data.frame(dayQ,dayQ$`41107150`)
colnames(dayQ)<-c("Date","Qmea","Qcal")


initialSoilWater<-as.data.frame(matrix(nrow = 3,ncol = 9))
colnames(initialSoilWater)<-c("stationP1","stationP2","stationP3","stationP4","stationP5","stationP6","stationP7","stationP8","stationP9")
rownames(initialSoilWater)<-c("WU","WL","WD")
WU<-c(20,19.59,20,20,19.95,19.95,19.95,20,20)
WL<-rep(90,times=9)
WD<-rep(70,times=9)
initialSoilWater[1,]<-WU
initialSoilWater[2,]<-WL
initialSoilWater[3,]<-WD

data1<-dcast(data = hourEv,YMDHM~STCD)
hourEv<-data1[difftime("2013-1-1 08:00:00",data1$YMDHM,units = "days")>0,1:ncol(data1)]
data1<-dcast(data =hourQ,YMDHM~STCD)
hourQ<-data1[difftime("2013-1-1 08:00:00",data1$YMDHM,units = "days")>0,1:ncol(data1)]
data1<-dcast(data = hourRain,YMDHM~STCD,mean,value.var = "P")
hourRain<-data1[difftime("2013-1-1 08:00:00",data1$YMDHM,units = "days")>0,1:ncol(data1)]

