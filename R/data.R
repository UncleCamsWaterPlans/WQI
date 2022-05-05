#' List of available 'cities' with weather data through OpenWeather.org
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
#' Provides Node ID's for available discrete analytes
#' @format a data frame containing 134 obs. of  56 variables
#' \describe{
#'   \item{_id}{_id}
#'   \item{GSnum}{GSnum}
#'   \item{name}{name}
#'   \item{TextFileSource}{TextFileSource}
#'   \item{WQ ANALYSIS NO}{WQ ANALYSIS NO}
#'   \item{Site Name}{Site Name}
#'   \item{SITE NO}{SITE NO}
#'   \item{Atrazine}{Atrazine}
#'   \item{Ametryn}{Ametryn}
#'   \item{Ammonium nitrogen}{Ammonium nitrogen}
#'   \item{RT Level}{RT Level}
#'   \item{Bromacil}{Bromacil}
#'   \item{Chlorpyrifos}{Chlorpyrifos}
#'   \item{Conductivity}{Conductivity}
#'   \item{Diss Kjeldahl nitrogen}{Diss Kjeldahl nitrogen}
#'   \item{Diss Kjeldahl phosphor}{Diss Kjeldahl phosphor}
#'   \item{Diss organic nitrogen}{Diss organic nitrogen}
#'   \item{Diss organic phosphor}{Diss organic phosphor}
#'   \item{Diuron}{Diuron}
#'   \item{Filt react phosphorus}{Filt react phosphorus}
#'   \item{Fipronil}{Fipronil}
#'   \item{Fluometuron}{Fluometuron}
#'   \item{Fluroxypyr}{Fluroxypyr}
#'   \item{Glyphosate}{Glyphosate}
#'   \item{Haloxyfop acid}{Haloxyfop acid}
#'   \item{Hexazinone}{Hexazinone}
#'   \item{Imazapic}{Imazapic}
#'   \item{Imidacloprid}{Imidacloprid}
#'   \item{Isoxaflutole}{Isoxaflutole}
#'   \item{MCPA}{MCPA}
#'   \item{Metolachlor}{Metolachlor}
#'   \item{Metribuzin}{Metribuzin}
#'   \item{Metsulfuron-methyl}{Metsulfuron-methyl}
#'   \item{Oxidised nitrogen}{Oxidised nitrogen}
#'   \item{Particulate Nitrogen}{Particulate Nitrogen}
#'   \item{Particulate phosphorus}{Particulate phosphorus}
#'   \item{Pendimethalin}{Pendimethalin}
#'   \item{Prometryn}{Prometryn}
#'   \item{Simazine}{Simazine}
#'   \item{Tebuthiuron}{Tebuthiuron}
#'   \item{Terbuthylazine}{Terbuthylazine}
#'   \item{Terbutryn}{Terbutryn}
#'   \item{Total organic carbon}{Total organic carbon}
#'   \item{Triclopyr}{Triclopyr}
#'   \item{TSS}{TSS}
#'   \item{Ttl Kjeldahl nitrogen}{Ttl Kjeldahl nitrogen}
#'   \item{Ttl nitrogen}{Ttl nitrogen}
#'   \item{Ttl phosphorus}{Ttl phosphorus}
#'   \item{Turbidity}{Turbidity}
#'   \item{Chlorothalonil}{Chlorothalonil}
#'   \item{Diazinon}{Diazinon}
#'   \item{Propiconazole}{Propiconazole}
#'   \item{RT TSSeq}{RT TSSeq}
#'   \item{RT Conductivity}{RT Conductivity}
#'   \item{RT Turbidity}{RT Turbidity}
#'   \item{WQI Site Name}{WQI Site Name}
#' }
#' @source \url{https://wqi.eagle.io/}
"labRef"


#' Reference table for all of WQI's location sources with Logger data
#' Provides Node ID's for available real time parameters
#' @format a data frame containing 134 obs. of  56 variables
#' \describe{
#'   \item{_id}{_id}
#'   \item{GSnum}{GSnum}
#'   \item{name}{name}
#'   \item{loggerID}{loggerID}
#'   \item{Main - Level}{Main - Level}
#'   \item{OPUSResults - OPUS1000 N NO3}{OPUSResults - OPUS1000 N NO3}
#'   \item{OPUSResults - OPUS1036 Abs210}{OPUSResults - OPUS1036 Abs210}
#'   \item{Nitrate - NICO RefA}{Nitrate - NICO RefA}
#'   \item{OPUSResults - OPUS1042 Abs254}{OPUSResults - OPUS1042 Abs254}
#'   \item{Nitrate - NICO RefB}{Nitrate - NICO RefB}
#'   \item{OPUSResults - OPUS1034 Abs360}{OPUSResults - OPUS1034 Abs360}
#'   \item{Nitrate - NICO RefC}{Nitrate - NICO RefC}
#'   \item{Nitrate - NICO RefD}{Nitrate - NICO RefD}
#'   \item{OPUSResults - OPUS1060 SQI}{OPUSResults - OPUS1060 SQI}
#'   \item{OPUSResults - OPUS1016 TSSeq}{OPUSResults - OPUS1016 TSSeq}
#'   \item{Public - RSSI}{Public - RSSI}
#'   \item{Resets - WDE}{Resets - WDE}
#'   \item{Public - OPUS Serial}{Public - OPUS Serial}
#'   \item{Public - SondePresent}{Public - SondePresent}
#'   \item{Public - NitratePresent}{Public - NitratePresent}
#'   \item{Public - ADCPPresent}{Public - ADCPPresent}
#'   \item{Main - LoggerBattV Min}{Main - LoggerBattV Min}
#'   \item{Main - PestFrV Min}{Main - PestFrV Min}
#'   \item{Main - PumpBattV Min}{Main - PumpBattV Min}
#'   \item{Public - SamplerOnOff}{Public - SamplerOnOff}
#'   \item{Public - SamplerState}{Public - SamplerState}
#'   \item{FridgeStatus - NFridgeStatus}{FridgeStatus - NFridgeStatus}
#'   \item{FridgeStatus - PFridgeStatus}{FridgeStatus - PFridgeStatus}
#'   \item{Public - SampleNo}{Public - SampleNo}
#'   \item{Sonde - SondeTemp}{Sonde - SondeTemp}
#'   \item{Sonde - Conductivity}{Sonde - Conductivity}
#'   \item{Sonde - Turbidity}{Sonde - Turbidity}
#'   \item{Sonde - DO-mgL}{Sonde - DO-mgL}
#'   \item{Sonde - fDOM-QSU}{Sonde - fDOM-QSU}
#' }
#' @source \url{https://wqi.eagle.io/}
"loggerRef"

#' Reference table for all of WQI's Reportable Parameter sources with RT data
#' Provides Node ID's for available filtered RTD parameters.
#' @format a data frame containing 134 obs. of  56 variables
#' \describe{
#'   \item{_id}{_id}
#'   \item{GSnum}{GSnum}
#'   \item{name}{name}
#'   \item{ReportableParameter}{ReportableParameter}
#'   \item{Turbidity}{Turbidity}
#'   \item{Level}{Level}
#'   \item{N-NO3}{N-NO3}
#'   \item{SondeTemp}{SondeTemp}
#'   \item{Discharge}{Discharge}
#'   \item{Conductivity}{Conductivity}
#'   \item{TSSeq}{TSSeq}
#'   \item{Samples}{Samples}
#'   }
"reportableParamRef"
