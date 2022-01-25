# GWELLS-QAQC_Geocode_ArchiveData
relates to GWELLS-QAQC-RShiny-Dashboard Github repo (https://github.com/bcgov/GWELLS-QAQC-RShiny-Dashboard)

The purpose of the code in [this repo](https://github.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData) is to maintain an archive of the [registered ground water wells data](https://apps.nrs.gov.bc.ca/gwells/) provided by the Government of British-Columbia in the `data/` folder.

Three CSVs appear in the `data/` folder.  They are all updated on a daily basis:  

* [`gwells_data_first_appearance.csv`](https://github.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/blob/main/data/gwells_data_first_appearance.csv)
* [`wells_geocoded.csv`](https://github.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/blob/main/data/gwells_locationqa.csv)
* [gwells_locationqa.csv](https://github.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/blob/main/data/wells_geocoded.csv)

`gwells_data_first_appearance.csv` keeps a record of each well *on the day they were added to the  `gwells` csv*.  We never update the information of a well, allowing us to go back in time and generate a record for any time period.  The wells are defined by their `well_tag_number`.  The columns are the same as for the gwells.csv, with the addition of the `date_added` column, which is the first date a `well_tag_number` was spotted by this script.

* `wells_geocoded.csv` is the result of passing the `gwells_data_first_appearance.csv` through the `python gwells_locationqa geocode` script.    

* `gwells_locationqa.csv` is the result of passing  `gwells_data_first_appearance.csv` and `wells_geocoded.csv` through the `python gwells_locationqa qa` script.   

The daily updates occur daily thanks to scheduled github actionthat depends on the [Docker Image created specifically for this project](https://github.com/bcgov/GWELLS-QAQC_Docker).  The image was tailored to include all the R, Python and spatial dependencies required to run the [Python scripts created by Simon Norris](https://github.com/bcgov/GWELLS_LocationQA) and build on the `rocker/geospatial:4.1.2` docker image. 

The three CSVs will then be used to feed the shiny app ([code](https://github.com/bcgov/GWELLS-QAQC-RShiny-Dashboard)) created for [this Code With Us project](https://digital.gov.bc.ca/marketplace/opportunities/code-with-us/3f77de24-a121-4143-a028-8d2f04067ba5). 
