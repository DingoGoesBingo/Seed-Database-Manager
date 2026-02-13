# Setup script for the wizard application.

# Make sure to follow all prompts in the console below the script! Running this will require you to enter text into the console (below the script).

runSetup = function(dir, zip, mode, dbparams = NULL){
  
  print(dbparams)
  
  # Install packages
  
  if(!require(pak)){install.packages("pak")}
  if(!require(getPass)){install.packages("getPass")}
  if(!require(sodium)){install.packages("sodium")}
  if(!require(RPostgres)){install.packages("RPostgres")}
  if(!require(DBI)){install.packages("DBI")}
  if(!require(RSQLite)){install.packages("RSQLite")}
  
  library(pak); library(getPass); library(sodium); library(RPostgres); library(DBI); library(RSQLite)
  
  # Unpack the ZIPPED application contents to directory
  
  dir = file.path(dir, "SeedDatabaseManager")
  
  if(!dir.exists(dir)){
    
    dir.create(dir, recursive = TRUE, mode = "0777")
  
  }
  
  unzip(zipfile = zip, exdir = dir, overwrite = TRUE)
  
  # Create SQlite (if local)
  
  if(mode == "localHost"){
    
    currentDir = getwd()
    
    sqliteDir = path.expand(file.path(dir, "SQL/"))
    
    if(!dir.exists(sqliteDir)){
      
      dir.create(sqliteDir, recursive = TRUE, mode = "0777")
      
    }
    
    file.create(file.path(sqliteDir, "sdm.sqlite"))
    
    con = dbConnect(RSQLite::SQLite(), dbname = file.path(sqliteDir, "sdm.sqlite"))
    dbDisconnect(con)

    
  }

  # Update UserSettings file in target location
  
  if(is.null(dbparams) == TRUE && mode == "localHost"){
    
    # All params should be 'sql', except for dbname, which is the path
    lines = readLines(file.path(dir, "Setup/UserSettings.txt"))
    
    lines = gsub("your-database-name", file.path(sqliteDir, "sdm.sqlite"), lines)
    lines = gsub("your-database-host", "sql", lines)
    lines = gsub("your-database-user", "sql", lines)
    lines = gsub("your-database-password", "sql", lines)
    
    writeLines(lines, file.path(dir, "Setup/UserSettings.txt"))
    
  } else {
    
    # Overwrite all temp params with correct ones from remote host
    lines = readLines(file.path(dir, "Setup/UserSettings.txt"))
    
    lines = gsub("your-database-name", dbparams$dbname, lines)
    lines = gsub("your-database-host", dbparams$dbhost, lines)
    lines = gsub("12345", dbparams$dbport, lines)
    lines = gsub("your-database-user", dbparams$dbuser, lines)
    lines = gsub("your-database-password", dbparams$dbpwrd, lines)
    
    writeLines(lines, file.path(dir, "Setup/UserSettings.txt"))
    
  }
  
  # Run database modification scripts
  
  prevDir = getwd()
  setwd(file.path(dir, "Scripts"))
  
  print(getwd())
  
  source("../Scripts/SDM_Main_Script.R")
  source("../Scripts/RailwayScripts.R")
  
  con = concon()

  generate_data_table(con)
  generate_researcher_table(con)
  generate_species_table(con)
  generate_user_table(con)
  generate_group_table(con)
  
  setwd(prevDir)
  
}

generateUsers = function(dir, n, l){
  
  if(!require(shiny)){install.packages("shiny")}
  library(shiny)
  
  dir = file.path(dir, "SeedDatabaseManager")
  
  prevDir = getwd()
  setwd(file.path(dir, "Scripts"))
  
  print(getwd())
  
  source("../Scripts/SDM_Main_Script.R")
  source("../Scripts/RailwayScripts.R")
  
  con = concon()
  
  for(jackal in 1:n){
    
    added = add_user(con, u = l[[jackal]]$username,
             p = l[[jackal]]$password,
             c = l[[jackal]]$confpwrd)
    
    print(added)
    
    if(added == FALSE){
      
      showNotification("Username already exists or given passwords are not identical. Please try again.", type = "error")
      
    } else {
      
      showNotification("User successfully added!", type = "message")
      
    }
    
  }
  
  setwd(prevDir)
  
}

modifySpecies = function(dir, n, l){
  
  if(!require(shiny)){install.packages("shiny")}
  library(shiny)
  
  dir = file.path(dir, "SeedDatabaseManager")
  
  prevDir = getwd()
  setwd(file.path(dir, "Scripts"))
  
  print(getwd())
  
  source("../Scripts/SDM_Main_Script.R")
  source("../Scripts/RailwayScripts.R")
  
  con = concon()
  
  for(jackal in 1:n){

    print(l[[jackal]])
    
    DBI::dbExecute(
      con,
      "INSERT INTO species (species) VALUES ($1);",
      params = list(l[[jackal]]$scientificname)
    )
    
    showNotification("Species successfully added!", type = "message")
    
  }
  
  setwd(prevDir)
  
}

modifyResearcher = function(dir, n, l){
  
  if(!require(shiny)){install.packages("shiny")}
  library(shiny)
  
  dir = file.path(dir, "SeedDatabaseManager")
  
  prevDir = getwd()
  setwd(file.path(dir, "Scripts"))
  
  print(getwd())
  
  source("../Scripts/SDM_Main_Script.R")
  source("../Scripts/RailwayScripts.R")
  
  con = concon()
  
  for(jackal in 1:n){
    
    print(l[[jackal]])
    
    DBI::dbExecute(
      con,
      "INSERT INTO researchers (username) VALUES ($1);",
      params = list(l[[jackal]]$careerid)
    )
    
    showNotification("Researcher successfully added!", type = "message")
    
  }
  
  setwd(prevDir)
  
}

finishSetup = function(dir, l){
  
  showNotification("Finalizing your application settings. Please wait!", type = "message")
  
  dir = file.path(dir, "SeedDatabaseManager")
  
  prevDir = getwd()
  setwd(file.path(dir, "Scripts"))
  
  print(getwd())
  
  # Update preferences 
  lines = readLines(file.path(dir, "Setup/UserSettings.txt"))
  
  lines = gsub("TAG", l$step6$tagTxt, lines)
  lines = gsub("codeDigits=4", paste("codeDigits=", l$step6$tagNum, sep = ""), lines)
  lines = gsub("your-group-name", l$step6$grpTxt, lines)
  
  if(!require(magick)){install.packages("magick")}
  library(magick)
  
  tmp = tempfile(); writeBin(l$step6$grpImg, tmp)
  imgInfo = image_info(image_read(tmp))
  
  lines = gsub("groupImageHeight=112", paste("groupImageHeight=", imgInfo$height, sep = ""), lines)
  lines = gsub("groupImageWidth=281", paste("groupImageWidth=", imgInfo$width, sep = ""), lines)
  
  writeLines(lines, file.path(dir, "Setup/UserSettings.txt"))
  
  writeBin(object = l$step6$grpImg, con = file.path(dir, "Setup/groupImage/group.png"))
  
  # Local deployment
  
  if(l$step1$hostMode == "localHost"){
    
    if(Sys.info()["sysname"] == "Darwin"){
      
      # Creating launcher (FOR MAC)
      
      deskPath = file.path(path.expand("~"), "Desktop")
      cmdFile = file.path(deskPath, "SeedDatabaseManager.command")
      
      scriptCode = c("#!/bin/bash", paste("cd ", dir, sep = ""), "Rscript runapp.R", "")
      writeLines(scriptCode, cmdFile)
      Sys.chmod(cmdFile, mode = "0755")
      
    } else if(Sys.info()["sysname"] == "Windows"){
      
      # Create launcher (FOR Windows)
      
    } else {
      
      # Create launcher (FOR UNIX/LINUX)
      
      
      
    }
    
  } else if(l$step1$hostMode == "remoteHost"){
    
    if(l$step3$remoteOption == "di"){
      
      showNotification("Stopping docker daemon...", type = "message", duration = 10)
      system("pkill -f Docker")
      Sys.sleep(10)
      
      showNotification("Starting docker daemon...", type = "message", duration = 30)
      system("open -a Docker")
      Sys.sleep(30)
      
      # Need to check if Docker is open, if not, try to open it again.
      testLog = TRUE; logCount = 1
      
      while(testLog == TRUE && logCount <= 5){
        
        test = system2(Sys.which("docker"), "info", stdout = TRUE, stderr = TRUE)
        
        testLog = grepl("Cannot connect to the Docker daemon", test[47])
        
        Sys.sleep(30)
        
        # Try to open Docker again if it isn't open
        if(testLog == TRUE){
          
          system("open -a Docker")
          
        }
        
        logCount = logCount + 1
         
      }
      
      if(testLog == TRUE && logCount > 5){
        
        showNotification("Could not start Docker Desktop. Is it installed correctly?", type = "error")
        return()
        
      }
      
      rm(test); rm(testLog); rm(logCount)
      
      setwd("..")
      
      showNotification("Building dockerfile... This will take several minutes!", type = "message", duration = 60)
      
      if(Sys.info()["sysname"] != "Windows"){
        
        system2(Sys.which("docker"), c("build", "--platform=linux/amd64", "-t", "sdmapp", "."))
        
      }
      
      setwd("..")
      
      showNotification("Docker image has been saved to your specified directory from Step 2!", type = "message")
      system2(Sys.which("docker"), c("save", "-o", file.path(getwd(), "sdmapp.tar"), "sdmapp"))
      
    } else if(l$step3$remoteOption == "gh"){
      
      showNotification(paste("Setup complete! The files in ", file.path(getwd(), "SeedDatabaseManager"), " can be saved to a new GitHub branch or a new repository for deployment!"), type = "message", duration = 15)
      
    }
    
  }
  
  setwd(prevDir)
  
  showNotification("Setup complete!", type = "message", duration = 15)
  
}
