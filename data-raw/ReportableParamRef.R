# A set of API's to build a node list for WQI's Eagle.IO instance

#Load required libraries::
Packages <- c("httr", "jsonlite", "tidyverse")
lapply(Packages, library, character.only=TRUE)

APIKEY <- keyring::key_get("EIO_KEY")

# API to pull in a node list ####
URL<-paste("https://api.eagle.io/api/v1/nodes?attr=_id,name&filter=_class($eq:io.eagle.models.node.Workspace)",sep="")
API <- GET(URL,
              add_headers('X-Api-Key' = APIKEY,
                          'Content-Type' = "application/json"))
Wrksp_content=fromJSON(rawToChar(API$content))

# filter workspace names to that which contain the 3digit catchment code
Wrksp_content <- Wrksp_content %>%
                      filter(substr(name, 1,3) <200 & substr(name, 1,3) > 100)

#create a list object to store data
datalist = list()

# for each workspace pull in the Node ID's
for (i in 1:(dim(Wrksp_content)[1])) {

  WSID <- Wrksp_content$`_id`[i]
  URL<- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",WSID,")",sep="")
  API <- GET(URL,
                    add_headers('X-Api-Key' = APIKEY,
                                'Content-Type' = "application/json"))
  content=fromJSON(rawToChar(API$content))

  datalist[[i]] <- content # add it to your list
}

#combine list into dataframe
reportableParamRef = do.call(rbind, datalist)

#filter new dataframe to remove non-essential nodes
reportableParamRef <- reportableParamRef %>%
  filter(name != "Site Management" & name != "Rain Gauges" & name != "Anomaly Detection")

# Drill down deeper for logger  ID's

datalist = list() #new blank list to store data

# for each SITE, find the ID for the Real Time Data Folder, then find the Logger ID
for (i in 1:(dim(reportableParamRef)[1])) {

  SiteID <- reportableParamRef$`_id`[i]
  URL <- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",SiteID,")",sep="")
  API <- GET(URL,
                   add_headers('X-Api-Key' = APIKEY,
                               'Content-Type' = "application/json"))
  RTD_content=fromJSON(rawToChar(API$content))
  RTD <- RTD_content %>%
    filter(name == "Real-time Data")
  RTD <- RTD[1,1]

  URL <- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",RTD,")",sep="")
  API <- GET(URL,
                     add_headers('X-Api-Key' = APIKEY,
                                 'Content-Type' = "application/json"))
  content=fromJSON(rawToChar(API$content))
   content <- content %>%
     filter(grepl('Reportable Parameters',name))

  datalist[[i]] <- content # add it to your list
}

SiteList = do.call(rbind, datalist)

#add column to reportableParamRef to house the logger ID's
reportableParamRef[, 'ReportableParameter'] <- NA

#If a logger is found, add it to the list
for (i in 1:(dim(reportableParamRef)[1])) {
 if (length(datalist[[i]][["_id"]]) > 0) {
   reportableParamRef$`ReportableParameter`[i] <- datalist[[i]][["_id"]]
   } else ""
}

# API call to extract logger parameters
datalist = list()
for (i in 1:(dim(reportableParamRef)[1])) {

  TFS <- reportableParamRef$ReportableParameter[i]
  URL <- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",TFS,")",sep="")
  API <- GET(URL,
                  add_headers('X-Api-Key' = APIKEY,
                              'Content-Type' = "application/json"))
  content=fromJSON(rawToChar(API$content))

  datalist[[i]] <- content # add it to your list
}


ParamList = datalist[[1]]

#worth filtering to interesting values here
# ParamList$test <- !grepl("[0-9]", ParamList$name)
# ParamList <- ParamList %>% filter(test == TRUE)




# Nested for loop: runs through each parameter and creates a list of the available nodes for each logger.
for (j in 1:dim(ParamList)) {
  Label = ParamList$name[j]
  reportableParamRef[, (Label)] <- NA
  for (i in 1:(dim(reportableParamRef)[1])){
    if (length(keep(datalist[[i]][["_id"]], datalist[[i]][["name"]] %in% ParamList$name[j]) > 0)) {
      ID <- keep(datalist[[i]][["_id"]], datalist[[i]][["name"]] %in% ParamList$name[j])
      reportableParamRef[i,(Label)] <- ID[1]
    } else ""
  }
}

reportableParamRef <- reportableParamRef %>%
  add_column("GSnum" = word(reportableParamRef$name[1:dim(reportableParamRef)[1]], 1),
             .before = "name")

#usethis::use_data(reportableParamRef, overwrite = TRUE)

#save the file for use by other apps.
#write.csv(reportableParamRef, file = "EIO_API/OUTPUT/LABreportableParamRef.csv")
