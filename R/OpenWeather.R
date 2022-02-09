#' @title Access to the OpenWeather API data (Free Tier)

#' @description
#' example API :: https://api.openweathermap.org/data/2.5/onecall/timemachine?lat={lat}&lon={lon}&dt={time}&appid={API key}
#'
#' \itemize{
#'   \item hourly Hourly forecast weather data API response
#'   \item hourly.dt Time of the forecasted data, Unix, UTC
#'   \item hourly.temp Temperature. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit. How to change units used
#'   \item hourly.feels_like Temperature. This accounts for the human perception of weather. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit.
#'   \item hourly.pressure Atmospheric pressure on the sea level, hPa
#'   \item hourly.humidity Humidity, %
#'   \item hourly.dew_point Atmospheric temperature (varying according to pressure and humidity) below which water droplets begin to condense and dew can form. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit.
#'   \item hourly.uvi UV index
#'   \item hourly.clouds Cloudiness, %
#'   \item hourly.visibility Average visibility, metres
#'   \item hourly.wind_speed Wind speed. Units – default: metre/sec, metric: metre/sec, imperial: miles/hour.How to change units used
#'   \item hourly.wind_gust (where available) Wind gust. Units – default: metre/sec, metric: metre/sec, imperial: miles/hour. How to change units used
#'   \item hourly.wind_deg Wind direction, degrees (meteorological)
#'   \item hourly.pop Probability of precipitation
#'   \item hourly.rain
#'   \item hourly.rain.1h (where available) Rain volume for last hour, mm
#'   \item hourly.snow
#'   \item hourly.snow.1h (where available) Snow volume for last hour, mm
#'   \item hourly.weather
#'   \item hourly.weather.id Weather condition id
#'   \item hourly.weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
#'   \item hourly.weather.description Weather condition within the group (full list of weather conditions). Get the output in your language
#'   \item hourly.weather.icon Weather icon id. How to get icons
#' }
#'
#' @source url{https://openweathermap.org/}

#' @param City == the City as displayed in the cityList file extracted from the website
#' @param APIKEY == given from the free tier account for OpenWeather
#' @param time == UNIX time for a given day. Free tier only supports the last 5 days
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#'
#' @examples
#' #dat <- OpenWeather(City = "Ayr", time = (as.integer(Sys.time())), APIKEY = "XYZ")
#'
#' @return data frame containing weather observation data from given city. Time as "Australia/Brisbane" (UTC+10)
#'
#' @export

OpenWeather <- function(City, time, APIKEY){
cityList <- cityList
lat <- as.numeric(cityList %>%
                    dplyr::filter(.data$name == City & .data$country == "AU") %>%
                    dplyr::select(.data$coord.lat))

lon <- as.numeric(cityList %>%
                    dplyr::filter(.data$name == City & .data$country == "AU") %>%
                    dplyr::select(.data$coord.lon))

URL <- paste("https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=",lat,"&lon=",lon,"&dt=",time,"&appid=",APIKEY, sep = "")
API <- httr::GET(URL)

content = jsonlite::fromJSON(rawToChar(API$content))
content = content[["hourly"]]
content$dt <- as.POSIXct(content$dt, origin = "1970-01-01", tz = "Australia/Brisbane")
return(content)
}

