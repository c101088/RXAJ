library(Rcpp)
setwd("E:/RXAJ/RXAJ/src")


test<-function(T){
  
  res<-.Call("test",T)
  return(res)
}

test(basinInfo)