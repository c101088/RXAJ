#include <Rcpp.h>
#include <math.h>
using namespace Rcpp;


void fun1(SEXP df1){
  int i,j;
  
  Rcpp::NumericMatrix df2(df1);

  for(i=0;i<2;i++){
    df2(i,0) = 1;
    
  }
  
 // return(df2);
  
}




// [[Rcpp::export]]
RcppExport SEXP test(SEXP T1) {
  //Rcpp::List T(T1);
 // Rcpp::NumericVector stationE(T(1,1));
  // //double i;
  // Rcpp::Function nrow("nrow");
  // int i = Rcpp::as<int>(nrow(T1));
  // Rcpp::Function browser("browser");
  // //browser();
  // printf("****hhhh***\n");
  //NumericVector stationE=Rcpp::NumericVector::create(nrow(T));
  //i=*T[1][1];
  //i = Rcpp::as<double>(stationE[1]);
  //Rcpp::NumericMatrix df(T1);
  //Rcpp::NumericMatrix ddf(2,2);
  //fun1(df);
  //double i = Rcpp::as<double>(df[1]);
  // double WMM = 241.237,W = 180.0,WM=180.0,B=0.3,A;
  // A=WMM*(1-pow((1-W/WM),(1/(1+B))));
  // printf("***%f\n",A);
  // Rcpp::NumericMatrix NM1 (2,2);
  // Rcpp::NumericMatrix NM2 (2,2);
  
  Rcpp::NumericVector NV1(15);
  for(int i =0;i<15;i++){
    NV1[i]=i;
 //   NV1[i]=NV1[i]*i;
    
    
  }
  
  // Rcpp::List ddf= Rcpp::List::create(Rcpp::Named("NM1") =NM1,
  //                                    Rcpp::Named("NM2")=NM2
  //                                   );
  return (NV1);
}


