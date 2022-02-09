#' Access to the OpenWeather API data (Free Tier)  --- https://openweathermap.org/

#' example API :: https://api.openweathermap.org/data/2.5/onecall/timemachine?lat={lat}&lon={lon}&dt={time}&appid={API key}

#' hourly Hourly forecast weather data API response
#' hourly.dt Time of the forecasted data, Unix, UTC
#' hourly.temp Temperature. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit. How to change units used
#' hourly.feels_like Temperature. This accounts for the human perception of weather. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit.
#' hourly.pressure Atmospheric pressure on the sea level, hPa
#' hourly.humidity Humidity, %
#' hourly.dew_point Atmospheric temperature (varying according to pressure and humidity) below which water droplets begin to condense and dew can form. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit.
#' hourly.uvi UV index
#' hourly.clouds Cloudiness, %
#' hourly.visibility Average visibility, metres
#' hourly.wind_speed Wind speed. Units – default: metre/sec, metric: metre/sec, imperial: miles/hour.How to change units used
#' hourly.wind_gust (where available) Wind gust. Units – default: metre/sec, metric: metre/sec, imperial: miles/hour. How to change units used
#' chourly.wind_deg Wind direction, degrees (meteorological)
#' hourly.pop Probability of precipitation
#' hourly.rain
#' hourly.rain.1h (where available) Rain volume for last hour, mm
#' hourly.snow
#' hourly.snow.1h (where available) Snow volume for last hour, mm
#' hourly.weather
#' hourly.weather.id Weather condition id
#' hourly.weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
#' hourly.weather.description Weather condition within the group (full list of weather conditions). Get the output in your language
#' hourly.weather.icon Weather icon id. How to get icons

#' @param City == the City as displayed in the cityList file extracted from the website
#' @param APIKEY == given from the free tier account for OpenWeather
#' @param time == UNIX time for a given day. Free tier only supports the last 5 days
#' importFrom magrittr "%>%"

#' @return data frame containing weather observation data from given city. Time as "Australia/Brisbane" (UTC+10)


#Extracting the city list file provided through the website:
# gunzip("Data/city.list.json.gz")
# cityList <- jsonlite::fromJSON(txt = "Data/city.list.json", flatten=TRUE)
# write.csv(cityList, file = "Data/cityList.csv")
#cityList <- read.csv("Data/cityList.csv")


#' @export

OpenWeather <- function(City, time, APIKEY){
lat <- as.numeric(cityList %>%
                    dplyr::filter(name == City & country == "AU") %>%
                    dplyr::select(coord.lat))

lon <- as.numeric(cityList %>%
                    dplyr::filter(name == City & country == "AU") %>%
                    dplyr::select(coord.lon))

URL <- paste("https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=",lat,"&lon=",lon,"&dt=",time,"&appid=",APIKEY, sep = "")
API <- httr::GET(URL)

content = jsonlite::fromJSON(rawToChar(API$content))
content = content[["hourly"]]
content$dt <- as.POSIXct(content$dt, origin = "1970-01-01", tz = "Australia/Brisbane")
return(content)
}



#example::
#OpenWeather(City = "Ayr", time = (as.integer(Sys.time())), APIKEY = "6ec4d71e6dff80bfd53c2ead82f20ef4")

