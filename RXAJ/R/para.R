##This is a function ,used for the parameters input and pre_test.

check_basinData<-function(basinData){
  
  for(i in 3:length(basinData)){
    if((difftime(basinData[[i]][[1]],basinData[[3]][[1]],units="days")<0)|(difftime(basinData[[i]][[2]],basinData[[3]][[2]],units="days")>0) ){
      cat("The",i,"element of basinData is not included in the dayData period!\n")
    }
    
    if(i == 3){
      for(j in 3:5){
        if(nrow(basinData[[3]][[j]])!= (difftime(basinData[[3]][[2]],basinData[[3]][[1]],units = "days")+1)){
          cat("please check the Continuity of the [[3]][[j]] element of basinData"," j==",j,"\n")
        }
        if(j == 4){
          if(ncol(basinData[[2]])!= (ncol(basinData[[i]][[j]])-1)){
            cat("basinData error in sub-basin number!! please check [[i]][[j]] element of basinData","\n")
            cat("i == ",i,"  ","j == ",j,"\n")
          }
        }
        if(anyNA(basinData[[i]][[j]]) == TRUE){
          
          cat("please check the NA in [[i]][[j]] element of basinData"," i ==",i," j ==  ",j,"\n")
        }
      }
      
    }else{
      
      for(j in 3:5){
        if(nrow(basinData[[i]][[j]])!= (difftime(basinData[[i]][[2]],basinData[[i]][[1]],units = "hours")+1)){
          cat("please check the continuity in [[i]][[j]] element of basinData"," i ==",i,"j ==",j,"\n")
        }
        if(j==4){
          if(ncol(basinData[[2]])!= (ncol(basinData[[i]][[j]])-1)){
            cat("basinData error in sub-basin number!! please check [[i]][[j]] element of basinData","\n")
            cat("i == ",i,"  ","j == ",j,"\n")
          }
        }
        if(anyNA(basinData[[i]][[j]]) == TRUE){
          
          cat("please check the NA in [[i]][[j]] element of basinData"," i ==",i," j ==  ",j,"\n")
        }
         
      }
      
    }
    
    
  }
  
  
}

check_basinData(hhData)