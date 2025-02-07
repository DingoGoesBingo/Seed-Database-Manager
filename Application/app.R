### WARNING -- MAKE SURE THE LATEST VERSION OF R IS INSTALLED --

# Version String!
versionString = "1.0"

# Install packages ----

# if(!require(shiny)){install.packages("shiny")}
# if(!require(shinyjs)){install.packages("shinyjs")}
# if(!require(shinythemes)){install.packages("shinythemes")}
# if(!require(shinyalert)){install.packages("shinyalert")}
# if(!require(stringr)){install.packages("stringr")}
# if(!require(ggplot2)){install.packages("ggplot2")}
# if(!require(DT)){install.packages("DT")}
# if(!require(officer)){install.packages("officer")}

# Loading all packages ----

library(base64enc)
library(shiny)
library(shinyjs)
library(shinythemes)
library(shinyalert)
library(stringr)
library(ggplot2)
library(DT)
library(DBI)

# Initial data load ----

setwd(getwd())

source("../Scripts/Database_Fix_Script.R")
source("../Scripts/SDM_Main_Script.R")
con = concon() # Connects to the railway database
dbGet(con)

data = datafix(as.data.frame(read.csv("../Database/WL_Database.csv")))

# Customization parameters
params = read.table("../Setup/UserSettings.txt", sep = "=")[,1]
useImage = params[11]

if(params[11] == TRUE && file.exists("../Setup/groupImage/group.png")){
  
  groupImage <- base64enc::dataURI(file = "../Setup/groupImage/group.png", mime = "image/png")
  
} 

# Call the remaining SDM scripts ----

source("../Scripts/Label_Controller.R")
source("../Scripts/Label_Printing_Script.R")
source("../Scripts/Database_Collapse_Script.R")
source("../Scripts/templatePolice.R")

# Authentication elements & variables ----

if(dir.exists("../Temporary/timerMem") == FALSE){
  
  dir.create("../Temporary/timerMem")
  
}

if(dir.exists("../Temporary/authDateTime") == FALSE){
  
  dir.create("../Temporary/authDateTime")
  
}

maxtimer = 600
AUTHENTICATED = reactiveValues(var = FALSE) # For logging in/out
timerStart = reactiveValues(var = FALSE) # For logging out
timerCount = reactiveValues(var = maxtimer)

# Reactive lists for researchers, users, and species ----

# Always leave the first option blank, it's required for the drop-down text in the app.
# New researchers and plant species must be added manually on Railway.
Researcher_List = as.list(c("", as.vector(unlist(dbGetQuery(concon(), "SELECT username FROM researchers;")))))
Species_List = as.list(c("", as.vector(unlist(dbGetQuery(concon(), "SELECT species FROM species;")))))
User_List = as.list(c("", as.vector(unlist(dbGetQuery(concon(), "SELECT username FROM users;")))))

# Java code for page refresh ----

jscode <- "shinyjs.refresh_page = function() { history.go(0); }"

# Define UI ----
ui = fluidPage(theme = shinytheme("yeti"),
  
  # Tab title
  tags$head(tags$title(paste(params[10], "Seed Database Manager", "Ver.", versionString, sep = " "))),
  
  #Set up UI dependencies          
  useShinyjs(),
  extendShinyjs(text = jscode, functions = "refresh_page"),
  
  uiOutput("titleImage"),
  # titlePanel(img(src = groupImage, height = as.numeric(params[8]), width = as.numeric(params[9]))),
  
  sidebarLayout(
    sidebarPanel(
      
      # h2(paste("Welcome to the Seed Database Manager,", Sys.info()[7], sep = " ")),
      h2(paste("Welcome to the Seed Database Manager", sep = " ")),
      p("This tool was designed to enhance organization and efficiency of group/lab genetic material by providing a universal and easy-to-use method of storing important seed information. Using this application, you will be able to lookup existing seeds based on desired criteria and register new ones into the shared database."),
      br(),
      p("All scripts for this tool can be accessed via the public GitHub page."),
      hr(),
      radioButtons(inputId = "funcSelection", label = h3("What would you like to do?"), choices = list("Register new seeds" = 1, "Register multiple seeds (template upload)" = 3, "Add a note" = 4), selected = 1),
      
      
      br(),
      h3("Operation Description"),
      uiOutput("instruction1"),
      
      br(),
      hr(),
      uiOutput("RefreshButton"),
      uiOutput("SignOutButton"),
      
      h3("Other Tools"),
      
      br(),
      downloadButton("DManual", "Download the user manual"),
      
      br(),
      downloadButton("DTemplate", "Download the batch template"),
      
      br(),
      uiOutput("eggy")
        
    ),
    
    mainPanel(
      
      fluidRow(
        
        tags$style(HTML("
          #downloadDT {
            font-size: 12px;
            padding: 5px 10px;
          }
        ")),
        
        column(4, align = "left", downloadButton("downloadDT", label = textOutput("downloadDT_selections"), width = 600)), # "Download dataset (.csv)"
        
        column(8, align = "right", radioButtons(inputId = "SearchOptions", h4("Select search type:"), choices = list("Simple search" = 1, "Range search (by code)" = 2, "Multi-search (by code)" = 3), selected = 1, inline = TRUE)),
        
        
        
      ),
      
      fluidRow(
        
        # For simple search
        column(12, align = "right", uiOutput("DTSearch")),
        
        # For ranged search
        column(6, align = "right", uiOutput("DTSearchRangeLeft"), offset = -1),
        column(6, align = "right", uiOutput("DTSearchRangeRight"), offset = -1),
        
        # For exact search
        column(12, align = "right", uiOutput("DTSearchMulti"))
        
      ),
      
      DT::dataTableOutput("database"),
  
      hr(),

      uiOutput("OpTitle"),
      
      fluidRow(
        
        column(4, uiOutput("Accession")),
        
        column(4, uiOutput("Source")),
        
        column(4, uiOutput("Prox_Source"))
        

      ),
      
      fluidRow(
        
        column(4, uiOutput("Add_ID_1")),
        
        column(4, uiOutput("Add_ID_2")),
        
        column(4, uiOutput("Species"))
        
      ),
      
      fluidRow(

        column(4, uiOutput("Researcher")),
        
        column(8, uiOutput("Desc"))
        
      ),
      
      fluidRow(

        column(4, uiOutput("template")),
        
        column(8, uiOutput("UpDesc"))

      ),
      
      fluidRow(
        
        column(4, uiOutput("Username")),
        
        column(4, uiOutput("Password")),
        
        column(4, uiOutput("Authenticate")),
        
      ),
      
      fluidRow(
        
        column(4, uiOutput("FindCode")),
        
        column(4, uiOutput("User")),
        
        column(4, uiOutput("TheNote"))
        
      ),

      
      fluidRow(
        
        br(),
        
        column(4, uiOutput("Register")),
        
        column(8, uiOutput("Register_Warning"))
        
      ),
      
      fluidRow(
        
        hr(),
        
        h6("Seed Database Tool GE ver. 1.0, programmed by Sam Schafer. Additional programming contributed by Jason King.", align = "right")
        
      )
      
    ),

  )
  
)

# Define server logic ----
server = function(input, output) {
  
  # Group logo/image being used?
  output$titleImage = renderUI({
    
    if(useImage == TRUE){
      
      titlePanel(img(src = groupImage, height = as.numeric(params[8]), width = as.numeric(params[9])))
      
    } else if(useImage == FALSE) {
      
      titlePanel(paste(params[10], sep = ""))
      
    } else {
      
      titlePanel("")
      
    }
    
  })
  
  # load data again, so that refreshing the page displays new information
  # setwd(getwd())
  data = as.data.frame(read.csv("../Database/WL_Database.csv"))
  
  # dataset = reactive(data)
  dataset = reactive(datafix(data))
  
  # Search boxes ----
  
  output$DTSearch = renderUI({
    
    if(input$SearchOptions == 1){
      
      textInput("DTSearch", NULL, value = "", placeholder = "Lab code, seed source, key term, etc.")
      
    } 
    
  })
  
  output$DTSearchRangeLeft = renderUI({
    
    if(input$SearchOptions == 2){
      
      textInput("DTSearchRangeLeft", NULL, value = "", placeholder = "Upper end; TAG####")
      
    } 
    
  })
  
  output$DTSearchRangeRight = renderUI({
    
    if(input$SearchOptions == 2){
      
      textInput("DTSearchRangeRight", NULL, value = "", placeholder = "Lower end; TAG####")
      
    } 
    
  })
  
  output$DTSearchMulti = renderUI({

    if(input$SearchOptions == 3){

      textInput("DTSearchMulti", label = NULL, value = "", placeholder = "Separate by commas (TAG####, TAG####, ...)")

    }

  })

  
  # Reactive dataset generation ----
  
  dataset_sub = reactive(
    
    data[grepl(tolower(input$DTSearch), tolower(dbcollapse(data))),]
    
  )
  
  dataset_sub_range = reactive(
    
    # data[which(grepl(tolower(input$DTSearchRangeLeft), tolower(dbcollapse(data)))):which(grepl(tolower(input$DTSearchRangeRight), tolower(dbcollapse(data)))),]
    data[which(grepl(tolower(input$DTSearchRangeLeft), tolower(
      unlist(strsplit(dbcollapse(data), "_"))[seq(1,length(unlist(strsplit(dbcollapse(data), "_"))),10)]
    ))):which(grepl(tolower(input$DTSearchRangeRight), tolower(
      unlist(strsplit(dbcollapse(data), "_"))[seq(1,length(unlist(strsplit(dbcollapse(data), "_"))),10)]
    ))),]
    
  )
  
  dataset_sub_multi = reactive(

    data[c(vecposcall(tolower(input$DTSearchMulti), tolower(unlist(strsplit(dbcollapse(data), "_"))[seq(1,length(unlist(strsplit(dbcollapse(data), "_"))),10)]))),]

  )
  
  # Reactive list of WL Codes, for revamped label printing ----
  
  codeList_full = reactive(

    as.vector(data[,1])

  )

  codeList_sub = reactive(

    as.vector(data[grepl(tolower(input$DTSearch), tolower(dbcollapse(data))),1])

  )

  codeList_sub_range = reactive(

    as.vector(data[which(grepl(tolower(input$DTSearchRangeLeft), tolower(dbcollapse(data)))):which(grepl(tolower(input$DTSearchRangeRight), tolower(dbcollapse(data)))),1])

  )
  
  codeList_sub_multi = reactive(
    
    unlist(strsplit(gsub(" ", "", input$DTSearchMulti), ","))
    
  )
    
  # Generating a number for download clarity for CSV and label ZIP ----
  
  selectionsToDownload_full = reactive(
    
    length(as.vector(data[,1]))
    
  )
  
  selectionsToDownload_sub = reactive(
    
    length(as.vector(data[grepl(tolower(input$DTSearch), tolower(dbcollapse(data))),1]))
    
  )
  
  selectionsToDownload_sub_range = reactive(
    
    length(as.vector(data[which(grepl(tolower(input$DTSearchRangeLeft), tolower(dbcollapse(data)))):which(grepl(tolower(input$DTSearchRangeRight), tolower(dbcollapse(data)))),1]))
    
  )
  
  selectionsToDownload_sub_multi = reactive(
    
    length(unlist(strsplit(gsub(" ", "", input$DTSearchMulti), ",")))
    
  )
  
  # Database visualization -----
  
  output$database = renderDataTable(
    
    if(input$DTSearch == "" && input$SearchOptions == 1){
      
      dataset()
      
    } else if(input$DTSearch != "" && input$SearchOptions == 1){
    
      dataset_sub()
        
    } else if(input$SearchOptions == 2 && (input$DTSearchRangeLeft == "" || input$DTSearchRangeRight == "")){
      
      dataset()
      
    } else if(input$SearchOptions == 2 && input$DTSearchRangeLeft != "" && input$DTSearchRangeRight != ""){
      
      dataset_sub_range()
      
    } else if(input$SearchOptions == 3 && input$DTSearchMulti != ""){
      
      dataset_sub_multi()
      
    } else if(input$SearchOptions == 3 && input$DTSearchMulti == ""){
      
      dataset()
      
    },
    
    options = list(dom = "itlp", columnDefs = list(list(
    targets = 10,
    render = JS(
      "function(data, type, row, meta) {",
      "return type === 'display' && data.length > 6 ?",
      "'<span title=\"' + data + '\">' + data.substr(0, 15) + '...</span>' : data;",
      "}")
  ))), callback = JS('table.page(3).draw(false);'))

  # output$database = renderDataTable({dataset()})
  
  # Displaying number of entries to download for dataset ----
  
  output$downloadDT_selections = renderText({
    
    if(input$DTSearch == "" && input$SearchOptions == 1){
      
      paste("Download database (.csv) ", "[", selectionsToDownload_full(), " entries]", sep = "")
      
    } else if(input$DTSearch != "" && input$SearchOptions == 1){
      
      paste("Download database (.csv) ", "[", selectionsToDownload_sub(), " entries]", sep = "")
      
    } else if(input$SearchOptions == 2 && (input$DTSearchRangeLeft == "" || input$DTSearchRangeRight == "")){
      
      paste("Download database (.csv) ", "[", selectionsToDownload_full(), " entries]", sep = "")
      
    } else if(input$SearchOptions == 2 && input$DTSearchRangeLeft != "" && input$DTSearchRangeRight != ""){
      
      paste("Download database (.csv) ", "[", selectionsToDownload_sub_range(), " entries]", sep = "")
      
    } else if(input$SearchOptions == 3 && input$DTSearchMulti != ""){
      
      paste("Download database (.csv) ", "[", selectionsToDownload_sub_multi(), " entries]", sep = "")
      
    } else if(input$SearchOptions == 3 && input$DTSearchMulti == ""){
      
      paste("Download database (.csv) ", "[", selectionsToDownload_full(), " entries]", sep = "")
      
    }
    
  })
 
  # Downloading database ----
   
  output$downloadDT = downloadHandler(
    
    filename = function(){"SDM_Database.csv"}, 
    content = function(fname){
      write.csv(
        
        if(input$DTSearch == "" && input$SearchOptions == 1){
          
          dataset()
          
        } else if(input$DTSearch != "" && input$SearchOptions == 1){
          
          dataset_sub()
          
        } else if(input$SearchOptions == 2 && (input$DTSearchRangeLeft == "" || input$DTSearchRangeRight == "")){
          
          dataset()
          
        } else if(input$SearchOptions == 2 && input$DTSearchRangeLeft != "" && input$DTSearchRangeRight != ""){
          
          dataset_sub_range()
          
        } else if(input$SearchOptions == 3 && input$DTSearchMulti != ""){
          
          dataset_sub_multi()
          
        } else if(input$SearchOptions == 3 && input$DTSearchMulti == ""){
          
          dataset()
          
        },
        
        fname
        
      )
      
    }
    
  )
  
  # Titles and instructions -----
  
  output$OpTitle = renderUI({
    
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
      
      h3("Register new seeds")
      
    } else if(input$funcSelection == 3 && AUTHENTICATED$var == TRUE) {
      
      h3("Batch seed registration")
    
    } else if(AUTHENTICATED$var == FALSE){
        
      h3("Sign in")
       
    } else if(input$funcSelection == 4 && AUTHENTICATED$var == TRUE){
      
      h3("Add a note to an existing entry")
      
    }
    
  })
  
  output$instruction1 = renderUI({
    
    if(input$funcSelection == 1){
      
      helpText("Register new seeds by entering in the PI number, accession name, species (full scientific name, i.e. Glycine max), seed source, original researcher to whom the seed is relevant to, and a short description of the seed entry. Running this function will automatically generate a new lab code for the new entry (TAG####). Please make sure to double check correct information before submitting!")
      
    } else if(input$funcSelection == 3){
      
      helpText("Registering many seeds at once? This function allows you to upload a template file to allow easier entry into the database. Please download and fill out the template file (see manual for more details).")
      
    } else {
      
      helpText("In the event that more information is available, you can append a note the the description of an existing entry using this function.")
      
    }
    
  })
  
  # Authentication window ----
  
  output$Username = renderUI({
    
    if(AUTHENTICATED$var == FALSE){
      
      textInput("Username", h4("Enter username"), value = "", placeholder = "Username")
      
    }
    
  })
  
  output$Password = renderUI({
    
    if(AUTHENTICATED$var == FALSE){
      
      passwordInput("Password", h4("Enter password"), value = "", placeholder = "Password")
      
    }
    
  })
  
  output$Authenticate = renderUI({
    
    if(AUTHENTICATED$var == FALSE){
      
      actionButton("Authenticate", label = "Authenticate", width = 300)
      
    }
    
  })
  
  # Signing into and out of the database ----
  
  countdownSignout = function(){
    
    timerCount$var = timerCount$var - 1
    
    # Courtesy warning
    if(timerCount$var == 60){
      
      showNotification("Warning: you will be automatically signed out in one minute", duration = 10)
      
    }
    
    # If the user signs out manually
    if(AUTHENTICATED$var == FALSE){
      
      timerCount$var = 0
      
    }
    
    # Countdown and auto-signout
    if(timerCount$var <= 0){
      
      if(AUTHENTICATED$var == TRUE){
        
        # No double messages from signing out manually
        showNotification("Time limit reached, you have been automatically signed out. See you next time!", duration = 10)
        
      }
      
      AUTHENTICATED$var = FALSE
      
    } else {
      
      AUTHENTICATED$var = TRUE
      
      shinyjs::delay(1000,{countdownSignout()})
      
    }
    
  }
  
  observe({
    
    # If session is closed before timer runs out, needs to compare system time with another temp file, to know if the timer needs to end.
    # Technically the timer might not be needed now, but it's nice to have as well.
    if(length(list.files("../Temporary/authDateTime")) > 0){
      
      if(as.numeric(as.POSIXct(Sys.time()) - as.POSIXct(paste(read.table("../Temporary/authDateTime/sys.txt"), collapse = " "))) > 10.1){
        
        file.remove("../Temporary/authDateTime/sys.txt")
        
        AUTHENTICATED$var = FALSE # if this doesn't work, try write.table("0", "../Temporary/timerMem/remaining.txt", row.names = FALSE, col.names = FALSE)
        
      }
      
    }
    
  })
  
  observe({
    
    # Need to check if the timer was previously interupted
    if(length(list.files("../Temporary/timerMem")) > 0){
    
      timerCount$var = as.numeric(read.table("../Temporary/timerMem/remaining.txt")[1,1])
      file.remove("../Temporary/timerMem/remaining.txt")
      
      timerStart$var = TRUE
    
    }
    
  })
  
  observe({
    
    # Starting a new timer
    if(timerStart$var == TRUE){
      
      timerStart$var = FALSE
      
      countdownSignout()
      
    }
    
  })
  
  observeEvent(input$Authenticate,{
    
    if(conLogin(con, input$Username, input$Password) == TRUE){
      
      showNotification("Welcome! Please note, users will automatically be logged out after 10 minutes.", duration = 10)

      # Set log in/out variables
      AUTHENTICATED$var = TRUE
      
      timerCount$var = maxtimer
      timerStart$var = TRUE
      
      write.table(Sys.time(), "../Temporary/authDateTime/sys.txt", row.names = FALSE, col.names = FALSE)
      
    } else {
      
      shinyalert("Incorrect username or password", "Please try again.", type = "error")
      
      AUTHENTICATED$var = FALSE
      
    }
    
  })
  
  # Register inputs -----
  
  output$Accession = renderUI({
    
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
      
      textInput("Accession", h4("Enter common accession name"), value = "", placeholder = "e.g. Cup Leaf")
      
    } 

  })
 
  output$Source = renderUI({
    
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
      
      selectInput("Source", label = h4("Was seed produced by your group (Internal) or retrieved (External)?*"), choices = list("", "Internal", "External"))
      
    } 
    
  })
  
  output$Prox_Source = renderUI({
    
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
      
      textInput("Prox_Source", h4("Enter the proximal source*"), value = "", placeholder = "e.g. GRIN, TAG####")
      
    } 
    
  })
  
  output$Add_ID_1 = renderUI({
    
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
      
      textInput("Add_ID_1", h4("Enter an ID*"), value = "", placeholder = "e.g. PI529014, SA-0944")
      
    } 
    
  })
  
  output$Add_ID_2 = renderUI({
    
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
      
      textInput("Add_ID_2", h4("Enter an additional ID, if applicable"), value = "", placeholder = "e.g. PI529014, SA-0944")
      
    } 
    
  })
   
  output$Species = renderUI({
    
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
      
      selectInput("Species", label = h4("Select a species*"), choices = Species_List)
      
    } 
    
  })
  
  output$Researcher = renderUI({
    
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
      
      #textInput("Researcher", h4("Enter the researcher's career ID*"), value = "", placeholder = "career ID")
      selectInput("Researcher", label = h4("Who is the researcher?*"), choices = Researcher_List)
      
    } 
    
  })
  
  output$Desc = renderUI({
    
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
      
      textInput("Desc", h4("Please provide a description for the entry*"), value = "", placeholder = "Seed info, project, etc.", width = 800)
      
    } 
    
  })
  
  # Batch Upload function ----
  
  output$template = renderUI({
    
    if(input$funcSelection == 3 && AUTHENTICATED$var == TRUE){
      
      fileInput("template", label = h4("Upload a template file"), 
                accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv"))
      
    }
    
  })
  
  output$UpDesc = renderUI({
    
    if(input$funcSelection == 3 && AUTHENTICATED$var == TRUE){
      
      textInput("UpDesc", h4("Please provide a description for all entries*"), value = "", placeholder = "Seed info, project, etc.", width = 800)
      
    } 
    
  })
  

  #Action button function ----
  
  output$Register = renderUI({
    
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
      
      actionButton("Register", label = "Submit information", width = 300)
      
    } else if(input$funcSelection == 3 && AUTHENTICATED$var == TRUE){
      
      actionButton("BatchRegister", label = "Submit batch registration", width = 300)
      
    } else if(input$funcSelection == 4 && AUTHENTICATED$var == TRUE){
      
      actionButton("AddNote", label = "Append note to description", width = 300)
      
    }
    
  })
  
  output$Register_Warning = renderUI({
  
    if(input$funcSelection == 1 && AUTHENTICATED$var == TRUE){
    
      helpText("Note: Before submitting, please make sure all the above information is correct and free of typos. Boxes can be left empty, but it is not recommended to do so. The application will refresh upon registration. * = Required field.")
    
    } else if(input$funcSelection == 3 && AUTHENTICATED$var == TRUE){
      
      helpText("Note: For this function to work properly, you must download and fill out the template sheet. The description is filled out seperately and appended to all new entries. Please be aware, this process may take a while. Go grab yourself a cup of coffee while you wait!")
      
    } else if(input$funcSelection == 4 && AUTHENTICATED$var == TRUE){
      
      helpText("Note: Upon addition of new information, a date tag is automatically generated and appended to the description. Please be aware, this date tag is flanked by asterisk (*) characters, which means that (*) cannot be a character in a note entry.")
      
    }
  
  })
  
  # Perform seed registration using input parameters, generate popup window, and refresh application ----
  
  observeEvent(input$Register, {
    
    if( input$Source == "" || input$Prox_Source == "" || input$Add_ID_1 == "" ||input$Species == "" || input$Researcher == "" || input$Desc == ""){
      
      shinyalert("Registration Failed", "Please input the required information before continuing.", type = "error")
      
    } else {
      
      showNotification("Batch registration is running. This may take a second!", duration = 5)
      
      Register(Accession = input$Accession, Source = input$Source, Prox_Source = input$Prox_Source, Add_ID_1 = input$Add_ID_1, Add_ID_2 = input$Add_ID_2, Species = input$Species,  Researcher = input$Researcher, Desc = input$Desc)
      
      shinyalert("Registration Complete", "The application will refresh shortly to show your changes.", type = "info")
      
      delay(5000, {
        
        write.table(timerCount$var, "../Temporary/timerMem/remaining.txt", row.names = FALSE, col.names = FALSE)
        
        js$refresh_page()
        
      })
      
    }
    
  })
  
  # Perform batch registration ----
  
  observeEvent(input$BatchRegister, {
      
    if(input$UpDesc == "" || is.null(input$template) == TRUE){
      
      shinyalert("Batch Register Failed", "Please provide a template and description.", type = "error")
      
    } else {
      
      if(templatePolice(as.data.frame(read.csv(input$template$datapath)), rList = as.vector(unlist(Researcher_List)), sList = as.vector(unlist(Species_List))) == "T"){
        
        shinyalert("Batch Register Failed", "Please confirm that there are no blank cells for ID.", type = "error")
        
      } else if(templatePolice(as.data.frame(read.csv(input$template$datapath)), rList = as.vector(unlist(Researcher_List)), sList = as.vector(unlist(Species_List))) == "R") {
        
        shinyalert("Batch Register Failed", "Please confirm that the researcher career names are spelled correctly or exist within the database. If you're adding a researcher who isn't currently in the database, contact the app manager.", type = "error")
        
      } else if(templatePolice(as.data.frame(read.csv(input$template$datapath)), rList = as.vector(unlist(Researcher_List)), sList = as.vector(unlist(Species_List))) == "S") {
        
        shinyalert("Batch Register Failed", "Please confirm that scientific names are being used for species and are spelled correctly. If you're adding a species that isn't currently in the database, contact the app manager.", type = "error")
        
      } else if(templatePolice(as.data.frame(read.csv(input$template$datapath)), rList = as.vector(unlist(Researcher_List)), sList = as.vector(unlist(Species_List))) == "E") {
        
        shinyalert("Batch Register Failed", "Source must either be denoted as 'External' or 'Internal', please double check the file and resubmit.", type = "error")
        
      } else if(templatePolice(as.data.frame(read.csv(input$template$datapath)), rList = as.vector(unlist(Researcher_List)), sList = as.vector(unlist(Species_List))) == "I") {
        
        shinyalert("Batch Register Failed", "Please confirm that there are no blank cells for proximal source.", type = "error")
        
      } else if(templatePolice(as.data.frame(read.csv(input$template$datapath)), rList = as.vector(unlist(Researcher_List)), sList = as.vector(unlist(Species_List))) == "G") {
        
        showNotification("Batch registration is running. This will take a while!", duration = NULL)
        
        RegisterBatch(template = as.data.frame(read.csv(input$template$datapath)), Desc = input$UpDesc)
        
        shinyalert("Batch Registration Complete", "The application will refresh shortly to show your changes.", type = "info")
        
        delay(5000, {
          
          write.table(timerCount$var, "../Temporary/timerMem/remaining.txt", row.names = FALSE, col.names = FALSE)
          
          js$refresh_page()
          
        })
        
      }
      
    }
    
  })
 
  
# Egg ----
  
  output$eggy = renderUI({
    
    if(tolower(input$DTSearch) == "sal"){
      
      img(src = "215bc086-0f4c-4ef8-9efa-70efc454c0fb.png", height = 250, width = 250)
      
    }
    
  })
 
  # Adding note functions ----
  
  output$FindCode = renderUI({
    
    if(input$funcSelection == 4 && AUTHENTICATED$var == TRUE){
      
      selectInput("FindCode", label = h4("Select unique code of desired entry"), choices = data$Code)
      
    }
    
  })
  
  output$TheNote = renderUI({
    
    if(input$funcSelection == 4 && AUTHENTICATED$var == TRUE){
      
      textInput("TheNote", h4("Type in information to append"), value = "", placeholder = "Type here")
      
    }
    
  })
  
  output$User = renderUI({
    
    if(input$funcSelection == 4 && AUTHENTICATED$var == TRUE){
      
      selectInput("User", label = h4("Who is the user?"), choices = User_List)
      
    }
    
  })
  
  # Perform note appending, generate popup window ----
  
  observeEvent(input$AddNote,{
    
    if(input$FindCode == "" || input$TheNote == "" || input$User == "" || grepl("\\*", input$TheNote) == TRUE){
      
      shinyalert("Note appending failed", "Please input the lab code, information you wish to add to the existing entry, and a user. Make sure there are no asterisk symbols (*) in the note you wish to append.", type = "error")
      
    } else if(input$FindCode %in% data$Code == FALSE) {
      
      shinyalert("Note appending failed", "The entered lab code does not exist, please check for typos.", type = "error")
      
    } else {
      
      AddNote(Code = input$FindCode, Note = input$TheNote, User = input$User)
      
      shinyalert("Note sucessfully appended", "The application will refresh shortly to show your changes.", type = "info")
      
      delay(5000, {
        
        write.table(timerCount$var, "../Temporary/timerMem/remaining.txt", row.names = FALSE, col.names = FALSE)
        
        js$refresh_page()
        
      })
      
    }
    
  })
  
  # Refresh button ----
  
  output$RefreshButton = renderUI({
    
    actionButton("RefreshButton", label = "Refresh application", width = 300)
    
  })
  
  observeEvent(input$RefreshButton,{
    
    delay(100, {
      
      write.table(timerCount$var, "../Temporary/timerMem/remaining.txt", row.names = FALSE, col.names = FALSE)
      
      js$refresh_page()
      
    })
    
  })
  
  # Signing out of database ----
  
  output$SignOutButton = renderUI({
    
    if(AUTHENTICATED$var == TRUE){
      
      actionButton("SignOutButton", label = "Sign out", width = 300)
      
    }
    
  })
  
  observeEvent(input$SignOutButton,{
    
    AUTHENTICATED$var = FALSE
    
    showNotification("Successfully signed out, see you next time!", duration = 10)
    
  })
  
  # Other downloads in tools section ----
  
  output$DManual = downloadHandler(
    
    filename = function(){"SDM_User_Manual.pdf"}, 
    content = function(file){
      
      file.copy("../Manual/Seed Database Manager Manual Ver. 1.0.pdf", file)
      
    }
    
  )
  
  output$DTemplate = downloadHandler(
    
    filename = function(){"Batch_Template_Example.csv"}, # previously Batch_Template.csv
    content = function(file){
      
      file.copy("../Template/WL_Template_Example.csv", file)
      
    }
    
  )
  
  output$DTemplate_Ex = downloadHandler(
    
    filename = function(){"Batch_Template_Example.csv"}, 
    content = function(file){
      
      file.copy("../Template/WL_Template_Example.csv", file)
      
    }
    
  )

}


# Run the app 
shinyApp(ui = ui, server = server)