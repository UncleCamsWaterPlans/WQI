#' @title Data extraction from the Water Monitoring Information portal
#'
#' @description
#' Extracts data from the Water Monitoring Information Portal (WMIP). This platform is the front end of DRDMW's Hydstra database. It contains river level, discharge, water quality and rainfall data to lsit a few. What is available for each gauging station can be seen in the WMIP platform. This should be used to determine what parameter codes can be extracted in this funciton.
#'
#' @source \url{https://water-monitoring.information.qld.gov.au/}

#' @param WMIPID A gauging station number as defined in the WMIP platform.
#' @param START Date* to lookback to. Format = "YYYYMMDD"
#' @param param A string referring to the reported variable from the desired site. Refer to \url{https://water-monitoring.information.qld.gov.au/} for information regarding the desired site and what data is available per the desired time period. This parameter defaults to "Level". Options are: level/discharge/rainfall/temperature/conductivity/pH/turbidity
#' @param datasource A string referring to the desired data source for the data to be extracted from. Defaults to "AT" which is the Archive-telemetered composite source. Options are: A/TE/AT/ATQ
#' @param END Date* to end the extraction period on. Format = "YYYYMMDD". Defaults to the system date plus one day.
#'
#' @examples
#' #df_test <- WMIP_Extract("110001D", "20220801", "temperature")
#'
#'
#' @return A data frame containing extracted WMIP data for specified gauging station/parameter.

#' @export

WMIP_Extract <- function(WMIPID, START, param = "level", datasource = "AT", END = format(Sys.Date() + 1, "%Y%m%d")){

  param <- dplyr::case_when(
    param == "level" ~ "varfrom=100.00&varto=100.00",
    param == "discharge" ~ "varfrom=100.00&varto=140.00",
    param == "rainfall" ~ "varfrom=10.00&varto=10.00",
    param == "temperature" ~ "varfrom=2080.00&varto=2080.00",
    param == "conductivity" ~ "varfrom=2010.00&varto=2010.00",
    param == "pH" ~ "varfrom=2100.00&varto=2100.00",
    param == "turbidity" ~ "varfrom=2030.00&varto=2030.00"
  )


  WMIP_URL <- paste("https://water-monitoring.information.qld.gov.au/cgi/webservice.pl?function=get_ts_traces&site_list=",WMIPID,"&datasource=",datasource,"&",param,"&start_time=",START,"&end_time=",END,"&data_type=mean&interval=hour&multiplier=1&format=csv")
  WMIP_URL <- gsub(" ", "", WMIP_URL, fixed = TRUE)

  API <- httr::GET(WMIP_URL, timeout = 30)
  WMIPData <- readr::read_csv(rawToChar(API$content))

  if (grepl("error", names(WMIPData)[1])) {
    WMIPData <- tibble::tibble("site" = WMIPID,
                               "varname" = param,
                               "var" = "error",
                               "time" = NA,
                                "value" = NA,
                                "quality" = NA,
                                )
  } else {
    WMIPData$time <- as.POSIXct(sprintf("%1.0f", WMIPData$time), format="%Y%m%d%H%M%S", origin = "1970-01-01")
  }


  return(WMIPData)
}

