#####################################################
### Wang Lab Seed Database Manager                ###
### Ver. 1.0 Script                               ###
#####################################################
### Authors: Sam Schafer                          ###
#####################################################

# ------------------------------------------------- #

#####################################################
#################### Description #############-#[]#X#
#####################################################
# This program is designed to revolutionize the way #
# we organize our genetic material in the lab.      #
# Using this tool, it will display all of our seed  #
# inventory in a neat fashion as to assist those    #
# wanting to find more information on genetic       #
# material.                                         #
#                                                   #
# Use the source() command to equip all these       #
# functions to your working environment, or use     #
# the ShinyR application located in the             #
# /Application folder.                              #
#####################################################

# ------------------------------------------------- #

#                Register Function                  #

# ------------------------------------------------- #
#####################################################
#################### Description #############-#[]#X#
#####################################################
# Use this function to register new seeds into the  #
# database. Requires you to know the plant          #
# accession name, species (scientific name), seed   #
# proximal source, original researcher who ordered  #
# /produced the seed or entered in the data, at     #
# least one additional ID (maximum 2 additional),   #
# and short escription of the seed entry.           #
#####################################################

Register = function(Accession = NA, Source = NA, Prox_Source = NA, Add_ID_1 = NA, Add_ID_2 = NA, Species=NA, Researcher=NA, Harvest=NA, Desc=NA, Batch=FALSE){
  
  # Step 1.)    Load in the database 
  setwd(getwd())
  
  source("../Scripts/Database_Fix_Script.R")
  source("../Scripts/SDM_Main_Script.R")
  
  con = concon() # Connects to the railway database
  dbGet(con)
  
  Database = datafix(as.data.frame(read.csv("../Database/WL_Database.csv")))
  
  # Step 2.)    Determine the number of entries that currently exist
  
  Existing.Entries = as.numeric(nrow(Database))
  
  # Step 3.)    Generate novel lab code for new entry (tag = "WL", max. digits = 4; WL####)
  source("../Scripts/Unique_Code_Generation.R")
  params = read.table("../Setup/UserSettings.txt", sep = "=")[6:7,1]
  
  WL.Code = codeGen(params[1], as.numeric(params[2]), Existing.Entries+1, FALSE)
  
  # Step 4.)    Enter the supplied information into a new row in the database
  
  Database[Existing.Entries+1, ] = c(rep(NA, ncol(Database)))
  
  Database$Code[(Existing.Entries+1)] = WL.Code # Novel code is always entered into DB
  
  Database$DoE[Existing.Entries+1] = as.character(Sys.Date()) # Date of entry extracted from system time
  
  
  if(exists("Accession") == TRUE){ # For each other variable, it is checked to see if they were entered.
    
    Database$Accession_Name[Existing.Entries+1] = Accession
    
  } 
  
  if(exists("Source") == TRUE){ # For each other variable, it is checked to see if they were entered.
    
    Database$Source[Existing.Entries+1] = Source
    
  } 
  
  if(exists("Prox_Source") == TRUE){ # For each other variable, it is checked to see if they were entered.
    
    Database$Prox_Source[Existing.Entries+1] = Prox_Source
    
  }
  
  if(exists("Add_ID_1") == TRUE){ # For each other variable, it is checked to see if they were entered.
    
    Database$Add_ID_1[Existing.Entries+1] = Add_ID_1
    
  } 
  
  if(exists("Add_ID_2") == TRUE){ # For each other variable, it is checked to see if they were entered.
    
    Database$Add_ID_2[Existing.Entries+1] = Add_ID_2
    
  } 
  
  if(exists("Species") == TRUE){ # For each other variable, it is checked to see if they were entered.
    
    Database$Species[Existing.Entries+1] = Species
    
  } 
  
  if(exists("Researcher") == TRUE){ # For each other variable, it is checked to see if they were entered.
    
    Database$Researcher[Existing.Entries+1] = Researcher
    
  } 
  
  if(exists("Harvest") == TRUE){ # For each other variable, it is checked to see if they were entered.
    
    Database$Harvest[Existing.Entries+1] = Harvest
    
  }
  
  if(exists("Desc") == TRUE){ # For each other variable, it is checked to see if they were entered.
    
    Database$Desc[Existing.Entries+1] = Desc
    
  } 
  
  # Step 5.)    Overwrite database as a CSV file
  
  write.csv(Database, "../Database/WL_Database.csv", row.names = FALSE)
  
  # Step 5.5.)  Pipe information to the dbRegister() function
  
  # source("RailwayScripts.R")
  
  con = concon() # Accesses the database from Railway's server
  
  dbRegister(con, WL.Code, Accession, Source, Prox_Source, Add_ID_1, Add_ID_2, Species, Researcher, Harvest, as.character(Sys.Date()), Desc)
  
  # Step 6.)    Print detailed report to the user / report code to the print function (All moved to a new function)
  
  # Create a mini dataset to export to the print function 
  # print.info = as.data.frame(matrix(nrow = 0, ncol = 4))
  
  # Append information
  # print.info = rbind(print.info, c(WL.Code, Species ,as.character(Sys.Date()), Researcher))
  # names(print.info) = c("Code", "Species", "DoE", "Researcher")
  
  # Empty PrintInfo folder before writing
  # fragments = list.files("../PrintInfo")
  # 
  # for(poncho in 1:length(fragments)){
  #   
  #   file.remove(paste("../PrintInfo/", fragments[poncho], sep = ""))
  #   
  # }
  
  # Save to the PrintInfo folder (which gets cleaned frequently) [for legacy label printing]
  # write.csv(print.info, paste("../PrintInfo/", Sys.Date(), "_", WL.Code, "_", "print.info.csv", sep = ""), row.names = FALSE)
  
  # Run label printing code (to be moved to it's own function soon)
  # label_create(file = paste("../PrintInfo/", Sys.Date(), "_", WL.Code, "_", "print.info.csv", sep = ""), batch = Batch)
  
  
  # print(paste("Entry", WL.Code, "registered successfully. Please see the entry below."))
  # print("----------------------------------------------------")
  # print("----------------------------------------------------")
  # print(Database[Existing.Entries+1,])
  # print("----------------------------------------------------")
  # print("----------------------------------------------------")
  
}



# ------------------------------------------------- #

#                  Lookup Function                  #

# ------------------------------------------------- #
#####################################################
#################### Description #############-#[]#X#
#####################################################
# Use this function to look up seeds with matching  #
# criteria for PI number, accession name, species,  #
# source, researcher, or date of entry.             #
#                                                   #
# query is used to specify what to look up.         #
#                                                   #
# savepoint is used to specify the directory where  #
# you wish to save the CSV file to.                 #
#####################################################

Lookup = function(query, savepoint = "../UserQuery"){
  
  # Initial Cleanup
  
  QueryCleanup()
  
  # Application Settings:
  
  if(savepoint == "" || savepoint == "../UserQuery"){
  
    savepoint = "../UserQuery"
  
  } else {
    
    savepoint = normalizePath(readClipboard(), winslash = "/")
    
  }
  
  # Step 1.)    Load and define required components
  
  # setwd("E:/R/Wang Lab/WLDB/Scripts")
  setwd(getwd())
  Database = as.data.frame(read.csv("../Database/WL_Database.csv"))
  
  return.table = as.data.frame(matrix(nrow = 0, ncol = 11))
  names(return.table) = names(Database)
  
  # Step 2.)    Analyze each row to match query
  
  hit = 0
  
  for(q in 1:as.numeric(nrow(Database))){
    
    for(p in 1:length(Database[q,])){
      
      if(grepl(tolower(query), tolower(Database[q,p])) == TRUE){
        
        # Step 3.)    Append each matched row to a return table
        hit = hit + 1
        
        return.table[hit,] = c(t(t(Database[q,])))
        
      }
      
    }
    
  }
  
  # Step 4.)    Print report back to the user and return results
  
  if(nrow(return.table) == 0){
    
    print(paste("Sorry, but your query for", query, "returned no results.", sep = " "))
    print("----------------------------------------------------")
    print("----------------------------------------------------")
    
  } else {
    
    # Write CSV file in current directory. File name generated from system date and time, user, and query
    setwd(savepoint)
    filename = paste(gsub(pattern = ":", replacement = "",x = gsub(pattern = " ", replacement = "-", x = as.character(Sys.time()))), "-", as.character(Sys.info()[7]), "-", query, ".csv", sep = "")
    write.csv(return.table, filename, row.names = FALSE)
    
    print(paste("Your query for", query, "returned", nrow(return.table), "results.", sep = " "))
    print(paste("Query results have been exported to", getwd(), sep = " "))
    print("----------------------------------------------------")
    print("----------------------------------------------------")
    
  }
  
}



# ------------------------------------------------- #

#              RegisterBatch Function               #

# ------------------------------------------------- #
#####################################################
#################### Description #############-#[]#X#
#####################################################
# An easier way to implement several entries        #
# without needing to write your own script.         #
# Requires that you fill out the template found in  #
# the /Template folder.                             #
#                                                   #
# Note: Description is left out of the template     #
# and is instead entered as a parameter in the      #
# function.                                         #
#####################################################

RegisterBatch = function(template, Desc){ 
    
  #Step 1.)     Load in current database and check correct template
  
  #setwd("E:/R/Wang Lab/WLDB/Scripts")
  setwd(getwd())
  Database = as.data.frame(read.csv("../Database/WL_Database.csv"))
  
  #Step 2.)     Append new description to each value in the template
  
  template$Desc = Desc
  
  #Step 3.)     Apply Register() to each row in the template
  
  for(g in 1:nrow(template)){
    
    datafix(as.data.frame(read.csv("../Database/WL_Database.csv")))
    
    # Looking for notes, if any
    if(template$Notes[g] != ""){
      
      # Add them to description field
      UpdatedDesc = paste(template$Notes[g], Desc, sep = "-")
      
    } else {
      
      # Just use description field
      UpdatedDesc = Desc
      
    }
    
    Register(Accession = template$Plant.Name[g], 
             Source = template$Source..Internal.or.External.[g], 
             Prox_Source = template$Proximal.Source[g],
             Add_ID_1 = template$ID[g],
             Add_ID_2 = template$Additional.ID[g],
             Species = template$Species[g],
             Researcher = template$Researcher[g],
             Harvest = template$Harvest[g],
             Desc = UpdatedDesc,
             Batch = TRUE)
    
  }
  
  # Step 4.)   Run batch label join to compile labels into one PDF (moved to own function)
  
  # batch_label_join()
  
}

# ------------------------------------------------- #

#                  AddNote Function                 #

# ------------------------------------------------- #
#####################################################
#################### Description #############-#[]#X#
#####################################################
# Updates description information, in the event     #
# that we need to append info to a previous entry.  #
# For example, if we find seed was mixed/           #
# contaminated, we would want to update the entry   #
# to make note of this.                             #
#                                                   #
# Simple provide the lab code and a note to be      #
# appended to the end of the previous desc          #
#                                                   #
# Additionally, a timestamp is generated to note    #
# when the entry is updated (Using * as border).   #
# Keeping this in mind, do not use * as a symbol   #
# in your note, as it will mess up the date-adding  #
# feature.                                          #
#####################################################

AddNote = function(Code, Note, User){
  
  # Step 1.)     Load in the database
  setwd(getwd())
  
  source("../Scripts/Database_Fix_Script.R")
  Database = datafix(as.data.frame(read.csv("../Database/WL_Database.csv")))
  
  # Step 2.)     Isolate row containing desired lab code
  
  # Tracker variable
  
  Row_Num = 0
  found = FALSE
  QueryRow = NA
  
  for(kangaroo in 1:nrow(Database)){
    
    if(tolower(Database[kangaroo,1]) == tolower(Code)){
      
      # The row of interest for note appending
      QueryRow = Database[kangaroo,]
      
      # So that we can remember where we found it in the Dataset
      Row_Num = kangaroo
      
      # found is used to break the loop, which isn't necessary, 
      # but useful if the dataset becomes large
      found = TRUE
      
    }
    
    if(found == TRUE){
      
      # Break the Cycle
      break()
      
    }
    
  }
  
  # Step 3.)     Remove previous update tag, if applicable
  
  QueryRow$Desc = unlist(strsplit(QueryRow$Desc, split = "\\*"))[[1]]
  
  # Step 4.)     Append the note to current desc
  
  QueryRow$Desc = paste(QueryRow$Desc, "-", Note, sep = " ")
  
  # Step 5.)     Generate a new update tag
  
  QueryRow$Desc = paste(QueryRow$Desc, "*", "Updated on", Sys.Date(), "by user", User, "*", sep = " ")
  
  # Step 5.5)    Pass updated description and code to dbAddNote()
  
  con = concon() # Connect to railway database
  
  dbAddNote(con, Code, as.character(QueryRow$Desc)) # Updates on the Railway end
  
  # Step 6.)     Place back into the Database
  
  Database[Row_Num,] = QueryRow
  write.csv(Database, "../Database/WL_Database.csv", row.names = FALSE)
    
}

# ------------------------------------------------- #

#               QueryCleanup Function               #

# ------------------------------------------------- #
#####################################################
#################### Description #############-#[]#X#
#####################################################
# Advanced searches by default will save to a       #
# shared path in the directory. This function runs  #
# to clean up any files that over one day old.      #
#####################################################

QueryCleanup = function(){
  
  #Step 1.)     Check correct working directory and load list of files in the UserQuery folder
  
  # setwd("E:/R/Wang Lab/WLDB/Scripts")
  setwd(getwd())
  
  # if(getwd() != "E:/R/Wang Lab/WLDB/Scripts"){
  #   
  #   print("Could not complete cleanup. Please check if the correct WD is set.")
  #   
  # }
  
  fragments = list.files("../UserQuery")
  
  #Step 2.)     If there are files, run a loop. If not, end.
  
  if(length(fragments) > 0){
    
    for(s in 1:length(fragments)){
      
      #Gather Julian date from file
      current.frag = strsplit(fragments[s], split = "-")
      
      cf.date = as.numeric(as.POSIXlt(as.Date(paste(current.frag[[1]][1], current.frag[[1]][2], current.frag[[1]][3], sep = "-")))$yday)
      
      #Compare against current date and remove file
      today = as.numeric(as.POSIXlt(Sys.Date())$yday)
      
      if(abs(today - cf.date) > 1){
        
        file.remove(paste("../UserQuery/", fragments[s], sep = ""))
        
      }
    }
    
  }
  
}

#####################################################
### Railway Database Scripts                      ###
### Version 1.0                                   ###
#####################################################
### Authors: Jason King, Sam Schafer              ###
#####################################################

# ------------------------------------------------- #

#####################################################
#################### Description #############-#[]#X#
#####################################################
# A series of scripts that allows the connection to #
# and modification of information in a Railway      #
# database.                                         #
#####################################################

# ------------------------------------------------- #

#                 Connect Function                  #

# ------------------------------------------------- #
#####################################################
#################### Description #############-#[]#X#
#####################################################
# Function that uses no input parameters.           #
# When utilizes the dbConnect function in the       #
# RPostgres package to access a Postgres dataset    #
# hosted on Railway.                                #                           
#                                                   #
# Returns an RPostgres database object.             #
#####################################################

concon = function(){
  
  # Load in the require packages
  
  library(pak)
  library(getPass)
  library(sodium)
  library(RPostgres)
  library(DBI)
  
  # Connect using the dbConnect function with the Railway parameters
  
  params = read.table("../Setup/UserSettings.txt", sep = "=")[1:5,1]
  
  con = dbConnect(
    RPostgres::Postgres(),
    dbname = params[1],                           # Database name
    host = params[2],             # Public host for external connections
    port = as.numeric(params[3]),                                 # The port from the public network connection
    user = params[4],                            # Default username
    password = params[5] # Your password
  )
  
  # Check the connection, return database connection if successful.
  
  if (dbIsValid(con)) {
    
    return(con)
    
  } 
  
}

# ------------------------------------------------- #

#             Dataset Retrieval Function            #

# ------------------------------------------------- #
#####################################################
#################### Description #############-#[]#X#
#####################################################
# Uses a RPostgres object as a parameter and simply #
# retrieves a copy of the current database as a     #
# CSV file.                                         #
#####################################################

dbGet = function(con) {
  
  # Load in the require packages
  
  library(pak)
  library(getPass)
  library(sodium)
  library(RPostgres)
  library(DBI)
  
  table_name = "wl_database"
  
  # list table
  selected_columns = dbListFields(con, table_name)
  
  # SQL query
  columns_str = paste(sprintf('"%s"', selected_columns), collapse = ", ")
  query = sprintf("SELECT %s FROM %s;", columns_str, table_name)
  
  data = dbGetQuery(con, query)
  
  colnames(data) = c("Code", "Accession", "Source", "Prox_Source", "Add_ID_1", "Add_ID_2", "Species", "Researcher", "Harvest", "DoE", "Desc")
  
  write.csv(data, "../Database/WL_Database.csv", row.names = FALSE)
  
}

# ------------------------------------------------- #

#             Dataset Register Function             #

# ------------------------------------------------- #
#####################################################
#################### Description #############-#[]#X#
#####################################################
# Uses a RPostgres object as a parameter along with #
# all created fields from the Register() function.  #
# Appends the most recent entry into the Postgres   #
# database in Railway.                              #
#####################################################

dbRegister = function(con, Code, Accession, Source, Prox_Source, Add_ID_1, Add_ID_2, Species, Researcher, Harvest, DoE, Desc) {
  
  # Load in the require packages
  
  library(pak)
  library(getPass)
  library(sodium)
  library(RPostgres)
  library(DBI)
  
  # SQL query -- needed to replace the '' with $10, might need to include it as well
  query = "
    INSERT INTO wl_database (code, accession_name, source, prox_source, add_id_1, add_id_2, species, researcher, harvest, doe, des)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
  "
  
  # Execute the query
  dbExecute(con, query, params = list(Code, Accession, Source, Prox_Source, Add_ID_1, Add_ID_2, Species, Researcher, Harvest, DoE, Desc))
  
}

# ------------------------------------------------- #

#         Dataset Note Appending Function           #

# ------------------------------------------------- #
#####################################################
#################### Description #############-#[]#X#
#####################################################
# Uses a RPostgres object as a parameter along with #
# the WL code to modify and new description.        #
# Overwrites the existing description of the        #
# specified row with the modified description       #
# created with the addNote() function.              #
#####################################################

dbAddNote = function(con, Code, Desc) {
  
  # Load in the require packages
  
  library(pak)
  library(getPass)
  library(sodium)
  library(RPostgres)
  library(DBI)
  
  # get the current note for the specified Code
  current_note_query = sprintf("SELECT des FROM wl_database WHERE code = %s", dbQuoteString(con, Code))
  current_note_result = dbGetQuery(con, current_note_query)
  current_note = current_note_result$desc[1]
  
  # update 
  query = sprintf("UPDATE wl_database SET des = %s WHERE code = %s",
                  dbQuoteString(con, Desc), dbQuoteString(con, Code))
  
  # execute the update query
  dbExecute(con, query)
  
}

# ------------------------------------------------- #

#            User Authentication Function           #

# ------------------------------------------------- #
#####################################################
#################### Description #############-#[]#X#
#####################################################
# Uses a RPostgres object as a parameter along with #
# the username and password as character strings.   #
# Returns TRUE if the user exists in the database,  #
# and returns FALSE if the user doesn't exist OR    #
# if the password is incorrect.                     #
#####################################################

conLogin = function(con, user, password){
  
  library(pak)
  library(getPass)
  library(sodium)
  library(RPostgres)
  library(DBI)
  
  # prompt the user for their username and password
  username = user
  user_password = password
  
  # Pull all users from the database
  users = as.vector(unlist(dbGetQuery(con, "SELECT username FROM users;")))
  
  # verify username
  
  if(username %in% users){
    
    # verify password
    # retrieve the stored password hash from the database
    query = "SELECT password_hash FROM users WHERE username = $1;"
    result = dbGetQuery(con, query, params = list(username))
    
    stored_password_hash = result$password_hash[1]
    
    # verify the password
    if (sodium::password_verify(stored_password_hash, user_password)) {
      
      # Correct username and password
      return(TRUE)
      
    } else {
      
      # Usename correct, wrong password
      return(FALSE)
      
    }
    
  } else {
    
    # User does not exist, return false
    return(FALSE)
    
  }
  
}