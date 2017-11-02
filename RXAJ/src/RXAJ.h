#include <Rcpp.h>
#include <math.h>
using namespace Rcpp;

double KC,UM,LM,C,WM,B,IM,SM,EX,KG,KI,CI,CG,CS,L,KE,XE;  double DM,WMM,MS;
double Wu,Wl,Wd,Eu,El,Ed;
double weightVal,initQ,basinArea,RtoQ,Fr0,Qs,Qi,Qg,Qs0,Qi0,Qg0,S0;



Rcpp::List ER(SEXP E1,SEXP P1){
  double E,P,Ep,Pe,R,A,W;
  int numIntoS;
  double Fr,S,Au;
  double KIdt,KGdt,CIdt,CGdt,Pedt,Smmf,Smf,Rs,Ri,Rg,Rsd,Rid,Rgd,C0,C1,C2;
  
  E=Rcpp::as<double>(E1);
  P=Rcpp::as<double>(P1);
  
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
    

    //The following code will solve the divide water source problem
    
    if(Pe>0){
      Fr=R/Pe;
      S=S0*Fr0/Fr;      //the initial value of S0 and Fro is worth taking care of 
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