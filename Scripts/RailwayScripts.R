#####################################
## Railway Database Scripts V. 1.0 ##
#####################################
## A series of scripts for setup   ##
## of the Postgres database.       ##
#####################################
## Scripts written by Jason King   ##
## and modified for use in the app ##
## by Sam Schafer                  ##
#####################################

source("../Scripts/SDM_Main_Script.R")
con = concon()

############################
##  generate_data_table() ##
############################
## Creates the database   ##
## table.                 ##
############################

generate_data_table = function(con) {
  # Create the 'wl_database' table if it doesn't exist
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS wl_database (
      code TEXT PRIMARY KEY,
      accession_name TEXT,
      source TEXT,
      prox_source TEXT,
      add_id_1 TEXT,
      add_id_2 TEXT,
      species TEXT,
      researcher TEXT,
      doe TEXT,
      des TEXT
    );
  ")
  cat("Database table created.\n")
}

###############################
##  generate_species_table() ##
###############################
## Creates the table that    ##
## stores all species used   ##
## in the lab                ##
###############################

generate_species_table = function(con) {
  # Create the 'species' table if it doesn't exist
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS species (
      species TEXT PRIMARY KEY
    );
  ")
  cat("Species table created.\n")
}

##################################
##  generate_researcher_table() ##
##################################
## Creates the table that       ##
## stores all researchers       ##
##################################

generate_researcher_table = function(con) {
  # Create the 'researchers' table if it doesn't exist
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS researchers (
      username TEXT PRIMARY KEY
    );
  ")
  cat("Researcher table created.\n")
}

############################
##  generate_user_table() ##
############################
## Creates a user table   ##
## in Railway.            ##
############################

generate_user_table = function(con) {
  # Create the 'users' table if it doesn't exist
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS users (
      username TEXT PRIMARY KEY,
      password_hash TEXT NOT NULL
    );
  ")
  cat("Users table created or already exists.\n")
}

############################
##  list_current_users()  ##
############################
## Lists all users in the ##
## Railway database.      ##
############################

list_current_users = function(con) {
  # retrieve a list of users
  users = dbGetQuery(con, "SELECT username FROM users;")
  if (nrow(users) == 0) {
    cat("No users found in the database.\n")
  } else {
    cat("Current users in the database:\n")
    print(users)
  }
}

############################
##      add_user()        ##
############################
## Database object, from  ##
## concon() used as an    ##
## input. Used in the     ##  
## backened to register   ##
## users to the database  ##
############################

add_user = function(con) {
  
  new_username = readline(prompt = "Enter new username: ")
  
  # check if the username already exists
  existing_user = dbGetQuery(con, "SELECT username FROM users WHERE username = $1;", params = list(new_username))
  
  if (nrow(existing_user) > 0) {
    cat("Username already exists. Please choose a different username.\n")
    return()
  }
  
  repeat {
    new_password = getPass::getPass("Enter new password: ")
    confirm_password = getPass::getPass("Confirm new password: ")
    
    if (new_password != confirm_password) {
      cat("Passwords do not match. Please try again.\n")
    } else if (nchar(new_password) < 8) {
      cat("Password must be at least 8 characters long. Please try again.\n")
    } else {
      break
    }
  }
  
  hashed_password = sodium::password_store(new_password)
  
  dbExecute(con, "
    INSERT INTO users (username, password_hash)
    VALUES ($1, $2);
  ", params = list(new_username, hashed_password))
  
  cat("User", new_username, "added successfully.\n")
}
