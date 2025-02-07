FROM rocker/shiny:latest

# install R package dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev

# System libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev

# Update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# Required for sodium package
RUN apt-get install -y \	
	libsodium-dev

# Make a directory in the container
RUN mkdir /home/SDM-Build

# Install R dependencies
RUN R -e "install.packages('pak')"

RUN R -e "install.packages(c('shiny', 'shinyjs', 'shinythemes', 'shinyalert', 'stringr','ggplot2', 'DT', 'officer', 'base64enc'))"

RUN R -e "install.packages(c('libsodium', 'sodium', 'getPass','RPostgres','DBI'), dependencies=TRUE,repos='http://cran.rstudio.com/')"

## copy shiny app to shiny server location

COPY ./Application/ /home/SDM-Build/Application
COPY ./Database/ /home/SDM-Build/Database
COPY ./LabelOutput/ /home/SDM-Build/LabelOutput
COPY ./Manual/ /home/SDM-Build/Manual
COPY ./PrintInfo/ /home/SDM-Build/PrintInfo
COPY ./Scripts/ /home/SDM-Build/Scripts
COPY ./Template/ /home/SDM-Build/Template
COPY ./Temporary/ /home/SDM-Build/Temporary
COPY ./UserQuery/ /home/SDM-Build/UserQuery
COPY ./Setup/ /home/SDM-Build/Setup

# Expose the application port
# EXPOSE 3838
ENV PORT=3838

# Run the R Shiny app
CMD ["R", "-e", "shiny::runApp('/home/SDM-Build/Application/app.R', host = '0.0.0.0', port=as.numeric(Sys.getenv('PORT')))"]
 # Rscript /home/SDM-Build/Application/app.R

