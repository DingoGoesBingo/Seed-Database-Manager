# This script is dedicated to adding new users

if(!require(pak)){install.packages("pak")}
if(!require(getPass)){install.packages("getPass")}
if(!require(sodium)){install.packages("sodium")}
if(!require(RPostgres)){install.packages("RPostgres")}
if(!require(DBI)){install.packages("DBI")}

source("../Scripts/RailwayScripts.R")
source("../Scripts/SDM_Main_Script.R")

add_user(concon())