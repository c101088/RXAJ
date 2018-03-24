#include <math.h>
#include <stdio.h>
#include <Rcpp.h>
#include <cmath>
using namespace Rcpp;


double KC,UM,LM,C,WM,B,IM,SM,EX,KG,KI,CI,CG,CS,L,KE,XE;  
double DM,WMM,MS;
double Wu,Wl,Wd,Eu,El,Ed;
double initQ,basinArea,RIM,RtoQ,Fr0,Qs,Qi,Qg,Qs0,Qi0,Qg0,S0;


extern void ER(double E,double P){
  double Ep,Pe,R,A,W;
  int numIntoS=0,i;
  double Fr=0,S=0,Au=0;
  double KIdt=0,KGdt=0,Pedt,SMMF,SMF,Rs,Ri,Rg,Rsd,Rid,Rgd;
  
  Ep=KC*E;
  if((Wu+P)>Ep){
    Eu=Ep;
    El=0;
    Ed=0;
  }else{
    Eu=Wu+P;
    if(Wl >= C*LM){
      El=(Ep-Eu)*Wl/LM;
      Ed=0;
      
    }else if(Wl>=C*(Ep-Eu)){
      El=C*(Ep-Eu);
      Ed=0;
      
    }else{
      El=Wl;
      Ed=C*(Ep-Eu)-El;
      
    }
  }
  
  
  Pe=P-Eu-El-Ed;
  W=Wu+Wl+Wd;
//  if(stepCon == 262) browser();
 // if(stepCon == 262) printf("A WM**%f %f %f %f %f***\n",A,WMM,W,WM,B);
  A=(double)WMM*(1-pow((1-W/(WM+0.001)),(1/(1+B))));
 // if(1/(1+B)<0) printf("###in %d the 1/(1+B) <0",stepCon);
//if(stepCon == 262) printf("A WM**%f %f %f %f %f***\n",A,WMM,W,WM,B);
   if(Pe<=0.001){
      R=0;
      Wu=Wu+P-Eu;
      if(Wu>UM){
        Wl=Wl+Wu-UM-El;
        Wu=UM;
        if(Wl>LM){
          Wd=Wd+Wl-LM-Ed;
          Wl=LM;
        }else{
          Wd=Wd-Ed;
        }
        
      }else{
        Wl=Wl-El;
        Wd=Wd-Ed;
      }
      
      
    }else{
      RIM = Pe*IM;
      if((Pe+A)<=WMM){
        
        R = Pe+W-WM+WM*pow((1-(Pe+A)/WMM),B+1);
        
      }else{
        R=Pe-(WM-W);
        
      }
      
      Wu=Wu+P-R-Eu;
      if(Wu>UM){
        Wl=Wl+Wu-UM-El;
        Wu=UM;
        if(Wl>LM){
          Wd=Wd+Wl-LM-Ed;
          Wl=LM;
        }else{
          Wd=Wd-Ed;
        }
        
      }else{
        Wl=Wl-El;
        Wd=Wd-Ed;
      }
      
    }
    

    //The following code will solve the divide water source problem
    
    if(Pe>0.001){
      Fr=R/Pe;

      numIntoS=(int)(Pe/5+1);
      Pedt=Pe/numIntoS;
      
      KIdt=(1-pow((1-(KI+KG)),1/numIntoS))/(1+KG/KI);
      KGdt=KIdt*KG/KI;
      
      Rs=0;
      Ri=0;
      Rg=0;
      
      if(fabs(EX-0)<=0.0001){
        SMMF=MS;
      }else{
        
        SMMF=MS*(1-pow((1-Fr)+0.001,1/EX));
      }
      
      SMF=SMMF/(1+EX);
      
      for(i=1;i<=numIntoS;i++){
        S=S0*Fr0/Fr;      //the initial value of S0 and Fro is worth taking care of 
        if(S>SMF) S=SMF;
        Au=SMMF*(1-pow((1-S/(SMF+0.001)),1/(1+EX)));
        
        if(Pedt +Au <=0){
          Rsd=0;
          Rid=0;
          Rgd=0;
          S0=0;
          
        }else{
          if(Pedt +Au>=SMMF){
            Rsd = (Pedt +S-SMF)*Fr;
            Rid = SMF*KIdt*Fr;
            Rgd=SMF*Fr*KGdt;
            S0=SMF-(Rid+Rgd)/Fr;
          }else{
            Rsd=Fr*(Pedt-SMF+S+SMF*pow((1-(Pedt+Au)/SMMF),(1+EX)));
            Rid = Fr*KIdt*(S+Pedt-Rsd/Fr);
            Rgd=KGdt*Fr*(S+Pedt-Rsd/Fr);
            S0=S+Pedt-(Rsd+Rid+Rgd)/Fr;
          }
          
          
        }
        
        Rs=Rs+Rsd;
        Ri=Ri+Rid;
        Rg=Rg+Rgd;
        
        
      }
      Rs=Rs*(1-IM);
      Ri=Ri*(1-IM);
      Rg=Rg*(1-IM);
      
      Qs=(Rs+RIM)*RtoQ;  //*********remember to define********//
      Qi=CI*Qi0+(1-CI)*Ri*RtoQ;
      Qg=CG*Qg0+(1-CG)*Rg*RtoQ;
      
      Qs0=Qs;
      Qi0=Qi;
      Qg0=Qg;
      
      Fr0=Fr;
      
    }else{
      Rs=0;
      Ri=S0*Fr0*KI;
      Rg=S0*Fr0*KG;
      
      Qs=Rs*RtoQ;
      Qi=CI*Qi0+(1-CI)*Ri*RtoQ;
      Qg=CG*Qg0+(1-CG)*Rg*RtoQ;
      
      S0=S0-(Ri+Rg)/Fr0;      //remember the initial value of Fr0//
      Qs0=Qs;
      Qi0=Qi;
      Qg0=Qg;
      
    }
}







// [[Rcpp::export]]
RcppExport SEXP dXAJc(SEXP modelParameter1,SEXP basinInfo1,SEXP basinData1) {
  
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
    initQ=Qs0+Qi0+Qg0;
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

    }
    
    for(i=0;i<numT;i++){          //as a DayModel ,L should be 0.
      if((i-L)<0){
        if(abs(i)<0.001) {
          subQ[i]=initQ;
        }else{
          subQ[i]=initQ*(1-CS)+CS*tempSubQ[i-1];
        }
        
      }else{
        if(abs(i)<0.001){
          subQ[i]=initQ;
        }else{

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
      
     
    }
    if(iSub==(numSub-1)){
      for(i=numT-1;i>=1;i--){
        outW[i] = outW[i]-outW[i-1];
        
      }  
      outW[0]=outW[0]-initialW;
      
    }    
    
    
    
  }

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

