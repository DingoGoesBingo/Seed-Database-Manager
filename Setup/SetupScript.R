# First time setup script, please read the README on GitHub first!
# Before running this script, make sure you have changed all the settings in the UserSettings.txt file, or else it will not run correctly!
# After you have done these things, click the Source button on the top right of this script.

# Make sure to follow all prompts in the console below the script! Running this will require you to enter text into the console (below the script).

if(!require(pak)){install.packages("pak")}
if(!require(getPass)){install.packages("getPass")}
if(!require(sodium)){install.packages("sodium")}
if(!require(RPostgres)){install.packages("RPostgres")}
if(!require(DBI)){install.packages("DBI")}

source("../Scripts/SDM_Main_Script.R")
source("../Scripts/RailwayScripts.R")
con = concon()

generate_data_table(con)
generate_researcher_table(con)
generate_species_table(con)
generate_user_table(con)

setupUsers = readline(prompt = "Would you like to set up a user now? (please enter 'Y' or 'N'): ")

if(setupUsers == "Y"){
  
  print("Follow the prompts in the console. A pop-up window will also appear on screen for password entry.")
  
  while(setupUser == "Y"){
    
    add_user(con)
    
    setupUsers = readline(prompt = "Would you like to set up another user? (please enter 'Y' or 'N'): ")
    
  }
  
  print("User(s) created, please confirm that new entries exist within the 'user' table in the Railway Postgres object.")
  
} else {
  
  print("Users can be created at any time by running the add_user() function found in Scripts/RailwayScripts.R. Please read the README file on GitHub for detailed instructions.")
  
}

print("Setup complete! Please return to the README file on GitHub for further instructions.")
