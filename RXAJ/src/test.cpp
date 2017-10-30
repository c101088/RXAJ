#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
RcppExport SEXP test(SEXP T1) {
  Rcpp::DataFrame T(T1);
  Rcpp::NumericVector stationE(T[1]);
  double i;
  Rcpp::Function nrow("nrow");
  //NumericVector stationE=Rcpp::NumericVector::create(nrow(T));
  i=stationE[1];
  //i = Rcpp::as<double>(stationE[1]);
  return (Rcpp::wrap(i));
}

