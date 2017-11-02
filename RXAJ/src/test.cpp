#include <Rcpp.h>
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
  //double i;
  //Rcpp::Function nrow("nrow");
  //NumericVector stationE=Rcpp::NumericVector::create(nrow(T));
  //i=*T[1][1];
  //i = Rcpp::as<double>(stationE[1]);
  Rcpp::NumericMatrix df(T1);
  fun1(df);
  //double i = Rcpp::as<double>(df[1]);
  
  return (Rcpp::wrap(0));
}


