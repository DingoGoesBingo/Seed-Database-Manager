# This script fixes any issues with the database display on the app

datafix = function(data){
  
  # Fix the issue with duplication of the accession name column
  
  if("accession_name" %in% tolower(names(data)) && ncol(data) > 11){
    
    for(jackal in 1:nrow(data)){
      
      if(is.na(data[jackal,2]) == TRUE || data[jackal,2] == "" || data[jackal,2] == "NA"){
        
        data[jackal,2] = data[jackal,which(tolower(names(data)) == "accession_name")]
        
      }
      
    }
    
    data = data[,-which(tolower(names(data)) == "accession_name")]
    
  }
  
  # Fix the issue of rows appearing out-of-order when a note is added
  
  data$tmpcol = as.numeric(sub("WL", "", data$Code)) # need a temporary column
  
  data = data[order(data$tmpcol),] #order numerically
  
  data = data[,-ncol(data)]# Remove column
  
  # Overwrites existing CSV file
  
  write.csv(data, "../Database/WL_Database.csv", row.names = FALSE)
  
  # Always returns the fixed dataset, even if nothing was changed.
  
  return(data)
  
}