# Install required packages and load scripts!

if(!require(bslib)){install.packages("bslib")}
if(!require(shiny)){install.packages("shiny")}
if(!require(shinyjs)){install.packages("shinyjs")}
if(!require(shinythemes)){install.packages("shinythemes")}
if(!require(shinyalert)){install.packages("shinyalert")}
if(!require(stringr)){install.packages("stringr")}
if(!require(ggplot2)){install.packages("ggplot2")}
if(!require(DT)){install.packages("DT")}
if(!require(officer)){install.packages("officer")}

if(!require(pak)){install.packages("pak")}
if(!require(getPass)){install.packages("getPass")}
if(!require(sodium)){install.packages("sodium")}
if(!require(RPostgres)){install.packages("RPostgres")}
if(!require(DBI)){install.packages("DBI")}

library(bslib)
library(shiny)
library(shinyjs)

library(pak)
library(getPass)
library(sodium)
library(RPostgres)
library(DBI)

if(!require(shinyFiles)){install.packages("shinyFiles")}
library(shinyFiles)

source("ForSetup/SetupScript.R")

# Variables that will be necessary for setup

wizardInputs = reactiveValues(
  
  step1 = list(),  
  step2 = list(),
  step3 = list(),
  step4 = list(),
  step5 = list(),
  step6 = list()
  
)

users = reactiveValues(n = 1)
species = reactiveValues(n = 1)
career = reactiveValues(n = 1)

# Create a fun retro theme (I did use 'PT for this, cuz it's not necessary lol)

win95_theme = bs_theme(
  # Primary Windows 95 colors
  bg = "#D4D4D4",       
  fg = "#000000",       
  primary = "#000080",  
  secondary = "#008080",
  
  # Classic font: MS Sans Serif or a similar monospace/system font
  base_font = font_face("MS Sans Serif", "Arial", "sans-serif"),
  heading_font = font_face("MS Sans Serif", "Arial", "sans-serif"),
  
  # Adjusting component styles for the 'shiny' look (sharp edges, classic buttons)
  "input-border-radius" = "0rem",
  "btn-border-radius" = "0rem",
  "card-border-radius" = "0rem",
  "border-width" = "2px" 
)

# Define UI for application that draws a histogram
ui = fluidPage(

  # Custom theme
  theme = win95_theme,
  
  # Sidebar
  sidebarLayout(
    
    sidebarPanel(
      
      width = 3,
      
      tags$img(
        src = "installer-3.png",
        width = 32
      ),
      
      uiOutput("processUI")
      
    ),
    
    # Main application window
    mainPanel(
      
      width = 9,
      
      tags$img(src = "SDM Installer Banner Dithered.png", width = 650),
      hr(),
      uiOutput("wizardUI"),
      hr(),
      uiOutput("wizardNav")
      
    )
    
  )

)

# Define server logic required to draw a histogram
server = function(input, output, session) {
  
  # Current wizard step
  step = reactiveVal(1)
  
  next_step = function() step(step() + 1)
  prev_step = function() step(step() - 1)
  
  # Define output for process window ----
  
  output$processUI = renderUI({
      
    req(wizardInputs)
    
    if(step() == 1){
      
      tagList(
      
        p("Step 1: Choose host type", style = "color: #969696;"),
        p("Step 2: Provide database information", style = "color: #969696;"),
        p("Step 3: Generate database", style = "color: #969696;"),
        p("Step 4: Create new users", style = "color: #969696;"),
        p("Step 5: Personalize", style = "color: #969696;"),
        p("Step 6: Confirm setings and finish", style = "color: #969696;"),
      
      )  
      
    } else if(step() == 2){
      
      tagList(
        
        p("Step 1: Choose host type"),
        p("Step 2: Provide database information", style = "color: #969696;"),
        p("Step 3: Generate database", style = "color: #969696;"),
        p("Step 4: Create new users", style = "color: #969696;"),
        p("Step 5: Personalize", style = "color: #969696;"),
        p("Step 6: Confirm setings and finish", style = "color: #969696;")
        
      )  
      
    } else if(step() == 3){
      
      tagList(
        
        p("Step 1: Choose host type"),
        p(paste(wizardInputs$step1$hostMode), style = "color: #008080;"),
        p("Step 2: Provide database information"),
        p("Step 3: Generate database", style = "color: #969696;"),
        p("Step 4: Create new users", style = "color: #969696;"),
        p("Step 5: Personalize", style = "color: #969696;"),
        p("Step 6: Confirm setings and finish", style = "color: #969696;")
        
      )  
      
    } else if(step() == 4){
      
      tagList(
        
        p("Step 1: Choose host type"),
        p(paste(wizardInputs$step1$hostMode), style = "color: #008080;"),
        p("Step 2: Provide database information"),

        p(paste(as.character(wizardInputs$step2$sqliteDir)), style = "color: #008080;"),
        p(paste(as.character(wizardInputs$step2$tempDir)), style = "color: #008080;"),
        p(paste(as.character(wizardInputs$step3$connected)), style = "color: #008080;"),
        
        p("Step 3: Generate and modify database"),
        p("Step 4: Create new users", style = "color: #969696;"),
        p("Step 5: Personalize", style = "color: #969696;"),
        p("Step 6: Confirm setings and finish", style = "color: #969696;")
        
      )  
      
    } else if(step() == 5){
      
      tagList(
        
        p("Step 1: Choose host type"),
        p(paste(wizardInputs$step1$hostMode), style = "color: #008080;"),
        p("Step 2: Provide database information"),
        
        p(paste(as.character(wizardInputs$step2$sqliteDir)), style = "color: #008080;"),
        p(paste(as.character(wizardInputs$step2$tempDir)), style = "color: #008080;"),
        p(paste(as.character(wizardInputs$step3$connected)), style = "color: #008080;"),
        
        p("Step 3: Generate and modify database"),
        p("Step 4: Create new users"),
        p("Step 5: Personalize", style = "color: #969696;"),
        p("Step 6: Confirm setings and finish", style = "color: #969696;")
        
      )  
      
    } else if(step() %in% 6:8){
      
      tagList(
        
        p("Step 1: Choose host type"),
        p(paste(wizardInputs$step1$hostMode), style = "color: #008080;"),
        p("Step 2: Provide database information"),
        
        p(paste(as.character(wizardInputs$step2$sqliteDir)), style = "color: #008080;"),
        p(paste(as.character(wizardInputs$step2$tempDir)), style = "color: #008080;"),
        p(paste(as.character(wizardInputs$step3$connected)), style = "color: #008080;"),
        
        p("Step 3: Generate and modify database"),
        p("Step 4: Create new users"),
        
        p(paste(users$n, "users created", sep = " "), style = "color: #008080;"),
        
        p("Step 5: Personalize"),
        p("Step 6: Confirm setings and finish", style = "color: #969696;")
        
      )  
      
    } else if(step() >= 9){
      
      tagList(
        
        p("Step 1: Choose host type"),
        p(paste(wizardInputs$step1$hostMode), style = "color: #008080;"),
        p("Step 2: Provide database information"),
        
        p(paste(as.character(wizardInputs$step2$sqliteDir)), style = "color: #008080;"),
        p(paste(as.character(wizardInputs$step2$tempDir)), style = "color: #008080;"),
        p(paste(as.character(wizardInputs$step3$connected)), style = "color: #008080;"),
        
        p("Step 3: Generate and modify database"),
        p("Step 4: Create new users"),
        
        p(paste(users$n, "users created", sep = " "), style = "color: #008080;"),
        
        p("Step 5: Personalize"),
        
        p(paste(as.character(wizardInputs$step6$tagTxt), paste(rep("#", as.character(wizardInputs$step6$tagNum)), collapse = ""), sep = ""), style = "color: #008080;"),
        p(paste(as.character(wizardInputs$step6$grpTxt)), style = "color: #008080;"),
        
        p("Step 6: Confirm setings and finish", style = "color: #969696;")
        
      )  
      
    }
    
  })
  
  # Define output for main window ----
  
  output$wizardUI = renderUI({
    
    req(wizardInputs)
    
    tagList(
      
      # Welcome page
      if(step() == 1){
        
        step1UI
        
      } else if(step() == 2){
        
        step2UI
        
      } else if(step() == 3){
        
        step3UI
        
      } else if(step() == 4){
        
        step4UI
        
      } else if(step() == 5){
        
        step5UI
        
      } else if(step() == 6){
        
        step6UI
        
      } else if(step() == 7){
        
        step7UI
        
      } else if(step() == 8){
        
        step8UI
        
      } else if(step() == 9){
        
        step9UI
        
      } else if(step() == 10){
        
        step10UI
        
      }
      
    )
    
  })
  
  # Step 1: Welcome page ----
  
  step1UI = tagList(
    
    h3("Welcome to the Seed Database Manager Setup Wizard!"),
    
    p("This application is designed to simplify the setup process for the Seed Database Manager. Please click 'next' to begin the setup.")
    
  )
  
  # Step 2: Local or Remote? ----
  
  step2UI = tagList(
    
    h3("Will you be hosting the application locally or remotely?"),
    
    p("If you work with sensitive or protected material, it is recommended that you run the application locally via your institution or group's computer. Otherwise, remote hosting allows for more flexibility in accessing your database."),
    
    radioButtons("hostMode", NULL, choices = c("Local (via SQLite)" = "localHost", 
                                                "Remote (via PostreSQL)" = "remoteHost")),
    
  )
  
  # Step 3: Provide database information ----
  
  if(Sys.info()["sysname"] == "Windows"){

    roots = c(Home = fs::path_home(), Drives = getVolumes()())
    
  } else {
    
    roots = c(Home = "~") 
    
  }
  
  shinyDirChoose(input, "sqliteDir", roots = roots, session = session)
  
  output$folder_path = renderPrint({
    req(input$sqliteDir)  
    parseDirPath(roots, input$sqliteDir)
  })
  
  shinyDirChoose(input, "tempDir", roots = roots, session = session)
  
  output$temp_path = renderPrint({
    req(input$tempDir)  
    parseDirPath(roots, input$tempDir)
  })
  
  step3UI = renderUI({
    
    req(wizardInputs)

    if(wizardInputs$step1$hostMode == "localHost"){

      tagList(
        
        h3("Please select storage location for SQLite database"),
        
        p("This location will be where all database information is stored. It is recommended this be a safe location that can't be overwritten or accessed by unauthorized users."),
        
        shinyDirButton("sqliteDir", "Browse...", "Select a folder"),
        
        verbatimTextOutput("folder_path")
        
      )

    } else if(wizardInputs$step1$hostMode == "remoteHost"){
      
      tagList(
        
        h3("Will you be launching the application via a Docker image or through a GitHub project?"),
        p("Some third party services allow you to run the application via a GitHub project, but if you are unsure, it is recommended to choose a docker image."),
        radioButtons("remoteOption", NULL, choices = c("Docker image" = "di", "GitHub project" = "gh")),
        
        h3("Please select a directory location"),
        p("This directory will be where any temporary SDM files are unpacked and where final dockerfile or GitHub files will be written to. If you've selected the GitHub option above, it is recommended that you unpack the files in the same location as your GitHub repository using Github Desktop, that way you can easily push changes once the installation is complete."),
        shinyDirButton("tempDir", "Browse...", "Select a folder"),
        verbatimTextOutput("temp_path"),
        
        h3("Please enter the requested PostgreSQL connection parameters in the boxes below:"),
        p("At this point, you must have a PostgreSQL database set up to continue. If your institution sets this up for you, please contact your administrator and request the parameters names below."),
        
        textInput("dbname", label = NULL, placeholder = "Enter the database name..."),
        textInput("dbhost", label = NULL, placeholder = "Enter the database host..."),
        textInput("dbport", label = NULL, placeholder = "Enter the database port..."),
        textInput("dbuser", label = NULL, placeholder = "Enter the database user..."),
        passwordInput("dbpwrd", label = NULL, placeholder = "Enter the database password..."),
        
        uiOutput("cnt")
        
      )
      
    } 

  })
  
  output$cnt = renderUI({
    
    req(nzchar(input$dbname), nzchar(input$dbhost), nzchar(input$dbport), nzchar(input$dbuser), nzchar(input$dbpwrd))
    
    actionButton("testConnection", "Test connection to database")
    
  })
  
  # Step 4: Update user settings file & generate SQLite database / modify PostgreSQL ----
  
  step4UI = renderUI({
    
    req(wizardInputs)
    
    tagList(
      
      h3("Please click the button below to generate and/or modify the database."),
      
      p("Please note, this may take a while! Go grab yourself a cup of coffee."),
      
      actionButton("dbMods", "Generate and modify connected database.")
      
    )
    
  })
  
  # Step 5: Creating new user(s) ----
  
  step5UI = renderUI({
    
    req(wizardInputs)
    
    tagList(
      
      h3("Please create the desired amount of authorized users below."),
      
      p("Passwords will be encrypted and cannot be viewed on the server backend, so please record your password in a safe location!"),
      
      actionButton("addUser", "Add another user"),
      
      uiOutput("userCredentials"),
      
      uiOutput("saveUserButton")
      
    )
    
  })
  
  # Step 6: Personalize (steps 6-8) ----
  
  output$tagOut = renderPrint({
    req(input$tagTxt)
    req(input$tagNum)
    paste(input$tagTxt, sprintf(paste("%0", input$tagNum, "d", sep = ""), 
                                sample(as.numeric(paste(rep(9, input$tagNum),collapse = "")),1)), sep = "")
  })
  
  step6UI = renderUI({
    
    req(wizardInputs)
      
    tagList(
      
      h3("Customization options"),
      p("Certain aspects of the Seed Database Manager are customizable to your group or institution's liking."),
      hr(),
      h3("Custom entry tag"),
      p("Each entry into the database is provided a unique, chronological entry code, generated by combining custom prefix tag followed by a specefied number of digits. The following screenshot provides an example."),
      tags$img(src = "appscreenshot1_dithered.png"),
      p("In this example, the entry tag is defined as 'WL' followed by 4 digits."),
      br(),
      textInput("tagTxt", label = "Define your prefix tag.", placeholder = "Enter text..."),
      sliderInput("tagNum", label = "Define number of digits", min = 3, max = 9, value = 4),
      verbatimTextOutput("tagOut"),
      hr(),
      h3("Institution / group branding"),
      p("If you have a group name and banner you would like to place at the top of the application, you may type in your institution name and upload an image in the fields below."),
      p(strong("It is recommended that your image/banner not exceed a 800x150.")),
      textInput("grpTxt", label = NULL, placeholder = "Type in institution / group name here..."),
      fileInput("grpImg", label = NULL, accept = c(".png", ".jpg"))
      
    )
    
  })
  
  step7UI = renderUI({
    
    req(wizardInputs)
    
    tagList(
      
      h3("Customization options (continued)"),
      p("Along with the previous customization options, you may add the species your group works with to the database now."),
      h3("Add species"),
      
      actionButton("addSpecies", "Add another species"),
      
      uiOutput("speciesTxt"),
      
      uiOutput("saveSpeciesButton")
      
    )
    
  })
  
  step8UI = renderUI({
    
    req(wizardInputs)
    
    tagList(
      
      h3("Customization options (continued)"),
      p("Additionally, any you may add researchers names/career IDs to the database, which is used to associate entries with a specific researcher."),
      p(strong("Please note that researchers and users are not the same thing, and that you should add researchers even if you've already added them as users.")),
      h3("Add researcher name/career ID"),
      
      actionButton("addCareer", "Add another researcher/career ID"),
      
      uiOutput("careerTxt"),
      
      uiOutput("saveCareerButton")
      
    )
    
  })
  
  # Step 9: Finalize setup ----
  
  step9UI = renderUI({
    
    req(wizardInputs)
    
    tagList(
      
      h3("Finish setup"),
      p("To finish the setup process, please click the button below. This will finalize all preferences and settings provided in the previous steps."),
      
      actionButton("finishSetup", "Run final setup tasks")
      
    )
    
  })
  
  # Step 10: Done!! ----
  
  step10UI = renderUI({
    
    req(wizardInputs)
    
    tagList(
      
      h3("Setup complete!"),
      
      if(wizardInputs$step1$hostMode == "localHost"){
        
        p("Setup is now complete! You may now close this application and launch the Seed Database Manager from your desktop!")
        
      } else if(wizardInputs$step1$hostMode == "remoteHost"){
        
        tagList(
          
          p("Setup is now complete! If you've opted to create a docker image, it should be visible in your Docker Desktop application and additionally saved as a .tar file in your chosen directory from Step 2. From there, you may deploy it from Docker Desktop yourself or share it with your hosting service."),
          p(paste("If you've selected the GitHub option, you may simply copy the files in ", file.path(as.character(wizardInputs$step2$sqliteDir), "SeedDatabaseManager"), " and push to a new branch or repository, which can then be used on your hosting platform!", sep = "")),
          p(strong("You may now close out of this application (make sure to also close the terminal/console)."))
          
        )

        
      }
      
    )
    
  })
  
  # Navigation buttons ----
  output$wizardNav = renderUI({
    
    tagList(
      
      if(step() > 1){
        
        if(!step() %in% c(5,6,8,9,10)){
          
          actionButton("bac", "Back")
          
        }
        
      },
        
      if(step() < 10){
        
        actionButton("nex", "Next")
        
      }
        
    )
    
  })
  
  observeEvent(input$nex, next_step())
  observeEvent(input$bac, prev_step())
  
  # Saving inputs to reactive list ----
  
  observe({
    
    req(input$hostMode)
    
    wizardInputs$step1$hostMode = input$hostMode
    
  })
  
  observe({
    
    req(input$sqliteDir)
    
    wizardInputs$step2$sqliteDir = parseDirPath(roots, input$sqliteDir)
    
  })
  
  observe({
    
    req(input$remoteOption)
    
    wizardInputs$step3$remoteOption = input$remoteOption
    
  })
  
  observe({
    
    req(input$tempDir)
    
    wizardInputs$step2$tempDir = parseDirPath(roots, input$tempDir)
    
  })
  
  userInfo = reactive({
    
    req(users$n)
    
    lapply(1:users$n, function(jackal){
      
          list(username = input[[paste0("user_", jackal)]],
               password = input[[paste0("pwrd_", jackal)]],
               confpwrd = input[[paste0("cwrd_", jackal)]])
      
    })
    
  })
  
  speciesInfo <- reactive({
    
    req(species$n)
    
    lapply(1:species$n, function(jackal) {
      list(
        scientificname = input[[paste0("species_", jackal)]]
      )
      
    })
    
  })
  
  
  careerInfo = reactive({
    
    req(career$n)
    
    lapply(1:career$n, function(jackal){
      
      list(careerid = input[[paste0("researcher_", jackal)]])
      
    })
    
  })
  
  userFields = reactive({
    
    fields = unlist(userInfo())
    
    length(fields) > 0 && all(fields != "" & !is.na(fields))
    
  })
  
  speciesFields = reactive({
    
    req(species$n)
    
    lapply(1:species$n, function(jackal) {
      req(input[[paste0("species_", jackal)]])
    })
    
    vals = sapply(1:species$n, function(jackal) {
      input[[paste0("species_", jackal)]]
    })
    
    all(!is.na(vals) & nzchar(vals))
    
  })
  
  
  careerFields = reactive({
    
    fieldsC = unlist(careerInfo())
    
    length(fieldsC) > 0 && all(fieldsC != "" & !is.na(fieldsC))
    
  })
  
  observe({
    
    req(input$tagTxt)
    
    wizardInputs$step6$tagTxt = input$tagTxt
    
  })
  
  observe({
    
    req(input$tagNum)
    
    wizardInputs$step6$tagNum = input$tagNum
    
  })
  
  observe({
    
    req(input$grpTxt)
    
    wizardInputs$step6$grpTxt = input$grpTxt
    
  })
  
  observe({
    
    req(input$grpImg)
    
    wizardInputs$step6$grpImg = readBin(
      con = input$grpImg$datapath,
      what = "raw",
      n = file.info(input$grpImg$datapath)$size)
    
  })
  
  # Testing database button actions ----
  
  observeEvent(input$testConnection, {
    
    req(nzchar(input$dbname), nzchar(input$dbhost), nzchar(input$dbport), nzchar(input$dbuser), nzchar(input$dbpwrd))
    
    tryCatch({
      
      con = DBI::dbConnect(
        RPostgres::Postgres(),
        dbname   = input$dbname,
        host     = input$dbhost,
        port     = input$dbport,
        user     = input$dbuser,
        password = input$dbpwrd
      )
      
      if(DBI::dbIsValid(con)) {
        
        # store values only after success
        wizardInputs$step3 = list(
          dbname   = input$dbname,
          dbhost   = input$dbhost,
          dbport   = input$dbport,
          dbuser   = input$dbuser,
          dbpwrd   = input$dbpwrd,
          connected = TRUE
        )
        
        showNotification(
          "Database connection successful!",
          type = "message"
        )
        
      }
      
      DBI::dbDisconnect(con)
      
    }, error = function(e) {
      
      wizardInputs$step3$connected = FALSE
      
      showNotification(
        paste("Connection failed:", e$message),
        type = "error",
        duration = NULL
      )
    })
  })
  
  # Running setup script ----
  
  observeEvent(input$dbMods, {
    
    req(wizardInputs)
    
    showNotification("Setup script started. Please wait!", type = "message")
    
    if(wizardInputs$step1$hostMode == "localHost"){
      
      runSetup(dir = wizardInputs$step2$sqliteDir,
               zip = "ForSetup/application.zip",
               mode = wizardInputs$step1$hostMode,
               dbparams = NULL)
      
    } else if(wizardInputs$step1$hostMode == "remoteHost"){
      
      runSetup(dir = wizardInputs$step2$tempDir,
               zip = "ForSetup/application.zip",
               mode = wizardInputs$step1$hostMode,
               dbparams = wizardInputs$step3)
      
    }
    
    wizardInputs$step3$dbsetp = TRUE
    
    showNotification("Setup script finished! You may now continue to the next step.", type = "message")
    
  })
  
  # Adding more than 1 user ----
  
  output$userCredentials = renderUI({
    
    req(users)
    
    tagList(
      
      lapply(1:users$n, function(jackal){
        
        wellPanel(
          
          h4(paste("User", jackal)),
          textInput(paste("user", jackal, sep = "_"), "Username"),
          passwordInput(paste("pwrd", jackal, sep = "_"), "Password"),
          passwordInput(paste("cwrd", jackal, sep = "_"), "Confirm password")
          
        )
        
      })
      
    )
    
  })
  
  output$saveUserButton = renderUI({
    
    if(userFields()){
      
      actionButton("saveUserButton", "Create users")
      
    }
    
  })
  
  observeEvent(input$addUser, {
    
    users$n = users$n + 1
    
  })
  
  observeEvent(input$saveUserButton, {
    
    req(wizardInputs)
    
    if(wizardInputs$step1$hostMode == "localHost"){

      generateUsers(dir = wizardInputs$step2$sqliteDir,
                    n = users$n,
                    l = userInfo())

    } else if(wizardInputs$step1$hostMode == "remoteHost"){

      generateUsers(dir = wizardInputs$step2$tempDir,
                    n = users$n,
                    l = userInfo())

    }
      
  })
  
  # Adding more than 1 species ----
  
  output$speciesTxt <- renderUI({
    
    tagList(
      
      lapply(1:species$n, function(jackal) {
        
        wellPanel(
          
          h4(paste("Species", jackal)),
          
          textInput(
            inputId = paste0("species_", jackal),
            label   = "Scientific name"
          )
          
        )
        
      })
      
    )
    
  })
  
  output$saveSpeciesButton = renderUI({
    
    if(isTRUE(speciesFields())){
      
      actionButton("saveSpeciesButton", "Add species to database")
      
    }
    
  })
  
  observeEvent(input$addSpecies, {
    
    species$n = species$n + 1
    
  })
  
  observeEvent(input$saveSpeciesButton, {
    
          req(wizardInputs)
    
    if(wizardInputs$step1$hostMode == "localHost"){

      modifySpecies(dir = wizardInputs$step2$sqliteDir,
                    n = species$n,
                    l = speciesInfo())

    } else if(wizardInputs$step1$hostMode == "remoteHost"){

      modifySpecies(dir = wizardInputs$step2$tempDir,
                    n = species$n,
                    l = speciesInfo())

    }
    
  })
  
  # Adding more than 1 researcher / career ID ----
  
  output$careerTxt = renderUI({
    
    req(career)
    
    tagList(
      
      lapply(1:career$n, function(jackal){
        
        wellPanel(
          
          h4(paste("Researcher", jackal)),
          textInput(paste("researcher", jackal, sep = "_"), "Researcher name or career ID")
          
        )
        
      })
      
    )
    
  })
  
  output$saveCareerButton = renderUI({
    
    if(careerFields()){
      
      actionButton("saveCareerButton", "Add researcher(s) to the database")
      
    }
    
  })
  
  observeEvent(input$addCareer, {
    
    career$n = career$n + 1
    
  })
  
  observeEvent(input$saveCareerButton, {
    
    req(wizardInputs)
    
    if(wizardInputs$step1$hostMode == "localHost"){
      
      modifyResearcher(dir = wizardInputs$step2$sqliteDir,
                    n = career$n,
                    l = careerInfo())
      
    } else if(wizardInputs$step1$hostMode == "remoteHost"){
      
      modifyResearcher(dir = wizardInputs$step2$tempDir,
                    n = career$n,
                    l = careerInfo())
      
    }
    
  })
  
  # Final setup tasks ----
  
  observeEvent(input$finishSetup, {
    
    req(wizardInputs)
    
    if(wizardInputs$step1$hostMode == "localHost"){
      
      finishSetup(dir = wizardInputs$step2$sqliteDir,
                  l = wizardInputs)
      
    } else if(wizardInputs$step1$hostMode == "remoteHost"){
      
      finishSetup(dir = wizardInputs$step2$tempDir,
                  l = wizardInputs)
      
    }
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
