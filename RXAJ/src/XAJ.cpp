#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
RcppExport SEXP XAJ(SEXP modelParameter,SEXP basinInfo,SEXP basinData) {
  
  Rcpp::DataFrame modelParameter(modelParameter);
  Rcpp::DataFrame basinInfo(basinInfo);
  Rcpp::List basinData(basinData);
  Rcpp::DataFrame dayE = basinData(2);
  Rcpp::DataFrame dayP = basinData(3);
  Rcpp::DataFrame dayQ = basinData(4);
  Rcpp::DataFrame initSoilWater = basinData(5);
  
  int i ,j,k;
  int numT,numSub;
  float KC,UM,LM,C,B,IM,SM,EX,KG,KI,CI,CG,CS,L,KE,XE;
  
  
}

