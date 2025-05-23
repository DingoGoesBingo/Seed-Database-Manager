# Welcome to the Seed Database Manager!
[![DOI](https://zenodo.org/badge/929100234.svg)](https://doi.org/10.5281/zenodo.15079114)

The Seed Database Manager (SDM) is a Shiny R application that was designed to centralize storage of seed information and allow for easy access by all members of the group. The development of this tool was inspired by some of the issues we faced planting research plots, where certain varieties seemed to be contaminated. In this scenario, we had no real way of looking back at the seed information because we never kept a record of where our seed was coming from! And thus, the SDM was born!

## Deploying the tool for yourself:

Deploying the tool for yourself is fairly straight-forward! Please follow the steps below!!

### Step 1. Prerequisites

There are a few things that are needed before you get started:
- A GitHub account
- RStudio desktop client, required to run set-up code.
- I would also recommend GitHub desktop, so that it's easy to push changes during the set-up.

#### If you plan to run the tool locally off your machine...
- Install PostgreSQL to your device (https://www.postgresql.org/download/)
- Install Docker Desktop, if you plan on running the app from a local container (https://www.docker.com/products/docker-desktop/)

#### If you plan to run the tool via external hosting platforms...
- Access to any platform that can host Shiny R applications and PostgreSQL databases, **I'd recommend Railway** (https://railway.com/) if your institution does not have it's own platform, since it connects directly to the github repo and is inexpensive to continually run.

**For the sake of this README, I will assume that you are using Railway for external hosting, but the steps will largely remain the same.**

### Step 2. Derive your own private copy of the tool

On this GitHub page, click on the green **Use this template** drop-down button, and **create a new repository using this repo as the template**. When creating the new reposity, make sure you set visibility to private, otherwise your **database will be visible to the public**! After you have donw this, I would recommend using the GitHub desktop client to download the files onto your local system, since we will need to make some modifications and run some set-up code. If you plan on using Railway (recommended), this repo will be where Railway retrieves all app data from!

### Step 3. Creating a Postgres database

#### Local hosting:

Once you have installed the PostgreSQL tools on your machine, launch the **pgAdmin** tool. From here, you may already have a local PostgreSQL server set-up by default. You can check by **clicking the Servers drop-down tab on the left side of the application and checking the properties of the PostgresSQL server**. I would recommend deleting this one and creating a new server with the following information:

- Server name: *You can set this to whatever you like*
- Host name/address: **localhost**
- Port: **5432**
- Username: **postgres**
- Password: *You can set this to whatever you like*

You should see you now have a server set up on the left-hand side. You should see it automatically created a database as well called **postgres**. You may keep use this database, or create a new one if you like, just make sure you make a note of the name!

#### Railway/external hosting:

Go to www.Railway.com and sign in using your GitHub account. If you are a first time user, you get a certain amount of credits you can use for free, but after this expires you will have to pay for the service. Your institution may have other methods for deploying Shiny apps, but for us, we just decided it was easier to pay for a Railway subscription. Below are a few links I've attached that will get you started in Railway if you're not familiar, but essentially we want to:
- Create a new project (https://docs.railway.com/quick-start)
- Add a PostgreSQL database template (https://docs.railway.com/guides/postgresql)

Once you've successfully created a Postgres object (the one with the elephant logo!), click on that object and click the *variables* tab on the window that appears on the right hand side. You should see around 13 or so variables that are starred off. These are important for connecting our code in GitHub to the location where our data is saved in the Postgres object.

*Note: these steps will differ if you're using a different hosting platform, but essentially you just need to get a PostgreSQL database set up, and you would need access to the back-end information to connect it to your app!*

### Step 4. Completing the setup file

Now we're going to be modifiying a basic text file and running a setup R script. Assuming you're using GitHub desktop, clone your repository to your local device and navigate to the file location for the project. From there, go to Seed-Database-Manager/Setup and open **UserSettings.txt**. This file contains parameters for connecting to the database, along with a few customization parameters (we'll get to those later in the README)!

For now, we will need to change the following parameters:

```
dbname=your-database-name
host=your-database-host
port=12345
user=your-database-user
password=your-database-password
```
#### Local setup:

All we need to do is simply use those connection parameters we used to set up the local database earlier!

- **your-database-name** replaced with **postgres** (unless you renamed it, or created a new database)
- **your-database-host** replaced with the **localhost**
- **12345** replace with replaced with the **5432**
- **your-database-user** replaced with **postgres**
- **your-database-password** replaced with *the password you set earlier*

Once you've replaced these, you may save the text file and close it! Just make sure the formatting of the file is kept the same as it was (do not add extra spaces between the =, do not create any new lines, etc.).

#### Railway/external setup:

These parameters are pulled into the code that allows you to connect to the PostgreSQL object you just created in Railway a moment ago! You need to replace the following things in this text file with the variables found on your PostgreSQL object:

- **your-database-name** replaced with **POSTGRES_DB**
- **your-database-host** replaced with the public host found in **Settings -> Networking**
- **12345** replace with replaced with the public port found in **Settings -> Networking**
- **your-database-user** replaced with **POSTGRES_USER**
- **your-database-password** replaced with **POSTGRES_PASSWORD**

I recommend using Ctrl+F (or command+F on Mac) to find and replace each of these things to make it easier. Also, make sure to keep the formatting the same (do not add extra spaces between the =, do not create any new lines, etc.). Once you've done this, you can now save and close the text file.

### Step 5. Running the first time setup script

We have our PostgreSQL set up, but we have no actual data tables to save anything to. For this, open the **SetupScript.R** in RStudio and run the entire script using the **Source button** towards the top right of the script. Note that running this script will prompt you several times in the console if you plan on setting up a user account for the database immediately, so **please follow the directions in the console (bottom of the RStudio window) exactly and carefully**! If you decide to set up a user within the setup script, please note that you will then need to enter the desired username into the console. Afterwards, a pop-up window will appear prompting you to enter in a password that is **at least 8 characters in length**. After completing this, you should see the user in the **users** table in the Postgres object on Railway. This code can be prompted to run again if you plan on adding multiple users of the database at this time. Please write your password down somewhere, as there is no way to view it on Railway! You can now close this script.

After this code runs, you should see that there are now 4 new tables under the Data tab in the PostgreSQL object on Railway. To briefly describe these tables:
- **wl_database** is the main table where all seed information will be saved to.
- **researchers** is a simple table that contains names of researchers in the lab/group, used in a few drop-down menus in the application and can be continuously added to easily within Railway.
- **species** is similar to the researcher table described above, but contains information on seed species. Both of these tables were set up this way to prevent spelling issues with repeated information.
- **users** is a table that contains usernames and hashed passwords for authorized users in the database. Note that researchers and users are not necessarily the same thing!

Please note, the **wl_database** is set up to be a "jack of all trades", since all seed information is different. If your group finds that this format isn't useful for the type of seed data you work with, you are welcome to dig into the scripts and change the formatting, but this would require **a lot of changes to the SDM_Main_Script.R and app.R scripts**, so keep that in mind if you plan to do this.

### Step 6. Adding additional authorized users, researchers, and species.

The setup script will have prompted you to set up users initially, but if you find that you need to add more users later on, you can do so by using **opening and sourcing the AddingNewUsers.R script** in the Setup folder.

Once again, you will then need to enter the desired username into the console at the bottom of your screen. Afterwards, a pop-up window will appear prompting you to enter in a password that is **at least 8 characters in length**. After completing this, you should see the user in the **users** table.Please write your password down somewhere, as there is no way to view it on Railway!

#### Step 6.1. Adding researchers and species

The tables that were set up for **species** and **researchers** are meant to make registration of new entries as straight-forward and error free as possible. Note that researchers do not have access to the database and are simply used for organizing *who* the seed germplasm is relevant to! I would recommend using scientific names for species and career ID names for researchers!

##### Local

In the pgAdmin application, navigate to the following location under your database within the local server: **Schemas -> public -> Tables**. You should see the four tables we just created. To add new species, right click on the **species** table and select **View/Edit Data** and then **All Rows**. This will open a new window with a script on top and the currently empty table on the bottom. Right underneath "Data Output" and above the empty table, select the button to **Add Row** and you can now enter text into the new row created in the table (will populate with [null] by default). Make sure you click the **save data changes button** above the datatable before moving on! The same process can be repeated with the **researchers** table. You may repeat this process for as many species or researchers you wish to work with.

##### On Railway

To add new researchers and species to these tables, it is easiest to do so directly in Railway. In the Postgres object, navigate the *data* tab and you should see the 4 tables we created earlier. From there you can individually add new rows to the **species** and **researchers** table. For example, if you have three species that you work with, you would want to add each species scientific name as a new row. Similarly, if you have 10 researchers in your workgroup, you would want to add each researcher individually. Note that researchers do not have access to the database and are simply used for organizing *who* the seed germplasm is relevant to!

### Step 7. Adding flair!

Right now, the unique generated code and image on the top left of the application is set for our lab group, but please feel free to change it!

#### Step 7.1. Changing unique entry code

Just as a brief overview of the unique entry code, it is set up to accept some sort of tag (for us we use **WL**) along with a number of digits to follow (we use 4 digits, but you may use more if you expect to have more than 9,999 total entries). The result is a lab code that generates sequentially with each entry (WL0001, WL0002, ...). You may find that you want to change the tag and digits, and heres how:

Open up the **UserSettings.txt** file again and navigate to the following lines:
```
codeTag=TAG
codeDigits=4
```
Just like the PostgresSQL parameters, these parameters are pulled into the scripts and are used to generate new codes for each entry. You want to edit these lines as follows...

- **TAG** replaced with the tag you wish to be appended to the front of each entry (preferably short at 2-3 characters).
- **4** replaced with the number of digits you wish to follow the tag (we recommend 4-5).

Once you've made the desired changes, save the text file and close! 

#### Step 7.2. Using group branding

To change the image you can simply replace **group.png** in the Seed-Database-Manager-GE/Setup/groupImage folder with the desired image for you lab or group, just make sure the image you choose is renamed to **group.png**! You may find that the **height** and **width** settings may not work well, so feel free to adjust those to the proper width and height of your selected image within the same **UserSettings.txt** file by modifying the following lines:
```
groupImageHeight=112
groupImageWidth=281
groupName=your-group-name
useImage=TRUE
```
Where the width is in pixels, so make sure it matches the dimensions of your image! If your image is fairly large, you may need to set smaller scaled-down values for width and height.

Additionally, you can change **your-group-name** to your research group's title and it will show up in the tab title on your browser! You may also leave it blank if you do not wish to have a group name in the tab title, **just don't remove the groupName=**.

Lastly, you can change whether the group image, group name, or neither are rendered at the top of the application by changing the **useImage** parameter, where **TRUE** renders the group image, **FALSE** instead prints the group name entered for **groupName**, and leaving the option blank will use neither. Just as a warning, there will be an error if you leave it set to TRUE and there is no image named group.png! Once again, **do not remove the useImage=** if you don't plan on using group branding!

#### Step 7.3. Saving a copy of your settings

In the event where future updates are made available from the original SDM-GE github, you may want to keep a copy of the settings so that you may re-insert them or copy them into the updated project! Simply copy and paste this in a safe location, outside of the GitHub files!

### Step 8. Deploying the tool!

#### Locally

There are two ways to access the tool. The simplest being through the RStudio application and the second through local hosting with Docker, the difference between the two mainly being that **docker allows you to continually keep the application running on your host computer**. If you plan to use the first method, you may skip this section and move down to **Step 9**. Otherwise, you will need to follow a series of *rather complicated steps* below. Also, the steps will be slightly different depending on your computer platform and as a result have been adapted to **Mac (Apple Silicon)** and **Windows x86 64 bit** users, which I suspect will make up the majority of the people reading this. For those who prefer to use Linux, I haven't been able to develop a pipeline for this quite yet (sorry)! If you haven't already, **make sure you have Docker Desktop installed and running**, as it will be needed for the below steps (it is linked at the top of the README)! 

##### Step 8.1. Modifying the setup file

The first step will be to change two of the parameters of the setup file. Please open up the setup file and **navigate to these two lines:**

```
host=localhost
```
and
```
useLocalDocker=FALSE
```

All you need to do here is change **localhost** to **host.docker.internal** on the first line shown above, and change **FALSE** to **TRUE** on the second. Once you have done this, save the file and close it!

*Note: we originally kept localhost written for the host name, since that would allow the application run in RStudio to connect to the PostgreSQL database. Because we're using docker, that is why we have to change it again!*

##### Step 8.2. Running the local docker setup file

In the **Setup/forLocalDocker** folder, you will see two R scripts that are labeled for Mac or Windows. For Mac (Apple Silicon) users, please open and **source the LocalDeploymentSetup_M2Mac.R file in RStudio**, similar to when we ran the first setup script before. If you are a Windows user, you will instead open and **source the LocalDeploymentSetup_Winx86.R file in RStudio**. Just a warning, **ONLY run this code if you do not plan to use this for Railway or external hosting!** These scripts will do a few things, but namely:

- Replaces the current dockerfile (setup for Railway) with one suited for Docker Desktop
- Adds a new server configuration file to the root directory 
- Modifies some information in the new dockerfile with database info found in the UserSettings file
- Runs the Terminal/CMD code necessary to create a docker image.

This code should take a while to run, but once it is complete, you should notice a new image show up in the Docker Desktop application called **sdm-applciation**.

##### Step 8.3. Deploying container

On docker desktop, select the **sdm-application** image and click run. You will now be prompted to modify optional settings. Please on this up and **enter 3838 for port** and **give the container a name** (I usually used sdmcont). This will now create a new container on Docker Desktop with the provided name. Navigate to the containers tab and **run the container!** After this, it should be available at localhost:3838 on your web browser!

#### On Railway

Before deploying the GitHub repo onto railway, be sure to push any changes you made to the scripts. I recommended earlier to use GitHub desktop to do this, but you might be one of those turbo geniuses that can just do that in terminal. Either way, push the changes first! 

Once you've done this, you want to go back to Railway and open the same project where the PostgreSQL is deployed. On that same project, you want to deploy the GitHub repo by right clicking the empty space and selecting the option for GitHub repo. From there, select the SDM repo (you may have to change permissions if it doesn't show up)! 

The dockerfile *should* be detected and start building the image, which usually takes around 15-20 minutes since it has to download a bunch of dependencies. I don't think you should need to change anything in the dockerfile, but if it keeps crashing, you may need to make changes to the dockerfile itself. 

To prevent some headaches later, I would recommend making sure that both the PostgreSQL and GitHub object in railway are being hosted in the same region (the build sometimes crashes migrating the host). This can be accessed in the settings for each of these on Railway.

### Step 9. Accessing the tool!

#### Locally

The simplest method for accessing the app would be to navigate to Seed-Database-Manager/Application/ and open **app.R**. In R Studio, there will be a **Run app** button at the top right of the script, which will open a new window with the application interface!

For those who completed the docker desktop steps above, you should be able to access your application by navigating to **localhost:3838** on your web browser, if properly deployed! Please ensure that your browser settings allow for local connections. Just as a ease-of-access tip on Mac, you can drag the URL for **localhost:3838** to your desktop to create a quick shortcut to access the app! On windows, you can similarly do this by right-clicking your desktop and **creating a new shortcut** with **localhost:3838 as the shortcut link**.

#### On Railway

Once it finishes building, you need to generate a web domain name to be able to access the tool via the web. To do this, navigate to **Settings -> Networking** on your GitHub repo object in Railway, and you should see a button to **generate a domain**. After clicking that, it will automatically assign a web link to access the tool, but this link can be changed if you desire. Also, the link will now be visible under the *deployments* tab of the GitHub repo object as well. 
