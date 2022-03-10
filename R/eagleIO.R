#' @title Extract historic data from WQI's eagle.IO instance
#'
#' @description Function for extracting historic data from WQI's eagle.IO instance. Requires a node ID that has connection status information to return (ie. Campbell pakbus logger)
#'
#' @source url{https://wqi.eagle.io/}
#'
#' @param APIKEY This is required for all functions and can be generated from the account settings in WQI's Eagle.IO instance
#' @param param A node ID of a given parameter in eagle.IO, noting historic will only work with nodes that contain historic data (ie level/N-NO3/Turbidity).
#' @param START Date* to lookback to. Format = "YYYY-MM-DD"
#'
#' @examples
#' #content <- EIO_Hist(APIKEY = "XYZ", param = "5903e538bd10c2fa0ce50648", START = 1)
#'
#' @return tibble containing returned historic data, value and quality. Time as "Australia/Brisbane"
#'
#' @export
#'
EIO_Hist <- function(APIKEY, param, START) {
  #param -- MUST be a node ID corresponding to a historic data source (ie level/N-NO3/Turbidity)
  END <- Sys.Date() + 1, "%Y%m%d"
  URLData <- paste("https://api.eagle.io/api/v1/historic/?params=",param,"&startTime=",START,"&endTime=",END,sep = "")

  #API call GET
  APIData <- httr::GET(URLData,
                       httr::add_headers('X-Api-Key' = APIKEY,
                                   'Content-Type' = "application/json"))
  Node_content=jsonlite::fromJSON(rawToChar(APIData$content))

  Data<- tibble::tibble(ts = Node_content[["data"]][["ts"]])
  Data$ts<-as.POSIXct(Data$ts, format="%Y-%m-%dT%H:%M:%S", tz = "UTC")
  attr(Data$ts, "tzone") <- "Australia/Brisbane"

  Data <- Data %>% tibble::add_column("Value" = NA,
                                      "Quality" = NA)
  if ("v" %in% colnames(Node_content[["data"]][["f"]][["0"]])) {
    Data$Value <- Node_content[["data"]][["f"]][["0"]][["v"]]
  } else ""
  if ("q" %in% colnames(Node_content[["data"]][["f"]][["0"]])) {
    Data$Quality <- Node_content[["data"]][["f"]][["0"]][["q"]]
  } else ""

  return(Data)
}





#' @title Extract communications information for a given logger source
#'
#' @description Function for extracting comms data from WQI's eagle.IO instance. Requires a node ID for a DATA SOURCE that has connection status information to return (ie. Campbell pakbus logger)
#'
#' @source url{https://wqi.eagle.io/}
#'
#' @param APIKEY == This is required for all functions and can be generated from the account settings in WQI's Eagle.IO instance
#' @param param == a node ID of a given parameter in eagle.IO, noting historic will only work with nodes that contain historic data
#'
#' @return data frame containing returned comms data
#' @export
EIO_Comms <- function(APIKEY, param) {
  #param -- MUST be a node ID corresponding to a historic data source (ie level/N-NO3/Turbidity)

  URLData <- paste("https://api.eagle.io/api/v1/nodes/?attr=currentStatus,lastCommsSuccess&filter=_id($eq:",param,")",sep="")
  #API call GET
  APIData <- httr::GET(URLData,
                       httr::add_headers('X-Api-Key' = APIKEY,
                                   'Content-Type' = "application/json"))
  Node_content=jsonlite::fromJSON(rawToChar(APIData$content))

  return(Node_content)
}





#' @title Extract node data from WQI's eagle.IO instance
#'
#' @description Will extract the current value for a given NODE ID from WQI's eagle.IO instance.
#'
#' @source url{https://wqi.eagle.io/}
#'
#' @param APIKEY == This is required for all functions and can be generated from the account settings in WQI's Eagle.IO instance
#' @param param == a node ID of a given parameter in eagle.IO, noting historic will only work with nodes that contain historic data
#'
#' @examples
#' #content <- EIO_Node(APIKEY = "XYZ", param = "59cca1064f2ee90c99b94b2e")
#'
#' @return data frame containing returned node data
#' @export
#'
EIO_Node <- function(APIKEY, param) {
  #param -- MUST be a node ID corresponding to a historic data source (ie level/N-NO3/Turbidity)

  URLData <- paste("https://api.eagle.io/api/v1/nodes/?attr=currentValue&filter=_id($eq:",param,")",sep="")
  #API call GET
  APIData <- httr::GET(URLData,
                       httr::add_headers('X-Api-Key' = APIKEY,
                                   'Content-Type' = "application/json"))
  Node_content=jsonlite::fromJSON(rawToChar(APIData$content))

  return(Node_content)
}




