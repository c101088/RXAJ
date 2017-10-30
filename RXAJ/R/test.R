library(Rcpp)
setwd("E:/RXAJ/RXAJ/src")


test<-function(T1){
  
  res<-.Call("test",T1)
  return(res)
}

test(dayE)