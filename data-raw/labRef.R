# A set of API's to build a node list for WQI's Eagle.IO instance

#Load required libraries::
Packages <- c("httr", "jsonlite", "tidyverse")
lapply(Packages, library, character.only=TRUE)


APIKEY <- Sys.getenv("EIO_KEY")


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
labRef = do.call(rbind, datalist)

#filter new dataframe to remove non-essential nodes
labRef <- labRef %>%
  filter(name != "Site Management" & name != "Rain Gauges" & name != "Anomaly Detection")

# Drill down deeper for logger  ID's

datalist = list() #new blank list to store data

# for each SITE, find the ID for the Real Time Data Folder, then find the Logger ID
for (i in 1:(dim(labRef)[1])) {

  SiteID <- labRef$`_id`[i]
  URL <- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",SiteID,")",sep="")
  API <- GET(URL,
                   add_headers('X-Api-Key' = APIKEY,
                               'Content-Type' = "application/json"))
  LAB_content=fromJSON(rawToChar(API$content))
  LAB <- LAB_content %>%
    filter(name == "Lab Data")
  LAB <- LAB[1,1]

  URL <- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",LAB,")",sep="")
  API <- GET(URL,
                     add_headers('X-Api-Key' = APIKEY,
                                 'Content-Type' = "application/json"))
  content=fromJSON(rawToChar(API$content))
   content <- content %>%
     filter(grepl('Text File Source',name))

  datalist[[i]] <- content # add it to your list
}

SiteList = do.call(rbind, datalist)

#add column to labRef to house the logger ID's
labRef[, 'TextFileSource'] <- NA

#If a logger is found, add it to the list
for (i in 1:(dim(labRef)[1])) {
 if (length(datalist[[i]][["_id"]]) > 0) {
   labRef$`TextFileSource`[i] <- datalist[[i]][["_id"]]
   } else ""
}

# API call to extract logger parameters
datalist = list()
for (i in 1:(dim(labRef)[1])) {

  TFS <- labRef$TextFileSource[i]
  URL <- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",TFS,")",sep="")
  API <- GET(URL,
                  add_headers('X-Api-Key' = APIKEY,
                              'Content-Type' = "application/json"))
  content=fromJSON(rawToChar(API$content))

  datalist[[i]] <- content # add it to your list
}


ParamList = datalist[[1]]

#worth filtering to interesting values here
ParamList$test <- !grepl("Qual Code", ParamList$name)
ParamList <- ParamList %>% filter(test == TRUE)




# Nested for loop: runs through each parameter and creates a list of the available nodes for each logger.
for (j in 1:dim(ParamList)) {
  Label = ParamList$name[j]
  labRef[, (Label)] <- NA
  for (i in 1:(dim(labRef)[1])){
    if (length(keep(datalist[[i]][["_id"]], datalist[[i]][["name"]] %in% ParamList$name[j]) > 0)) {
      ID <- keep(datalist[[i]][["_id"]], datalist[[i]][["name"]] %in% ParamList$name[j])
      labRef[i,(Label)] <- ID[1]
    } else ""
  }
}

labRef <- labRef %>%
  add_column("GSnum" = word(labRef$name[1:dim(labRef)[1]], 1),
             .before = "name")

#usethis::use_data(labRef, overwrite = TRUE)

#save the file for use by other apps.
#write.csv(labRef, file = "EIO_API/OUTPUT/LABlabRef.csv")

