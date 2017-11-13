#include <math.h>
#include <RXAJ.h>
#include <stdio.h>
using namespace Rcpp;

// [[Rcpp::export]]
RcppExport SEXP dXAJ(SEXP modelParameter1,SEXP basinInfo1,SEXP basinData1) {
  fp= fopen("123.txt","w");
  
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
  
  int dlt =24;                                   //The dlt of dayModel is setted to 24 hours.
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
  
  
  Rcpp::NumericMatrix outWu(numT,numSub);
  Rcpp::NumericMatrix outWl(numT,numSub);
  Rcpp::NumericMatrix outWd(numT,numSub);
  Rcpp::NumericMatrix outQs0(numT,numSub);
  Rcpp::NumericMatrix outQi0(numT,numSub);
  Rcpp::NumericMatrix outQg0(numT,numSub);
  Rcpp::NumericMatrix outFr0(numT,numSub);
  Rcpp::NumericMatrix outS0(numT,numSub);
  Rcpp::NumericVector outE(numT);
  Rcpp::NumericVector outP(numT);
  Rcpp::NumericVector outW(numT);
  Rcpp::NumericVector subQ(numT);
  Rcpp::NumericVector tempSubQ(numT);
  Rcpp::NumericVector msjgQ(numT);
  
  for(i = 0 ;i<numT;i++){
    for(j=0;j<numSub;j++){
      outWu(i,j)=0;outWl(i,j)=0;outWd(i,j)=0;
      outQs0(i,j)=0;outQi0(i,j)=0;outQg0(i,j)=0;
      outFr0(i,j)=0;outS0(i,j)=0;
    }
    outE[i]=0;
    outP[i]=0;
    outW[i]=0;
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
    initQ=weightVal*stationQmea[0];
    RtoQ=weightVal*basinArea/3.6/dlt;
//    printf("****%f %f %f *******\n",Wu,S0,Fr0);
    initialW= initialW+(Wu+Wl+Wd)*weightVal;    //initialW is used for calculate  the water balance
    for(iT=0;iT<numT;iT++){
      P=(stationP[iT]);
      E=(stationE[iT]);
      ER(E,P);
      
      outWu(iT,iSub)=Wu;
      outWl(iT,iSub)=Wl;
      outWd(iT,iSub)=Wd;
      outQs0(iT,iSub)=Qs0;
      outQi0(iT,iSub)=Qi0;
      outQg0(iT,iSub)=Qg0;
      outS0(iT,iSub)=S0;
      outFr0(iT,iSub)=Fr0;
      outE[iT]=outE[iT]+(El+Eu+Ed)*weightVal;
      outP[iT]=outP[iT]+stationP[iT]*weightVal;
      outW[iT]=outW[iT]+(Wu+Wl+Wd)*weightVal;
      tempSubQ[iT]=Qs+Qi+Qg;
    
//      fprintf(fp,"%f %f %f %f\n",E,P,Wu,subQ[iT]);
    }
    
    for(i=0;i<numT;i++){          //as a DayModel ,L should be 0.
      if((i-L)<0){
        if(abs(i)<0.001) {
          subQ[i]=initQ;
        }else{
          if(csFlag ==0){
            if(initQ> tempSubQ[i-1]) {
              tempSubQ[i-1]= initQ;
            }else{csFlag =1;} 
          }
          subQ[i]=initQ*(1-CS)+CS*tempSubQ[i-1];
        }
        
      }else{
        if(abs(i)<0.001){
          subQ[i]=initQ;
        }else{
          if(csFlag ==0){
            if(initQ> tempSubQ[i-1]) {
              tempSubQ[i-1]= initQ;
            }else{csFlag =1;} 
          }
          subQ[i]=tempSubQ[i-L]*(1-CS)+CS*tempSubQ[i-1];
        }
        
        
      }
      
      
    }
    
    
    reachSub=1;                             //As a day model ,the number of Sub-basin reach should be 1.

    
    
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
      
        fprintf(fp,"%f \n",stationQcal[i]);
     
    }
    if(iSub==(numSub-1)){
      for(i=numT-1;i>=1;i--){
        outW[i] = outW[i]-outW[i-1];
        
      }  
      outW[0]=outW[0]-initialW;
      
    }    
    
    
    
  }

  fclose(fp);
  printf("*****the loop is over!!*****\n");

  Rcpp::List resultData = Rcpp::List::create(Rcpp::Named("outWu") = outWu,
                                             Rcpp::Named("outWl") = outWl,
                                             Rcpp::Named("outWd") = outWd,
                                             Rcpp::Named("outW") = outW,
                                             Rcpp::Named("outQs0") = outQs0,
                                             Rcpp::Named("outQi0") = outQi0,
                                             Rcpp::Named("outQg0") = outQg0,
                                             Rcpp::Named("outS0") = outS0,
                                             Rcpp::Named("outFr0") = outFr0,
                                             Rcpp::Named("outE") = outE,
                                             Rcpp::Named("outP") = outP,
                                             Rcpp::Named("stationQcal") = stationQcal);

  return(resultData);
}

