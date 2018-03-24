#include <math.h>
#include <stdio.h>
#include <cmath>
#include <Rcpp.h>
using namespace Rcpp;




extern double KC,UM,LM,C,WM,B,IM,SM,EX,KG,KI,CI,CG,CS,L,KE,XE;  
extern double DM,WMM,MS;
extern double Wu,Wl,Wd,Eu,El,Ed;
extern double initQ,basinArea,RIM,RtoQ,Fr0,Qs,Qi,Qg,Qs0,Qi0,Qg0,S0;
void ER(double E,double P);

// [[Rcpp::export]]
RcppExport SEXP hXAJc(SEXP modelParameter1,SEXP basinInfo1,SEXP basinData1) {
  
  Rcpp::NumericVector modelParameter(modelParameter1);
  Rcpp::List basinInfo2(basinInfo1);
  Rcpp::List basinData(basinData1);
  
  Rcpp::DataFrame basinInfo(basinInfo2[0]);
  basinArea = Rcpp::as<double>(basinInfo2[1]);
  Rcpp::DataFrame dayE(basinData[2]);
  Rcpp::DataFrame dayP(basinData[3]);
  Rcpp::DataFrame dayQ(basinData[4]);
  Rcpp::DataFrame initialValue(basinData[5]);
  
  Rcpp::Function nrow("nrow");
  Rcpp::Function ncol("ncol");
  
  
  int dlt =1;                                   //The dlt of dayModel is setted to 24 hours.
  int iT,iSub,i,j;
  int numT,numSub,reachSub;
  double E,P,initialW=0,weightVal,C0,C1,C2;
  
  C0=(0.5*dlt-KE*XE)/(0.5*dlt+KE-KE*XE);
  C1=(0.5*dlt+KE*XE)/(0.5*dlt+KE-KE*XE);
  C2=(-0.5*dlt+KE-KE*XE)/(0.5*dlt+KE-KE*XE);
  numT=Rcpp::as<int>(nrow(dayE));
  numSub=Rcpp::as<int>(ncol(dayP))-1;
  
  KC=modelParameter[0];UM=modelParameter[1];LM=modelParameter[2];C=modelParameter[3];WM=modelParameter[4];
  B=modelParameter[5];IM=modelParameter[6];SM=modelParameter[7];EX=modelParameter[8];KG=modelParameter[9];
  KI=modelParameter[10];CI=modelParameter[11];CG=modelParameter[12];CS=modelParameter[13];L=modelParameter[14];
  KE=modelParameter[15];XE=modelParameter[16];
  
  
  Rcpp::NumericVector stationE(dayE[1]);
  Rcpp::NumericVector stationQmea(dayQ[1]);
  Rcpp::NumericVector stationQcal(dayQ[2]);
  

  Rcpp::NumericVector outP(numT);
  Rcpp::NumericVector tempSubQ(numT);
  Rcpp::NumericVector subQ(numT);
  Rcpp::NumericVector msjgQ(numT);
  
  for(i = 0 ;i<numT;i++){

    outP[i]=0;
    subQ[i]=0;
    tempSubQ[i]=0;
    msjgQ[i]=0;
    stationQcal[i]=0;
  }
  
  DM=WM-UM-LM;
  WMM=(1+B)*WM/(1-IM);
  MS=(1+EX)*SM;  
  Rcpp::Function browser("browser");
  //  browser();
  
  for(iSub=0 ;iSub<numSub;iSub++){
    //   printf("*************iSub = %d*******\n",iSub);
    Rcpp::NumericVector stationP(dayP[iSub+1]);  
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
    initQ=Qs0+Qi0+Qg0; 
    RtoQ=weightVal*basinArea/3.6/dlt;
    //    printf("****%f %f %f *******\n",Wu,S0,Fr0);
    initialW= initialW+(Wu+Wl+Wd)*weightVal;    //initialW is used for calculate  the water balance
    for(iT=0;iT<numT;iT++){
      P=(stationP[iT]);
      E=(stationE[iT]);
      ER(E,P);
      
    
      outP[iT]=outP[iT]+stationP[iT]*weightVal;
      tempSubQ[iT]=Qs+Qi+Qg;

   //   fprintf(fp,"%f \n",subQ[iT]);
      //      fprintf(fp,"%f %f %f %f\n",E,P,Wu,subQ[iT]);
    }
    
    // for (i =0 ;i<numT;i++){
    //   if(csFlag ==0){
    //     if(initQ > tempSubQ[i-1]) {
    //       tempSubQ[i-1]= initQ;
    //     }else{
    //       csFlag =1;
    //     } 
    //   }
    //   
    //   fprintf(fp,"%d , %f \n",csFlag,tempSubQ[i]);
    // }
    
    for(i=0;i<numT;i++){          //as a DayModel ,L should be 0.

      if((i-L)<0){
        if(i==0) {
          subQ[i]=initQ;
        }else{
          subQ[i]=initQ*(1-CS)+CS*tempSubQ[i-1];
        }
        
      }else{
        if(i==0){
          subQ[i]=initQ;
        }else{
          subQ[i]=tempSubQ[i-L]*(1-CS)+CS*tempSubQ[i-1];
        }
        

      }

    }

    
    for(i=1 ;i<=reachSub;i++){
      for(j=0;j<numT;j++){
        if(abs(j)<0.001){
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
  
  
  Rcpp::List resultData = Rcpp::List::create(Rcpp::Named("outP") = outP,
                                             Rcpp::Named("stationQcal") = stationQcal);

  return(resultData);
}

