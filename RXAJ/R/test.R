library(Rcpp)
setwd("E:/RXAJ/RXAJ/src")

sourceCpp("test.cpp")
test<-function(T){
  
  res<-.Call("test",T)
  return(res)
}

someMatrix=matrix(nrow = 2,ncol = 2)

test(someMatrix)


numV<-c(1,2,3,4,4,8,5,5,5)