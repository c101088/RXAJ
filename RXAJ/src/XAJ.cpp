#include <Rcpp.h>
#include <math.h>
using namespace Rcpp;

// [[Rcpp::export]]
RcppExport SEXP XAJ(SEXP dlt1,SEXP modelParameter1,SEXP basinInfo1,SEXP basinData1) {
  
  Rcpp::NumericVector modelParameter(modelParameter1);
  Rcpp::List basinInfo2(basinInfo1);
  Rcpp::List basinData(basinData1);
  double dlt =Rcpp::as<double>(dlt1);
  
  Rcpp::DataFrame basinInfo(basinInfo2[0]);
  double basinArea = Rcpp::as<double>(basinInfo2[1]);
  Rcpp::DataFrame dayE(basinData[2]);
  Rcpp::DataFrame dayP(basinData[3]);
  Rcpp::DataFrame dayQ(basinData[4]);
  Rcpp::DataFrame initSoilWater(basinData[5]);
  Rcpp::function nrow("nrow");
  Rcpp::function ncol("ncol");
  
  
  int iT,iSub,i ,j,k;
  int numT,numSub,reachSub;
  double KC,UM,LM,C,WM,B,IM,SM,EX,KG,KI,CI,CG,CS,L,KE,XE;
  double DM,WMM,MS;
  double Wu,Wl,Wd,Eu,El,Ed,E,P,W,Ep,Pe,A,R;
  double weightVal,initQ,basinArea,RtoQ,Fr0,Fr,Qs,Qi,Qg,Qs0,Qi0,Qg0,S0,S,Au;
  int numIntoS;
  double KIdt,KGdt,CIdt,CGdt,Pedt,Smmf,Smf,Rs,Ri,Rg,Rsd,Rid,Rgd;
  
  
  numT=nrow(dayE);
  numSub=ncol(dayP)-1;
  
  KC=modelParameter[0];UM=modelParameter[1];LM=modelParameter[2];C=modelParameter[3];WM=modelParameter[4];
  B=modelParameter[5];IM=modelParameter[6];SM=modelParameter[7];EX=modelParameter[8];KG=modelParameter[9];
  KI=modelParameter[10];CI=modelParameter[11];CG=modelParameter[12];CS=modelParameter[13];L=modelParameter[14];
  KE=modelParameter[15];XE=modelParameter[16];

  DM=WM-UM-LM;
  WMM=(1+B)*WM;
  MS=(1+EX)*SM  
  
  Rcpp::NumericVector stationE(dayE[1]);
  Rcpp::NumericVector stationQmea(dayQ[1]);
  Rcpp::NumericVector stationQcal(dayQ[2]);
  
  
  Rcpp::NumericMatrix outWu= Rcpp::NumericMatrix::create(numT,numSub);
  Rcpp::NumericMatrix outWl= Rcpp::NumericMatrix::create(numT,numSub);
  Rcpp::NumericMatrix outWd= Rcpp::NumericMatrix::create(numT,numSub);
  Rcpp::NumericVector outE= Rcpp::NumericVector::create(numT);
  Rcpp::NumericVector subQ=Rcpp::NumericVector::create(numT);
  Rcpp::NumericVector msjgQ=Rcpp::NumericVector::create(numT);
  
  for(iSub=0 ;iSub<numSub;iSub++){
    Rcpp::NumericVector stationP(dayP[iSub+1]);  
    Rcpp::NumericVector stationW(initSoilWater[iSub]);
    Rcpp::NumericVector stationInfo(basinInfo[iSub]);
    Wu=stationW[0];
    Wl=stationW[1];
    Wd=stationW[2];
    weightVal=stationInfo[0];
    reachSub=stationInfo[1];
    
    
    RtoQ<-weightVal*basinArea/3.6/dlt;
    
    for(iT=0;iT<numT;iT++){
      
      P=stationP[iT];
      E=stationE[iT];
      
      Ep=KC*E;
      
      if((Wu+P)>EP){
        Eu=Ep;
        El=0;
        Ed=0;
      }else{
        Eu=Wu+p;
        if(Wl >= C*LM){
          El=(Ep-Eu)*Wl/LM;
          Ed=0;
          
        }else if(Wl>=C*(Ep-Eu)){
          El=C*(Ep-Eu);
          Ed=0;
          
        }else{
          El=WL;
          Ed=C*(Ep-Eu)-El;
          
        }
      }
      
      
      Pe=P-Eu-El-Ed;
      W=Wu+Wl+Wd;
      
      A=WMM*(1-pow((1-W/WM),(1/(1+B))))
      
      if(P==0){
        R=0;
        Wu=Wu-Eu;
        Wl=Wl-El;
        Wd=Wd-Ed;
        
      }else if(Pe<=0){
        R=0;
        Wu=Wu+P-Eu;
        if(Wu>UM){
          Wl=Wl+Wu-UM-El;
          Wu=UM;
          if(Wl>LM){
            Wd=Wd+Wl-LM-Ed;
          }else{
            Wd=Wd-Ed;
          }
          
        }
        
        
      }else{
        
        if((Pe+A)<=WMM){
          
          R = Pe+W-WM+WM*pow((1-(Pe+A)/WMM),B+1);
          
        }else{
          R=Pe-(Wm-W);
          
        }
        
        Wu=Wu+P-Eu;
        if(Wu>UM){
          Wl=Wl+Wu-UM-El;
          Wu=UM;
          if(Wl>LM){
            Wd=Wd+Wl-LM-Ed;
          }else{
            Wd=Wd-Ed;
          }
          
        }
        
      }
      
      outWu[iT,iSub]=Wu;
      outWl[iT,iSub]=Wl;
      outWd[iT,iSub]=Wd;
      outE[iT]=outE[iT]+(El+Eu+Ed)*weightVal;
      //The following code will solve the divide water source problem
      
      if(Pe>0){
        Fr=R/Pe;
        S=S0*Fr0/Fr;
        numIntoS=(int)(Pe/5+1);
        Pedt=Pe/numIntoS;
        
        KIdt=(1-pow((1-(KI+KG)),1/numIntoS))/(1+KG/KI);
        KGdt=KIdt*KG/KI;
        
        Rs=0;
        Ri=0;
        Rg=0;
        
        if(EX==0){
          SMMF=MS;
        }else{
          
          SMMF=MS*(1-pow((1-Fr),1/EX));
        }
        
        SMF=SMMF/(1+EX);
        
        for(i=1;i<=numIntoS;i++){
          
          Au=SMMF*(1-pow((1-S/SMF),1/(1+EX)));
          
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
        
      
        Qs=Rs*RtoQ;  //*********remember to define********//
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
      
      
      subQ[iT]=Qs+Qi+Qg;
      
      
      
      
      
    }
    
    
    initQ=weightVal*stationQmea[0];
    
    for(i=1 ;i<=reachSub;i++){
      for(j=0;j<numT;j++){
        if(j==0){
          
          
        }else{
          
          
        }
        
      }
      
      
    }
    
    
  }
  
  
  
}

