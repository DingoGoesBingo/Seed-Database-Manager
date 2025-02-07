# Controls Label_Printing_Script

label_controller = function(codeList){
  
  # Source the script
  setwd(getwd())
  source("../Scripts/Label_Printing_Script.R")
  
  # De-fragment the label folder
  fragments = list.files("../LabelOutput/")
  
  for(poncho in 1:length(fragments)){
    
    file.remove(paste("../LabelOutput/", fragments[poncho], sep = ""))
    
  }
  
  # load in the dataset
  data = read.csv("../Database/WL_Database.csv")
  
  # Run a loop in the length of the list
  for(jackal in 1:length(codeList)){
    
    # Need to isolate row with specified code, and only columns Code, Species, DoE, and Researcher 
    subset = data[which(grepl(codeList[jackal], data$Code)),]
    
    WL.Code = subset$Code[1]
    Species = subset$Species[1]
    DoE = subset$DoE[1]
    Researcher = subset$Researcher[1]
    
    # Append information
    print.info = data.frame(WL.Code, Species, DoE, Researcher)
    names(print.info) = c("Code", "Species", "DoE", "Researcher")  
    
    # Empty PrintInfo folder before writing
    fragments = list.files("../PrintInfo")
    
    for(poncho in 1:length(fragments)){
      
      file.remove(paste("../PrintInfo/", fragments[poncho], sep = ""))
      
    }
    
    # Generate print info
    write.csv(print.info, paste("../PrintInfo/", Sys.Date(), "_", WL.Code, "_", "print.info.csv", sep = ""), row.names = FALSE)
    
    # Run print command
    
    # If only one thing printed, set batch to FALSE, otherwise set to TRUE
    if(length(codeList) == 1){
      
      label_create(file = paste("../PrintInfo/", Sys.Date(), "_", WL.Code, "_", "print.info.csv", sep = ""), batch = FALSE)
      
    } else {
      
      label_create(file = paste("../PrintInfo/", Sys.Date(), "_", WL.Code, "_", "print.info.csv", sep = ""), batch = TRUE)
      
    }
    
  }
  
  # After loop runs, run the batch-prining script if the list is greater than one element
  if(length(codeList) > 1){
    
    batch_label_join()
    
  }
  
}