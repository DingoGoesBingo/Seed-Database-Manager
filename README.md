# Welcome to the Seed Database Manager!
[![DOI](https://zenodo.org/badge/929100234.svg)](https://doi.org/10.5281/zenodo.15079114)

The Seed Database Manager (SDM) is a Shiny R application that was designed to centralize storage of seed information and allow for easy access by all members of the group. The development of this tool was inspired by some of the issues we faced planting research plots, where certain varieties seemed to be contaminated. In this scenario, we had no real way of looking back at the seed information because we never kept a record of where our seed was coming from! And thus, the SDM was born!

## Deploying the tool for yourself:

Deploying the tool for yourself is fairly straight-forward! Please follow the steps below!!

### Step 1. Prerequisites

There are a few things that are needed before you get started:
- A GitHub account
- Download [Base R & RStudio desktop client](https://posit.co/download/rstudio-desktop/), required to run set-up code.

#### If you plan to run the tool locally off your machine...
- No other prerequisites!

#### If you plan to run the tool via external hosting platforms...
- [Download Docker Desktop](https://www.docker.com/products/docker-desktop/) *if* you plan to run via a Docker image (used by most hosting platforms).
- [Download GitHub Desktop](https://desktop.github.com/download/) *if* you plan on hosting via external platforms that deploy directly from GitHub (such as [Railway](https://railway.com/)).

### Step 2. Download the files from Zenodo or GitHub

The updated 2.0 release files can be downloaded directly from this GitHub or through [Zenodo](https://doi.org/10.5281/zenodo.15271484). Whichever one you choose, download the 2.0 release to your local machine, as you will need these files to run the setup application.

**Important note: Currently, this software is only tested for use on Apple Silicon & Windows 64-bit systems, so it is recommended you use either of those devices!**

### Step 3. Launching the Setup wizard

By this point, you will need to have Base R and Rstudio installed to your system. Both of these are required to run the setup application and install dependencies! If you plan to use a docker image for your application, you must have Docker Desktop installed by this point as well!

#### For Windows Users

After you've downloaded the files, **double click WINsetup.bat to run the setup application!** This code should open up a CMD prompt first to download dependencies, then open the application on your default browser. If the application does not work, **you may need to edit the Rscript.exe directory in the batch file using notepad!** Currently, the file assumes the default Windows install location for Rstudio: `C:\Program Files\R\R-4.5.2\bin\Rscript.exe`

#### For Mac Users

Once the files have downloaded, **double click MACsetup.command to run the setup application!** Similarly to Windows users, you should see the terminal open up to install dependencies, followed by the application opening via your browser.

### Step 4. Progressing through the Setup Wizard

All necessary components, settings, users, and customization options are done using this application! Please read all the information in each step carefully, as each step of the installation is important for the next!

### Step 5. Optional following installation

Depending on what deployment option you chose, there are a few things that need to be done following installation.

#### Step 5.1. Saving a copy of your settings

In the event where future updates are made available from the original SDM-GE github, you may want to keep a copy of the settings so that you may re-insert them or copy them into the updated project! Navigate to `SeedDatabaseManager/Setup/UserSettings.txt` and **save a copy of this file!**

#### Step 5.2. Removing setup files

You should no longer need the setup files you downloaded, so feel free to remove those!

### Step 6. Deploying the tool!

#### Locally

If you chose to run the application locally, you should notice SeedDatabaseManager.command (Mac) or SeedDatabaseManager.bat (Windows) appear on your desktop. **Double clicking this script will launch the application in your browser!**

#### Via Docker

The dockerfile should be both visible in the Docker Desktop application as well as copied to your specified directory as a .tar file. From here, [you may deploy the application yourself to a containter on Docker Desktop](https://docs.docker.com/get-started/introduction/build-and-push-first-image/) or share the .tar file with your hosting service, if need be!

#### Directly through GitHub

Some services allow you to directly deploy the application through your GitHub account. If you choose to do this, **you can copy the files in the `SeedDatabaseManager` directory directly into a new GitHub repository or branch, and push changes.** 
