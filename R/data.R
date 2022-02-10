#' List of available 'cities' with weather data through OpenWeather.org
#'
#' @format a data frame containing 209579 obs. of  6 variables
#' \describe{
#'   \item{id}{unique identifier}
#'   \item{name}{location name}
#'   \item{state}{location state code}
#'   \item{country}{location country code}
#'   \item{coord.lon}{longitude}
#'   \item{coord.lat}{latitude}
#' }
#' @source \url{http://bulk.openweathermap.org/sample/city.list.json.gz}
"cityList"


#' Reference table for all of WQI's location sources with LAB data
#'
#' Provides Node ID's for available discrete analytes
#'
#' @format a data frame containing 134 obs. of  56 variables
#' \describe{
#'  \item{_id}
#'  \item{GSnum}
#'  \item{name}
#'  \item{TextFileSource}
#'  \item{WQ ANALYSIS NO}
#'  \item{Site Name}
#'  \item{SITE NO}
#'  \item{Atrazine}
#'  \item{Ametryn}
#'  \item{Ammonium nitrogen}
#'  \item{RT Level}
#'  \item{Bromacil}
#'  \item{Chlorpyrifos}
#'  \item{Conductivity}
#'  \item{Diss Kjeldahl nitrogen}
#'  \item{Diss Kjeldahl phosphor}
#'  \item{Diss organic nitrogen}
#'  \item{Diss organic phosphor}
#'  \item{Diuron}
#'  \item{Filt react phosphorus}
#'  \item{Fipronil}
#'  \item{Fluometuron}
#'  \item{Fluroxypyr}
#'  \item{Glyphosate}
#'  \item{Haloxyfop acid}
#'  \item{Hexazinone}
#'  \item{Imazapic}
#'  \item{Imidacloprid}
#'  \item{Isoxaflutole}
#'  \item{MCPA}
#'  \item{Metolachlor}
#'  \item{Metribuzin}
#'  \item{Metsulfuron-methyl}
#'  \item{Oxidised nitrogen}
#'  \item{Particulate Nitrogen}
#'  \item{Particulate phosphorus}
#'  \item{Pendimethalin}
#'  \item{Prometryn}
#'  \item{Simazine}
#'  \item{Tebuthiuron}
#'  \item{Terbuthylazine}
#'  \item{Terbutryn}
#'  \item{Total organic carbon}
#'  \item{Triclopyr}
#'  \item{TSS}
#'  \item{Ttl Kjeldahl nitrogen}
#'  \item{Ttl nitrogen}
#'  \item{Ttl phosphorus}
#'  \item{Turbidity}
#'  \item{Chlorothalonil}
#'  \item{Diazinon}
#'  \item{Propiconazole}
#'  \item{RT TSSeq}
#'  \item{RT Conductivity}
#'  \item{RT Turbidity}
#'  \item{WQI Site Name}
#'
#' }
#' @source \url{https://wqi.eagle.io/}
"labRef"


#' Reference table for all of WQI's location sources with Logger data
#'
#' Provides Node ID's for available real time parameters
#'
#' @format a data frame containing 134 obs. of  56 variables
#' \describe{
#'   \item{_id}
#'   \item{GSnum}
#'   \item{name}
#'   \item{loggerID}
#'   \item{Main - Level}
#'   \item{OPUSResults - OPUS1000 N NO3}
#'   \item{OPUSResults - OPUS1036 Abs210}
#'   \item{Nitrate - NICO RefA}
#'   \item{OPUSResults - OPUS1042 Abs254}
#'   \item{Nitrate - NICO RefB}
#'   \item{OPUSResults - OPUS1034 Abs360}
#'   \item{Nitrate - NICO RefC}
#'   \item{Nitrate - NICO RefD}
#'   \item{OPUSResults - OPUS1060 SQI}
#'   \item{OPUSResults - OPUS1016 TSSeq}
#'   \item{Public - RSSI}
#'   \item{Resets - WDE}
#'   \item{Public - OPUS Serial}
#'   \item{Public - SondePresent}
#'   \item{Public - NitratePresent}
#'   \item{Public - ADCPPresent}
#'   \item{Main - LoggerBattV Min}
#'   \item{Main - PestFrV Min}
#'   \item{Main - PumpBattV Min}
#'   \item{Public - SamplerOnOff}
#'   \item{Public - SamplerState}
#'   \item{FridgeStatus - NFridgeStatus}
#'   \item{FridgeStatus - PFridgeStatus}
#'   \item{Public - SampleNo}
#'   \item{Sonde - SondeTemp}
#'   \item{Sonde - Conductivity}
#'   \item{Sonde - Turbidity}
#'   \item{Sonde - DO-mgL}
#'   \item{Sonde - fDOM-QSU}
#'
#' }
#' @source \url{https://wqi.eagle.io/}
"loggerRef"
