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
hourRain<-sqlFetch(mycon,"ST_RNFL")
dayQ<-sqlFetch(mycon,"ST_DAYRIVER")

odbcClose(mycon)

library(reshape2)
data1<-dcast(data = dayEv,YMDHM~STCD)
