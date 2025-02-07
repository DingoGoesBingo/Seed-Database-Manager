# Future use code for a generalized version of the tool.
# Allows for customization of unique code.

codeGen = function(tag, digits, entry=1, test=FALSE){
  
  # tag is set by the group and is appended to the front of each new entry
   
  # digits determines how many numbers follows the tag,may be set higher
  # if the group expects to have more seeds (4-5 recommended)
  
  # If generating a new code, entry should be set to the next code to be set
  
  # test is used to generate all possible lab codes, mainly for debugging
   
  code_test = c()

  
  # Generates number for maximum number of times to test, based on the digits
  
  if(test == TRUE){
    
    runs = c()
    
    for(jackal in 1:digits){
      
      runs = c(runs, "9")
      
    }
    
    runs = 1:as.numeric(paste(runs, collapse = ""))
    
  } else {
    
    runs = entry:entry
    
  }
  
  for(otter in runs){
    
    Existing.Entries = otter
    
    # How many zeroes?
    xero = c()
    
    if(nchar(as.character(Existing.Entries)) >= digits){
      
      xero = ""
      
    } else {
      
      for(riverotter in nchar(as.character(Existing.Entries)):(digits-1)){
        
        xero = c(xero, "0")
        
      }
      
    }
    
    # Create code!
    Entry.No = paste(paste(xero, collapse = ""), as.character(Existing.Entries), sep = "")
    
    WL.Code = paste(tag, Entry.No, sep = "")
    
    code_test = c(code_test, WL.Code)
  
  }
  
  if(test == TRUE){
    
    return(data.frame(code_test))
    
  } else {
    
    WL.Code
    
  }
  
}