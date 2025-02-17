##############################################

#        database collapse function          #

##############################################
#                                            #
# Need a function to reduce the dimensions   #
# of the dataset from a matrix (2D) to a     #
# vector (1D) for searching and updating     #
# in the user interface.                     #
##############################################

# 2D to 1D

dbcollapse = function(data){

  source("../Scripts/Database_Fix_Script.R")
  data = datafix(data)
  
  data_sortlist = c()
  for(i in 1:nrow(data)){

    data_sortlist = c(data_sortlist, paste(data[i,], collapse = "_|-")) # Need a complex divider that won't realistically be used in IDs

  }

  return = data_sortlist

}

# Vec to pos

vecposcall = function(vec, cal){
  
  vec = unlist(strsplit(gsub(" ", "", vec), ","))
  
  retnum = c()
  
  for(seaotter in 1:length(vec)){
    
    if(vec[seaotter] %in% cal == TRUE){
      
      retnum = c(retnum, which(grepl(vec[seaotter], cal)))
      
    }
    
  }
  
  return(retnum)
  
}