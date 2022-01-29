# GWELLS-QAQC_Geocode_ArchiveData
relates to GWELLS-QAQC-RShiny-Dashboard Github repo (https://github.com/bcgov/GWELLS-QAQC-RShiny-Dashboard)

The purpose of the code in [this repo](https://github.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData) is to maintain 3 files derived from the the [gwells.csv]("https://s3.ca-central-1.amazonaws.com/gwells-export/export/v2/gwells.zip") file provided by the Government of British-Columbia.   

Three CSVs appear in the `data/` folder.  They are all updated on a daily basis:  

* [`wells.csv`](https://github.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/blob/main/data/gwells.csv)
* [`wells_geocoded.csv`](https://github.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/blob/main/data/wells_geocoded.csv)
* [`wells_qa.csv`](https://github.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/blob/main/data/wells_qa.csv)

`wells.csv` is an identical copy of the `gwells.csv` with an additional column: `date_added`.  This column represents the first date a well was spotted by this script.

* `wells_geocoded.csv` is the result of passing the `wells.csv` through the `python gwells_locationqa geocode` python script from the [bcgov/GWELLS_LocationQA repo](https://github.com/bcgov/GWELLS_LocationQA).

* `wells_qa.csv` is the result of passing  `wells.csv` and `wells_geocoded.csv` through the `python gwells_locationqa qa`  python script from the [bcgov/GWELLS_LocationQA repo](https://github.com/bcgov/GWELLS_LocationQA).

The daily updates occur daily thanks to scheduled github actions at depends on the [Docker Image created specifically for this project](https://github.com/bcgov/GWELLS-QAQC_Docker).  The image was tailored to include all the R, Python and spatial dependencies required to run the [Python scripts created by Simon Norris](https://github.com/bcgov/GWELLS_LocationQA) and build on the `rocker/geospatial:4.1.2` docker image. 

The three CSVs will then be used to feed the shiny app ([code](https://github.com/bcgov/GWELLS-QAQC-RShiny-Dashboard)) created for [this Code With Us project](https://digital.gov.bc.ca/marketplace/opportunities/code-with-us/3f77de24-a121-4143-a028-8d2f04067ba5). 

Here is a diagram of the whole process:  

![](https://github.com/bcgov/GWELLS-QAQC-RShiny-Dashboard/blob/main/inst/app/www/images/gwells.drawio2.png)



# Why CSV and not SQL?  

We recognize that it  would have been better practice to save this data in an SQL table instead of a CSV inside a github repo.  We built the code for this purpose, which is why most files in this repository exist in two copies: one with a "_csv" suffix and another with the "_sql" suffix.  Due to cost issue, it was decided to use the CSV approach.  The _sql code was kept in this repo in case this approach is retained in the future.  

# Credits / Blame   
This repo was originally created by Simon Coulombe during a "Code With Us" opportunity in January 2022.
