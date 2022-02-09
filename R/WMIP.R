#' @title Data extraction from the Water Monitoring Information portal
#'
#' @description
#' Extracts data from the Water Monitoring Information Portal (WMIP). This platform is the front end of DRDMW's Hydstra database. It contains river level, discharge, water quality and rainfall data to lsit a few. What is available for each gauging station can be seen in the WMIP platform. This should be used to determine what parameter codes can be extracted in this funciton.
#'
#' @source url{https://water-monitoring.information.qld.gov.au/}

#' @param WMIPID A gauging station number as defined in the WMIP platform.
#' @param Vfrom Refers to parameter codes (100.00 = level)
#' @param Vto Allows you to leverage the platform to convert level to discharge (ie. Vfrom = 100.00 level , Vto = 140.00 devtoolsdischarge)
#' @param START Date* to lookback to. Format = "YYYYMMDD"
#'
#' @examples
#' #df_test <- WMIP_Extract("112004A", Vfrom = "100.00", Vto = "100.00", START = "20211201")
#'
#'
#' @return A data frame containing extracted WMIP data for specified gauging station/parameter.

#' @export
WMIP_Extract <- function(WMIPID, Vfrom, Vto, START){
  END <- format(Sys.Date() + 1, "%Y%m%d")
  WMIP_URL <- paste("https://water-monitoring.information.qld.gov.au/cgi/webservice.pl?function=get_ts_traces&site_list=",WMIPID,"&datasource=AT&varfrom=",Vfrom,"&varto=",Vto,"&start_time=",START,"&end_time=",END,"&data_type=mean&interval=hour&multiplier=1&format=csv")
  WMIP_URL <- gsub(" ", "", WMIP_URL, fixed = TRUE)

  WMIPData <- readr::read_csv(url(WMIP_URL))

  WMIPData$time <- as.POSIXct(sprintf("%1.0f", WMIPData$time), format="%Y%m%d%H%M%S", origin = "1970-01-01")
  return(WMIPData)
}

