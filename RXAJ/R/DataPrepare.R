##This script is used for data preparation

parameterName<-c("KC","UM","LM","C","WM","B","IM","SM","EX","KG","KI","CI","CG","CS","L","KE","XE")


dayParameterValue<-c(0.5,15,80,0.15,180,0.2,0.03,0,1.2,0,0,0,0,0,0,0,0)
hourParameterValue<-c(0.5,15,80,0.15,180,0.2,0.03,0,1.2,0,0,0,0,0,0,0,0)


modelPapameter<-data.frame(dayParameterValue,hourParameterValue)
rownames(modelPapameter)<-parameterName

