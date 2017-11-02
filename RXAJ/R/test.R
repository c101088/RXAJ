library(Rcpp)
setwd("E:/RXAJ/RXAJ/src")


test<-function(T){
  
  res<-.Call("test",T)
  return(res)
}

someMatrix=matrix(nrow = 2,ncol = 2)

test(someMatrix)