#####################################################
### SDM Label Printing Script                     ###
### Ver. 1.0 Script                               ###
#####################################################
### Authors: Sam Schafer                          ###
#####################################################

# ------------------------------------------------- #

#####################################################
#################### Description #############-#[]#X#
#####################################################
# An addition to the SDM suite of tools that allows #
# easy label generation to be used for newly        #
# registered seed packets.                          #
#                                                   #
# While the rest of the main SDM functions have     #
# no package dependencies, this one requires the    #
# use of a word document-editing package known as   #
# officer. The package will be automatically        #
# installed upon running the application, if it     #
# isn't already installed.                          #
#####################################################

label_create = function(file, batch){
  
  # Step 0.)      Load required package
  
  if(!require(officer)){install.packages("officer")}
  library(officer)
  
  # Step 1.)      Load in the print information
  
  setwd(getwd())
  print(getwd())
  
  print.info = read.csv(file)
  
  # Step 2.)      Load in the template doc
  
  label_template = read_docx("../Template/Blank_Label_Template.docx")
  temp_summ = docx_summary(label_template)
  
  # This list will be used to coordinate sticker placement on the document
  chronological_list = temp_summ$text[c(1:9,21:29,41:49)]
  
  # Step 3.)      Check the position in the label template (from previous command)
  
  # A text file should be saved in the /LabelRem folder that contains the last used
  # position on the label sheet.
  
  labPos = read.table("../Temporary/LabelRem/pos.txt")[1,1]
  
  # If this is a batch run, save this position and use it as the starting point
  # in the cleanup.
  
  if(batch == TRUE && file.exists("../Temporary/LabelRem/batch_pos.txt") == FALSE){
    
    write.table(labPos, "../Temporary/LabelRem/batch_pos.txt", row.names = FALSE, col.names = FALSE)
    
  }
  
  # Step 4.)      Write print info to label document
  
  labelSheet = cursor_reach(label_template, labPos)
  
  # Overwrite correct sticker label
  
  labelSheet = body_replace_all_text(label_template,
                                     old_value = labPos,
                                     new_value = paste(print.info$Code[1], print.info$Species[1], print.info$DoE[1], print.info$Researcher[1], sep = ", "),
                                     only_at_cursor = FALSE)

  # Remove any other label besides the sticker
  
  for(r in 1:length(chronological_list)){
    
    labelSheet = body_replace_all_text(label_template, 
                                       old_value = chronological_list[r], 
                                       new_value = "", 
                                       only_at_cursor = FALSE)
    
  }
  
  # Step 5.)      Update the position file
  
  for(j in 1:length(chronological_list)){
    
    if(labPos == chronological_list[j]){
      
      if(j == 27){
        
        write.table(chronological_list[1], "../Temporary/LabelRem/pos.txt", row.names = FALSE, col.names = FALSE)
        
      } else {
        
        write.table(chronological_list[j+1], "../Temporary/LabelRem/pos.txt", row.names = FALSE, col.names = FALSE)
        
      }
      
    }
    
  }
  
  # Step 6.)      Save as a new document
  if(batch == FALSE){
    
    # Testing railway volume
    print(labelSheet, target = paste("../LabelOutput/", Sys.Date(), "_", print.info$Code[1], "_Label_Sheet", ".docx", sep = "")) # /LabelOutput/
    
  } else {
    
    if(dir.exists("../Temporary/RegPrintInfo") == FALSE){
      
      dir.create("../Temporary/RegPrintInfo")
      
    }
    
    print(labelSheet, target = paste("../Temporary/RegPrintInfo/", print.info$Code[1], "_TempLabel", ".docx", sep = ""))
    
  }
  
}

batch_label_join = function(){
  
  # Step 1.)      Load the required package
  
  if(!require(officer)){install.packages("officer")}
  library(officer)
  
  setwd(getwd())
  
  # Step 2.)      Load the template and associated files
  
  label_template = read_docx("../Template/Blank_Label_Template.docx")
  temp_summ = docx_summary(label_template)
  
  # This list will be used to coordinate sticker placement on the document
  chronological_list = temp_summ$text[c(1:9,21:29,41:49)]
  
  # Step 3.)      Iterate through temporary label files and append to new sheets
  
  fragments = list.files("../Temporary/RegPrintInfo")
  
  labPos = read.table("../Temporary/LabelRem/batch_pos.txt")[1,1]
  
  # Remove the batch pos file
  file.remove("../Temporary/LabelRem/batch_pos.txt")
  
  # pos = 1 # Label sheet position
  pos = as.numeric(which(chronological_list == labPos))
  sheet = 1 # Current sheet number
  
  assign(paste("Label_Sheet_", sheet, sep = ""),
         read_docx("../Template/Blank_Label_Template.docx"))
  
  # print(paste("Label_Sheet_", sheet, sep = ""))
  
  for(i in 1:length(fragments)){
    
    # Create a new sheet when position rolls over
    if(pos %% 28 == 0){
      
      # print("CYCLE")
      
      pos = 1
      sheet = sheet + 1
      
      assign(paste("Label_Sheet_", sheet, sep = ""),
             read_docx("../Template/Blank_Label_Template.docx")) # Create new sheet
      
      # print(paste("Label_Sheet_", sheet, sep = ""))
      
    }
    
    # Pull the temp label from the temp folder
    currFile = read_docx(paste("../Temporary/RegPrintInfo/", fragments[i], sep = ""))
    currFile_summ = docx_summary(currFile)
    
    # Extract information we want
    currFile_summ = currFile_summ[which(is.na(currFile_summ$text) == FALSE),]
    currFile_summ = currFile_summ[which(currFile_summ$text != ""),]
    
    # Paste information to new document
    
    assign(paste("Label_Sheet_", sheet, sep = ""),
           body_replace_all_text(
             get(paste("Label_Sheet_", sheet, sep = "")),
             old_value = chronological_list[pos],
             new_value = currFile_summ$text[1],
             only_at_cursor = FALSE
           )
           
    )
    
    # print(pos)
   
    pos = pos + 1
     
    if(i == length(fragments)){
      
      write.table(chronological_list[pos], "../Temporary/LabelRem/pos.txt", row.names = FALSE, col.names = FALSE)
      
    }
    
  }
  
  
  # Step 4.)      Clean up sheets and print

  # Conditional and sheet counter
  sheetExist = TRUE
  shnum = 1

  # Runs so long as all sheets are checked
  while(sheetExist == TRUE){

    sheetExist = exists(paste("Label_Sheet_", shnum, sep = ""))

    # Do nothing if the sheet doesn't exist
    if(sheetExist == TRUE){

      temp_summ = docx_summary(get(paste("Label_Sheet_", shnum, sep = "")))

      # Runs through each label in the sheet, erases placeholder text
      for(r in 1:length(chronological_list)){

        assign(paste("Label_Sheet_", shnum, sep = ""),
               body_replace_all_text(
                  get(paste("Label_Sheet_", shnum, sep = "")),
                  old_value = chronological_list[r],
                  new_value = "",
                  only_at_cursor = FALSE
              )

        )

      }

      # Write the sheet!
      print(get(paste("Label_Sheet_", shnum, sep = "")), target = paste("../LabelOutput/", Sys.Date(), "_Label_Sheet", "_", shnum, ".docx", sep = "")) # /LabelOutput


    }

    # Iterate the sheet count
    shnum = shnum + 1

  }
  
  # Step 5.)      Wipe the ./Temporary/RegPrintInfo folder 
  
  burners = list.files("../Temporary/RegPrintInfo")
  
  for(poncho in 1:length(burners)){
    
    file.remove(paste("../Temporary/RegPrintInfo/", burners[poncho], sep = ""))
    
  }
  
}