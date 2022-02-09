#functions for extracting data from WQI's eagle.IO instance

#requires:
#APIKEY == This is required for all functions and can be generated from the account settings in WQI's Eagle.IO instance
#param == a node ID of a given parameter in eagle.IO, noting historic will only work with nodes that contain historic data


EIO_Hist <- function(APIKEY, param, START) {
  #param -- MUST be a node ID corresponding to a historic data source (ie level/N-NO3/Turbidity)
  #START -- number of days to lookback

  START <- Sys.Date() - START
  END <- Sys.Date() + 1
  URLData <- paste("https://api.eagle.io/api/v1/historic/?params=",param,"&startTime=",START,"&endTime=",END,sep = "")

  #API call GET
  APIData <- httr::GET(URLData,
                       add_headers('X-Api-Key' = APIKEY,
                                   'Content-Type' = "application/json"))
  Node_content=jsonlite::fromJSON(rawToChar(APIData$content))

  return(Node_content[["data"]])
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

EIO_Comms <- function(APIKEY, param) {
  #param -- MUST be a node ID corresponding to a historic data source (ie level/N-NO3/Turbidity)

  URLData <- paste("https://api.eagle.io/api/v1/nodes/?attr=currentStatus,lastCommsSuccess&filter=_id($eq:",param,")",sep="")
  #API call GET
  APIData <- httr::GET(URLData,
                       add_headers('X-Api-Key' = APIKEY,
                                   'Content-Type' = "application/json"))
  Node_content=jsonlite::fromJSON(rawToChar(APIData$content))

  return(Node_content)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

EIO_Node <- function(APIKEY, param) {
  #param -- MUST be a node ID corresponding to a historic data source (ie level/N-NO3/Turbidity)

  URLData <- paste("https://api.eagle.io/api/v1/nodes/?attr=currentValue&filter=_id($eq:",param,")",sep="")
  #API call GET
  APIData <- httr::GET(URLData,
                       add_headers('X-Api-Key' = APIKEY,
                                   'Content-Type' = "application/json"))
  Node_content=jsonlite::fromJSON(rawToChar(APIData$content))

  return(Node_content)
}



# example ::  content <- EIO_Node(APIKEY = "R70p9hO2eAenXNcawRit4bcTyGDISEAWrFG8gL01", param = "59cca1064f2ee90c99b94b2e")
