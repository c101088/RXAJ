#include <Rcpp.h>
#include <math.h>
#include <RXAJ.h>
using namespace Rcpp;

// [[Rcpp::export]]
RcppExport SEXP XAJ(SEXP modelParameter1,SEXP basinInfo1,SEXP basinData1) {
  
  Rcpp::NumericVector modelParameter(modelParameter1);
  Rcpp::List basinInfo2(basinInfo1);
  Rcpp::List basinData(basinData1);
  
  
  Rcpp::DataFrame basinInfo(basinInfo2[0]);
  double basinArea = Rcpp::as<double>(basinInfo2[1]);
  Rcpp::DataFrame hourE(basinData[2]);
  Rcpp::DataFrame hourP(basinData[3]);
  Rcpp::DataFrame hourQ(basinData[4]);
  Rcpp::DataFrame initialValue(basinData[5]);
  Rcpp::function nrow("nrow");
  Rcpp::function ncol("ncol");
  
  double dlt =1;                                   //The dlt of hourModel is setted to 1 hours.
  int iT,iSub,i,j,k;
  int numT,numSub,reachSub;
  double weightVal,C0,C1,C2;
  
  C0=(0.5*dlt-KE*XE)/(0.5*dlt+KE-KE*XE);
  C1=(0.5*dlt+kE*XE)/(0.5*dlt+KE-KE*XE);
  C2=(-0.5*dlt+KE-KE*XE)/(0.5*dlt+KE-KE*XE);
  numT=nrow(hourE);
  numSub=ncol(hourP)-1;
  
  KC=modelParameter[0];UM=modelParameter[1];LM=modelParameter[2];C=modelParameter[3];WM=modelParameter[4];
  B=modelParameter[5];IM=modelParameter[6];SM=modelParameter[7];EX=modelParameter[8];KG=modelParameter[9];
  KI=modelParameter[10];CI=modelParameter[11];CG=modelParameter[12];CS=modelParameter[13];L=modelParameter[14];
  KE=modelParameter[15];XE=modelParameter[16];
  
  
  
  Rcpp::NumericVector stationE(hourE[1]);
  Rcpp::NumericVector stationQmea(hourQ[1]);
  Rcpp::NumericVector stationQcal(hourQ[2]);
  
  
//  Rcpp::NumericMatrix outWu= Rcpp::NumericMatrix::create(numT,numSub);
//  Rcpp::NumericMatrix outWl= Rcpp::NumericMatrix::create(numT,numSub);
//  Rcpp::NumericMatrix outWd= Rcpp::NumericMatrix::create(numT,numSub);
//  Rcpp::NumericMatrix outQs0= Rcpp::NumericMatrix::create(numT,numSub);
//  Rcpp::NumericMatrix outQi0= Rcpp::NumericMatrix::create(numT,numSub);
//  Rcpp::NumericMatrix outQg0= Rcpp::NumericMatrix::create(numT,numSub);
//  Rcpp::NumericMatrix outFr0= Rcpp::NumericMatrix::create(numT,numSub);
//  Rcpp::NumericMatrix outS0= Rcpp::NumericMatrix::create(numT,numSub);
  Rcpp::NumericVector outE= Rcpp::NumericVector::create(numT);
  Rcpp::NumericVector subQ=Rcpp::NumericVector::create(numT);
  Rcpp::NumericVector msjgQ=Rcpp::NumericVector::create(numT);
  
  DM=WM-UM-LM;
  WMM=(1+B)*WM/(1-IM);
  MS=(1+EX)*SM  
    
    
    for(iSub=0 ;iSub<numSub;iSub++){
      Rcpp::NumericVector stationP(hourP[iSub+1]);  
      Rcpp::NumericVector stationInit(initialValue[iSub]);
      Rcpp::NumericVector stationInfo(basinInfo[iSub]);
      Wu=stationInit[0];
      Wl=stationInit[1];
      Wd=stationInit[2];
      Qs0=stationInit[3];
      Qi0=stationInit[4];
      Qg0=stationInit[5];
      S0=stationInit[6];
      Fr0=stationInit[7];
      
      
      weightVal=stationInfo[0];
      reachSub=stationInfo[1];
      initQ=weightVal*stationQmea[0];
      RtoQ<-weightVal*basinArea/3.6/dlt;
      
      for(iT=0;iT<numT;iT++){
        
        ER(stationP[iT],stationE[iT]);
        
        outWu(iT,iSub)=Wu;
        outWl)iT,iSub)=Wl;
        outWd)iT,iSub)=Wd;
        outE[iT]=outE[iT]+(El+Eu+Ed)*weightVal;
        subQ[iT]=Qs+Qi+Qg;
        
      }
      
      for(i=0;i<numT;i++){          //as a hourModel ,L should be 0.
        if((i-L)<0){
          if(i==0) {
            subQ[i]=initQ;
          }else{
            subQ[i]=initQ*(1-CS)+CS*subQ[i-1];
          }
          
        }else{
          if(i==0){
            subQ[i]=initQ;
          }else{
            subQ[i]=subQ[i-L]*(1-CS)+CS*subQ[i-1];
          }
          
          
        }
        
        
      }
      
      
      
//      reachSub=1;                             //As a hour model ,the number of Sub-basin reach should be 1.
      
      
      
      for(i=1 ;i<=reachSub;i++){
        for(j=0;j<numT;j++){
          if(j==0){
            msjgQ[j]=C0*subQ[j]+C1*initQ+C2*initQ;
            
          }else{
            msjgQ[j]=C0*subQ[j]+C1*subQ[j-1]+C2*msjgQ[j-1];
            
          }
          
        }
        
        
        for(j=0;j<numT;j++)  subQ[j]=msjgQ[j];
        
      }
      
      for(i=0;i<numT;i++) {
        
        stationQcal[i]=stationQcal[i]+subQ[i];
        
      }
      
      
      
    }
    
    Rcpp::List resultData = Rcpp::List::create(
                                               Rcpp::Named("outE") = outE,
                                               Rcpp::Named("stationQcal") = stationQcal);
  return(resultData);
}

