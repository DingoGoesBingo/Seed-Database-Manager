# Run this script if you want to switch from Railway to Local Docker deployment
# PLEASE do not run this otherwise, or else you'll have to reverse the changes made yourself!
# (It's not that hard, but it's just annoying)

setwd(getwd())

if(file.exists("../../shiny-server.conf") == FALSE){
  
  # Move the original dockerfile
  file.rename("../../Dockerfile", "../forExternalDeployment/Dockerfile")
  
  # Move the new dockerfile & conf file
  file.rename("../forLocalDocker/Dockerfile", "../../Dockerfile")
  file.rename("../forLocalDocker/shiny-server.conf", "../../shiny-server.conf")
  
  # Modify the new dockerfile with setup info
  df = readLines("../../Dockerfile")
  params = read.table("../UserSettings.txt", sep = "=")[,1]
  
  for(jackal in c(3,5:7)){
    
    df[jackal] = paste(unlist(strsplit(df[jackal],"="))[1],params[jackal-2], sep = "=")
    
  }
  
  write(df, "../../Dockerfile")
  
  # Now run some code in terminal. Might not work for you Windows or Linus users!
  system(paste("cd ", paste(unlist(strsplit(getwd(),"/"))[1:(length(unlist(strsplit(getwd(),"/")))-2)], collapse = "/"),"; docker build --platform=linux/amd64 -t sdm-application .", sep = ""))
  
}

