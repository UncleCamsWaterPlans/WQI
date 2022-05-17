# A set of API's to build a node list for WQI's Eagle.IO instance

#Load required libraries::
Packages <- c("httr", "jsonlite", "tidyverse")
lapply(Packages, library, character.only=TRUE)


APIKEY <- Sys.getenv("EIO_KEY")


# Contant values as per Eagle.IO nomenclature
LoggerNames <- c("Campbell PakBus Logger", "Logger")
#OPUS/NICO params
NO3Names <- c("OPUSResults - OPUS1000 N NO3", "Nitrate - OPUS-NNO3", "Nitrate - NICO NNO3")
ABS210Names <- c("OPUSResults - OPUS1036 Abs210", "Nitrate - OPUS-ABS210")
RefANames <- c("Nitrate - NICO RefA")
ABS254Names <- c("OPUSResults - OPUS1042 Abs254","Nitrate - OPUS-ABS254")
RefBNames <- c("Nitrate - NICO RefB")
ABS360Names <- c("OPUSResults - OPUS1034 Abs360", "Nitrate - OPUS-ABS360")
RefCNames <- c("Nitrate - NICO RefC")
RefDNames <- c("Nitrate - NICO RefD")
SQINames <- c("OPUSResults - OPUS1060 SQI", "Nitrate - OPUS-SQI", "Nitrate - NICO SQI")
TSSeqNames <- c("OPUSResults - OPUS1016 TSSeq", "Nitrate - OPUS-TSSEQ")

# General params
LevelNames <- c("Main - Level", "Water Depth", "Level")
RSSINames <- c("Public - RSSI", "Public - SignalStrength")
WDENames <- c("Resets - WDE")
OPUSSerialNames <- c("Public - OPUS Serial", "Public - OPUS10 DeviceSerial")

SondePresNames <- c("Public - SondePresent")
NitratePresNames <- c("Public - NitratePresent", "Public - NO3Present")
ADCPPresNames <- c("Public - ADCPPresent")

#Batterys
BattNames <- c("Main - LoggerBattV Min", "Main - BattV")
PestBattNames <- c("Main - PestFrV Min")
PumpBattNames <- c("Main - PumpBattV Min")

#Sampler params
SamplerIONames <- c("Public - SamplerOnOff")
SamplerStateNames <- c("Public - SamplerState")
nFridgeNames <- c("FridgeStatus - NFridgeStatus", "FridgeStatus - NFridgeOnOff", "Public - Sampler1Installed", "FridgeStatus - FridgeOnOff")
pFridgeNames <- c("FridgeStatus - PFridgeStatus", "FridgeStatus - NFridgeOnOff", "Public - Sampler2Installed")
SampleNumNames <-c("Public - SampleNo", "Sampler1 - Sampler1Count")

#Sonde Params
TempNames <- c("Sonde - SondeTemp")
CondNames <- c("Sonde - Conductivity")
TurbNames <- c("Sonde - Turbidity")
DONames <- c("Sonde - DO-mgL")
fDOMNames <- c("Sonde - fDOM-QSU")

ParamList = list(LevelNames, NO3Names, ABS210Names, RefANames, ABS254Names, RefBNames, ABS360Names, RefCNames, RefDNames, SQINames, TSSeqNames,
                 LevelNames, RSSINames, WDENames, OPUSSerialNames,
                 SondePresNames, NitratePresNames, ADCPPresNames,
                 BattNames, PestBattNames, PumpBattNames,
                 SamplerIONames, SamplerStateNames, nFridgeNames, pFridgeNames, SampleNumNames,
                 TempNames, CondNames, TurbNames, DONames,fDOMNames)



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
  URL <- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",WSID,")",sep="")
  API <- GET(URL,
                    add_headers('X-Api-Key' = APIKEY,
                                'Content-Type' = "application/json"))
  Node_content=fromJSON(rawToChar(API$content))

  datalist[[i]] <- Node_content # add it to your list
}

#combine list into dataframe
loggerRef = do.call(rbind, datalist)

#filter new dataframe to remove non-essential nodes
loggerRef <- loggerRef %>%
  filter(name != "Site Management" & name != "Rain Gauges" & name != "Anomaly Detection")

# Drill down deeper for logger  ID's

datalist = list() #new blank list to store data

# for each SITE, find the ID for the Real Time Data Folder, then find the Logger ID
for (i in 1:(dim(loggerRef)[1])) {

  SiteID <- loggerRef$`_id`[i]
  URL <- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",SiteID,")",sep="")
  API <- GET(URL,
                   add_headers('X-Api-Key' = APIKEY,
                               'Content-Type' = "application/json"))
  RTD_content=fromJSON(rawToChar(API$content))
  RTD <- RTD_content %>%
    filter(name == "Real-time Data")
  RTD<-RTD[1,1]

  URL <- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",RTD,")",sep="")
  API <- GET(URL,
                     add_headers('X-Api-Key' = APIKEY,
                                 'Content-Type' = "application/json"))
  Logger_content=fromJSON(rawToChar(API$content))
   Logger_content <- Logger_content %>%
     filter(grepl('Logger',name))
     #filter(name %in% LoggerNames,.preserve = FALSE)
   LoggerID<-Logger_content[1,1]


  datalist[[i]] <- Logger_content # add it to your list
}

SiteList = do.call(rbind, datalist)

#add column to loggerRef to house the logger ID's
loggerRef[, 'loggerID'] <- NA

#If a logger is found, add it to the list
for (i in 1:(dim(loggerRef)[1])) {
 if (length(datalist[[i]][["_id"]]) > 0) {
   loggerRef$loggerID[i] <- datalist[[i]][["_id"]]
   } else ""
}

# API call to extract logger parameters
datalist = list()
for (i in 1:(dim(loggerRef)[1])) {

  LoggerID <- loggerRef$`loggerID`[i]
  URL <- paste("https://api.eagle.io/api/v1/nodes/?attr=_id,name&filter=parentId($eq:",LoggerID,")",sep="")
  API <- GET(URL,
                  add_headers('X-Api-Key' = APIKEY,
                              'Content-Type' = "application/json"))
  param_content=fromJSON(rawToChar(API$content))
  #param <- param_content %>%
  #   filter(name %in% LevelNames,.preserve = FALSE)
  # param<- param[1,1]

  Logger_content <- Logger_content %>%
    filter(grepl('Logger',name))
  #filter(name %in% LoggerNames,.preserve = FALSE)
  LoggerID<-Logger_content[1,1]


  datalist[[i]] <- param_content # add it to your list
}




# Nested for loop: runs through each parameter and creates a list of the available nodes for each logger.
for (j in 1:length(ParamList)) {
  Label = ParamList[[j]][1]
  loggerRef[, (Label)] <- NA
  for (i in 1:(dim(loggerRef)[1])){
    if (length(keep(datalist[[i]][["_id"]], datalist[[i]][["name"]] %in% ParamList[[j]]) > 0)) {
      ID <- keep(datalist[[i]][["_id"]], datalist[[i]][["name"]] %in% ParamList[[j]])
      loggerRef[i,(Label)] <- ID[1]
    } else ""
  }
}

loggerRef <- loggerRef %>%
  add_column("GSnum" = word(loggerRef$name[1:dim(loggerRef)[1]], 1),
             .before = "name")

#usethis::use_data(loggerRef, overwrite = TRUE)

#save the file for use by other apps.
#write.csv(loggerRef, file = "EIO_API/OUTPUT/loggerRef.csv")






