#Extracting the city list file provided through the website:
R.utils::gunzip("data-raw/citylistjson.gz")
cityList <- jsonlite::fromJSON(txt = "data-raw/citylistjson", flatten=TRUE)
usethis::use_data(cityList)
