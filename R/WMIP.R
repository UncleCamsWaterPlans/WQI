#' Extracts data from the Water Monitoring Information Portal (WMIP)
#' Website: https://water-monitoring.information.qld.gov.au/

#' @param WMIPID == a Gauging station number
#' @param Vfrom == refers to parameter codes (100.00 = level)
#' @param Vto == allows you to leverage the platform to convert level to discharge (ie. Vfrom = 100.00 level , Vto = 140.00 devtoolsdischarge)
#' @param START == date* to lookback to. format = YYYYMMDD
#'
#' @return a data frame containing extracted WMIP data for specified gauging station/parameter.

#' @export
WMIP_Extract <- function(WMIPID, Vfrom, Vto, START){
  END <- format(Sys.Date() + 1, "%Y%m%d")
  WMIP_URL <- paste("https://water-monitoring.information.qld.gov.au/cgi/webservice.pl?function=get_ts_traces&site_list=",WMIPID,"&datasource=AT&varfrom=",Vfrom,"&varto=",Vto,"&start_time=",START,"&end_time=",END,"&data_type=mean&interval=hour&multiplier=1&format=csv")
  WMIP_URL <- gsub(" ", "", WMIP_URL, fixed = TRUE)

  WMIPData <- readr::read_csv(url(WMIP_URL))

  WMIPData$time <- as.POSIXct(sprintf("%1.0f", WMIPData$time), format="%Y%m%d%H%M%S", origin = "1970-01-01")
  return(WMIPData)
}


#example::  df_test <- WMIP_Extract("112004A", Vfrom = "100.00", Vto = "100.00", START = "20211201")
