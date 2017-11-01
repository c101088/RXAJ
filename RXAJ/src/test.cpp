#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
RcppExport SEXP test(SEXP T1) {
  //Rcpp::List T(T1);
 // Rcpp::NumericVector stationE(T(1,1));
  //double i;
  //Rcpp::Function nrow("nrow");
  //NumericVector stationE=Rcpp::NumericVector::create(nrow(T));
  //i=*T[1][1];
  //i = Rcpp::as<double>(stationE[1]);
  Rcpp::List df(T1);
  double i = Rcpp::as<double>(df[1]);
  
  return (Rcpp::wrap(i));
}

