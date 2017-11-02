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
basinArea<-1380
basinInfo<-list(basinInfo,basinArea)

##The model time-control
##The colname of floodInfo is the index number of each flood


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

dayStart<-as.POSIXct("2003-1-1")
dayEnd<-as.POSIXct("2012-12-31")
dayEv$YMDHM<-strptime(dayEv$YMDHM,format = "%Y-%m-%d")
data1<-dcast(data = dayEv,YMDHM~STCD,value.var = "EA")
dayE<-data1[(difftime(dayEnd,data1$YMDHM,units = "days")>=0) & (difftime(dayStart,data1$YMDHM,units = "days")<=0),1:2]
colnames(dayE)<-c("Date","stationE")

data1<-dcast(data = dayRain,YMDHM~STCD,value.var = "PA")
dayP<-data1[(difftime(dayEnd,data1$YMDHM,units = "days")>=0) & (difftime(dayStart,data1$YMDHM,units = "days")<=0) ,1:ncol(data1)]
colnames(dayP)<-c("Date","stationP1","stationP2","stationP3","stationP4","stationP5","stationP6","stationP7","stationP8","stationP9")

dayQ<-dayQ[,-4:-5]
data1<-dcast(data = dayQ,YMDHM~STCD,value.var = "QA")
dayQ<-data1[(difftime(dayEnd,data1$YMDHM,units = "days")>=0) & (difftime(dayStart,data1$YMDHM,units = "days")<=0),1:ncol(data1)]
dayQ<-data.frame(dayQ,dayQ$`41107150`)
colnames(dayQ)<-c("Date","Qmea","Qcal")


initialValue<-as.data.frame(matrix(nrow = 8,ncol = 9))
colnames(initialValue)<-c("stationP1","stationP2","stationP3","stationP4","stationP5","stationP6","stationP7","stationP8","stationP9")
rownames(initialValue)<-c("WU","WL","WD","QS","QI","QG","SO","Fr0")
WU<-c(20,19.59,20,20,19.95,19.95,19.95,20,20)
WL<-rep(90,times=9)
WD<-rep(70,times=9)
QS<-rep(1.0,times=9)
QI<-rep(0.5,times=9)
QG<-rep(0.5,times=9)
S0<-rep()
initialValue[1,]<-WU
initialValue[2,]<-WL
initialValue[3,]<-WD

dayData<-list(dayStart,dayEnd,dayE,dayP,dayQ,initialValue)



dataE<-dcast(data = hourEv,YMDHM~STCD)
hourQ<-hourQ[,-4:-5]
dataQ<-dcast(data =hourQ,YMDHM~STCD)
dataP<-dcast(data = hourRain,YMDHM~STCD,mean,value.var = "P")

colnames(dataE)<-c("YMDHM","stationE")
dataQ<-data.frame(dataQ,dataQ$`41107100`)
colnames(dataQ)<-c("YMDHM","Qmea","Qcal")
colnames(dataP)<-c("YMDHM","stationP1","stationP2","stationP3","stationP4","stationP5","stationP6","stationP7","stationP8","stationP9")


timeStart<-as.POSIXct("2003-8-26 22:00:00")
timeEnd<-as.POSIXct("2003-9-3 19:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData1<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2003-9-3 19:00:00")
timeEnd<-as.POSIXct("2003-9-9 12:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData2<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue)


timeStart<-as.POSIXct("2003-9-17 11:00:00 ")
timeEnd<-as.POSIXct("2003-9-24 8:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData3<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2004-9-2 14:00:00")
timeEnd<-as.POSIXct("2004-9-11 2:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData4<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2005-7-1 6:00:00")
timeEnd<-as.POSIXct("2005-7-8 1:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData5<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2005-9-25 20:00:00")
timeEnd<-as.POSIXct("2005-10-5 18:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData6<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2006-9-3 8:00:00")
timeEnd<-as.POSIXct("2006-9-7 9:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData7<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2006-9-25 7:00:00")
timeEnd<-as.POSIXct("2006-10-2 4:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData8<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2007-7-4 4:00:00")
timeEnd<-as.POSIXct("2007-7-10 21:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData9<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2008-7-19 9:00:00")
timeEnd<-as.POSIXct("2008-7-25 3:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData10<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2009-8-18 14:00:00")
timeEnd<-as.POSIXct("2009-8-25 1:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData11<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2010-7-15 8:00:00")
timeEnd<-as.POSIXct("2010-7-21 1:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData12<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2010-7-21 1:00:00")
timeEnd<-as.POSIXct("2010-7-27 8:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData13<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2010-8-18 20:00:00")
timeEnd<-as.POSIXct("2010-8-22 18:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0)& (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData14<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 


timeStart<-as.POSIXct("2010-8-22 18:00:00")
timeEnd<-as.POSIXct("2010-8-27 15:00:00")
hourE<-dataE[((difftime(timeStart,dataE$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataE$YMDHM,units="hours")>=0) ),1:ncol(dataE)]
hourQ<-dataQ[(difftime(timeStart,dataQ$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataQ$YMDHM,units="hours")>=0),1:ncol(dataQ)]
hourP<-dataP[(difftime(timeStart,dataP$YMDHM,units = "hours")<=0) & (difftime(timeEnd,dataP$YMDHM,units="hours")>=0),1:ncol(dataP)]
floodData15<-list(timeStart,timeEnd,hourE,hourP,hourQ,initialValue) 

hhData<-list(modelPapameter,basinInfo,dayData,floodData1,floodData2,floodData3,floodData4,floodData5
                ,floodData6,floodData7,floodData8,floodData9,floodData10,floodData11,floodData12,floodData13,floodData14,floodData15)