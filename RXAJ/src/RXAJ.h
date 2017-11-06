#include <Rcpp.h>
#include <cmath>
using namespace Rcpp;

double KC,UM,LM,C,WM,B,IM,SM,EX,KG,KI,CI,CG,CS,L,KE,XE;  
double DM,WMM,MS;
double Wu,Wl,Wd,Eu,El,Ed;
double initQ,basinArea,RIM,RtoQ,Fr0,Qs,Qi,Qg,Qs0,Qi0,Qg0,S0;
int stepCon=0;
FILE *fp;
//Rcpp::Function browser("browser");


void ER(double E,double P){
  double Ep,Pe,R,A,W;
  int numIntoS=0,i;
  double Fr=0,S=0,Au=0;
  double KIdt=0,KGdt=0,Pedt,SMMF,SMF,Rs,Ri,Rg,Rsd,Rid,Rgd;
  
  stepCon++;
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
        
//        fprintf(fp,"**%f %f %f %f %f %f %f %f %f \n",S0,S,SMF,SMMF,Pedt,Au,Rsd,Rid,Rgd);
        
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
  // fprintf(fp,"%f %f %f %f %f %f \n",WMM,W,WM,B,EX,MS);
  // fprintf(fp,"%f %f ",R,Pe);
  // fprintf(fp,"%f %f %f %f %f %d %f %f \n",E,P,A,Fr0,Fr,numIntoS,KIdt,KGdt);
  // 
  
//  fprintf(fp,"%f %f %f %f %f %f %f %f %f \n",Wu,Wl,Wd,Eu,El,Ed,Rs,Ri,Rg);
 //fprintf(fp,"%f %f %f %f %f %f %f %f %f \n",Wu,Wl,Wd,Eu,El,Ed,Qs,Qi,Qg);
}