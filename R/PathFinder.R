#' @title Decision tree for Trios OPUS and NICO Path-length limits for N-NO3 and TSSeq
#'
#' @description This function, given a valid path-length and probe type will return a list of the relevant limit values for available parameters
#'
#' @source \url{https://www.trios.de/en/}
#'
#' @param ProbeType The type of probe (OPUS/NICO)
#' @param PathLength the path-length of interest for the relevant probe (2/5/10/20mm)
#'
#' @examples
#' #Limits <- PathFinder(ProbeType = "OPUS", PathLength = 5)
#' #Limits$NO3LowerLim
#'
#' @return List of the relevant limit values for given probe and pathlength
#'
#' @export

PathFinder <- function(ProbeType, PathLength){
  Limits <- list() #create a blank list
  if(ProbeType == "OPUS"){

  if (PathLength == 2) {
  Limits <- list(
  NO3LowerLim = 0.15,     # determination limit
  NO3UpperLim = 50,       # Max range
  TSSUpperLim = 650,
  TSSLowerLim = 20
  )
} else if(PathLength == 5) {
  Limits <- list(
  NO3LowerLim = 0.06,
  NO3UpperLim = 20,
  TSSUpperLim = 260,
  TSSLowerLim = 8
  )
} else if(PathLength == 10) {
  Limits <- list(
  NO3LowerLim = 0.03,
  NO3UpperLim = 10,
  TSSUpperLim = 130,
  TSSLowerLim = 4
  )
} else if(PathLength == 20) {
  Limits <- list(
  NO3LowerLim = 0.015,
  NO3UpperLim = 5,
  TSSUpperLim = 65,
  TSSLowerLim = 2
  )
} else {(print("DON'T FORGET TO CHECK YOUR PATHLENGTH"))}

  } else if(ProbeType == "NICO"){ #Decision tree for NICO Pathlength limits
    if (PathLength == 2) {
      Limits <- list(
      NO3LowerLim = 0.75,     # determination limit
      NO3UpperLim = 30       # Max range
      )
    } else if(PathLength == 5) {
      Limits <- list(
      NO3LowerLim = 0.3,
      NO3UpperLim = 12
      )
    } else if(PathLength == 10) {
      Limits <- list(
      NO3LowerLim = 0.15,
      NO3UpperLim = 6
      )
    } else {(print("DON'T FORGET TO CHECK YOUR PATHLENGTH"))}
}
return(Limits)}
