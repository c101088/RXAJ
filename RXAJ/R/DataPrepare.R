##This script is used for data preparation

##The model parameter
parameterName<-c("KC","UM","LM","C","WM","B","IM","SM","EX","KG","KI","CI","CG","CS","L","KE","XE")

dayParameterValue<-c(0.5,15,80,0.15,180,0.2,0.03,0,1.2,0,0,0,0,0,0,0,0)
hourParameterValue<-c(0.5,15,80,0.15,180,0.2,0.03,0,1.2,0,0,0,0,0,0,0,0)

modelPapameter<-data.frame(dayParameterValue,hourParameterValue)
rownames(modelPapameter)<-parameterName

##The model time-control
##The colname of floodInfo is the index number of each flood
dayStart<-as.Date("2005-1-1")
dayEnd<-as.Date("2006-1-1")

floodInfo<-data.frame(row.names = c("startTime","endTime"))
floodInfo[,1]<-c("2005-11-11 14:00","2005-11-21 5:00")
colnames(floodInfo)[1]<-115100

##The basin Geographic information
##The colname of basinInfo is the station code of each sub-basin
basinInfo<-data.frame(row.names = c("sub-basin","sub-river"))
basinInfo[,1]<-c(1,1)
colnames(basinInfo)[1]<-454544



library(RODBC)
mycon<-odbcConnectAccess2007("E:/Rlanguage/data.mdb")
dayEv<-sqlFetch(mycon,"ST_DAYEV")
dayQ<-sqlFetch(mycon,"ST_DAYRIVER")
dayRain<-sqlFetch(mycon,"ST_DAYRNFL")
hourEv<-sqlFetch(mycon,"ST_EV")
hourQ<-sqlFetch(mycon,"ST_RIVER")

dayQ<-sqlFetch(mycon,"ST_DAYRIVER")

odbcClose(mycon)

library(RODBC)
mycon<-odbcConnect("heihe")
hourRain<-sqlFetch(mycon,"ST_RNFL")
odbcClose(mycon) 

##hourRain$YMDHM<-as.POSIXct(hourRain$YMDHM,format="%Y-%m-%d %H:%M:%S")
library(reshape2)
data1<-dcast(data = dayEv,YMDHM~STCD,value.var = "EA")
dayEv<-data1[difftime("2013-1-1 08:00:00",data1$YMDHM,units = "days")>0,1:2]
data1<-dcast(data = dayRain,YMDHM~STCD)
dayRain<-data1[difftime("2013-1-1 08:00:00",data1$YMDHM,units = "days")>0,1:ncol(data1)]
data1<-dcast(data = dayQ,YMDHM~STCD)
dayQ<-data1[difftime("2013-1-1 08:00:00",data1$YMDHM,units = "days")>0,1:ncol(data1)]
data1<-dcast(data = hourEv,YMDHM~STCD)
hourEv<-data1[difftime("2013-1-1 08:00:00",data1$YMDHM,units = "days")>0,1:ncol(data1)]
data1<-dcast(data =hourQ,YMDHM~STCD)
hourQ<-data1[difftime("2013-1-1 08:00:00",data1$YMDHM,units = "days")>0,1:ncol(data1)]
data1<-dcast(data = hourRain,YMDHM~STCD,mean,value.var = "P")
hourRain1<-data1[difftime("2013-1-1 08:00:00",data1$YMDHM,units = "days")>0,1:ncol(data1)]

