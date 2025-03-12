# Template police will find out if things are entered wrong, and prompt the user to fix them in the app.
# The app returns TRUE if it passes all the tests, FALSE if it fails even one of them

templatePolice = function(template, rList, sList){
  
  rList = rList[which(rList != "")]
  sList = sList[which(sList != "")]
  
  # Check to make sure ID entries aren't missing
  if("" %in% template$ID == TRUE){
    
    return("T")
    
  }
  
  # Check to make sure Purdue IDs are present in the database
  for(seaotter in 1:length(unique(template$Researcher))){
    
    if(!unique(template$Researcher)[seaotter] %in% rList){
      
      return("R")
      
    }
    
  }
  
  # Check to make sure species is present in the database
  for(seaotter in 1:length(unique(template$Species))){
    
    if(!unique(template$Species)[seaotter] %in% sList){
      
      return("S")
      
    }
    
  }
  
  # Check to make sure external or internal are used
  for(seaotter in 1:length(unique(template$Source..Internal.or.External.))){
    
    if(!unique(template$Source..Internal.or.External)[seaotter] %in% c("External", "Internal")){
      
      return("E")
      
    }
    
  }
  
  # Check to make sure proximal source is at least entered
  if("" %in% template$Proximal.Source == TRUE){
    
    return("I")
    
  }
  
  # If it has gotten this far...
  
  return("G")
  
}