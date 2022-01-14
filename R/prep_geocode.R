library(dplyr)
library(readr)
library(janitor)
library(RPostgres)
source("R/col_types_wells.R")

update_sql <- FALSE  # do we update the data on the SQL database?
update_csv <- TRUE   # do we update the data in the CSV in the repo?

if(update_sql){
  con1 <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("BCGOV_DB"),
    host = Sys.getenv("BCGOV_HOST"),
    user = Sys.getenv("BCGOV_USR"),
    password=Sys.getenv("BCGOV_PWD")
  )
  
  max_number_geocoded <- 1000 # this is the maximum number of wells we are willing to geocode today
  source("R/col_types_wells.R")
  
  
  # read the historical caracteristics
  #gwells_data_first_appearance <- read_csv("data/gwells_data_first_appearance.csv", col_types = col_types_wells)
  wells_in_db <- dbGetQuery(con1, "select well_tag_number, latitude_decdeg, longitude_decdeg  from wells") 
  
  
  # read the list of wells that have already been geocoded  
  #geocoded <- read_csv("github_data/wells_geocoded.csv", col_types = col_types_geocoded)
  wells_geocoded_in_db <- dbGetQuery(con1, "select well_tag_number from wells_geocoded") 
  
  
  # this is the list of wells that need geocoding
  to_geocode <- wells_in_db %>%
    anti_join(wells_geocoded_in_db) %>%
    filter(!is.na(latitude_decdeg), !is.na(longitude_decdeg)) %>% 
    tail(max_number_geocoded)
  
  
  message(paste0(Sys.time() , "created to_geocode"))
  
  
  # since the geocode python script reads data/wells.csv, we overwrite the 
  # wells.csv file with the data we want to geocode.
  write.csv(to_geocode %>%
              rename(latitude_Decdeg = latitude_decdeg, 
                     longitude_Decdeg = longitude_decdeg
              )
            , "data/wells.csv")
  
  if(nrow(to_geocode)>0){
    message("Geocoding ", nrow(to_geocode)," rows. well_tag_number= ", paste(to_geocode$well_tag_number, collapse = " "))
  } else {message("no new wells to geocode")}
  
}



if(update_csv){
    max_number_geocoded <- 1000 # this is the maximum number of wells we are willing to geocode today
    source("R/col_types_wells.R")
    
    
    wells_csv <-
      read_csv("https://raw.githubusercontent.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/main/data/wells.csv",
               col_types = col_types_wells_janitor
      )
    
    geocoded_csv <-       read_csv("https://raw.githubusercontent.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/main/data/wells_geocoded.csv",
                                   col_types = col_types_geocoded_janitor
    )
    
    
    # read the historical caracteristics
    #gwells_data_first_appearance <- read_csv("data/gwells_data_first_appearance.csv", col_types = col_types_wells)
    wells_in_db <- wells_csv %>% select(well_tag_number, latitude_decdeg, longitude_decdeg)
    
    
    # read the list of wells that have already been geocoded  
    #geocoded <- read_csv("github_data/wells_geocoded.csv", col_types = col_types_geocoded)
    wells_geocoded_in_db <- geocoded_csv %>% 
      select(well_tag_number)
    
    
    # this is the list of wells that need geocoding
    to_geocode <- wells_in_db %>%
      anti_join(wells_geocoded_in_db %>% head(-10)) %>%
      filter(!is.na(latitude_decdeg), !is.na(longitude_decdeg)) %>% 
      tail(max_number_geocoded)
    
    
    message(paste0(Sys.time() , "created to_geocode"))
    
    
    # since the geocode python script reads data/wells.csv, we overwrite the 
    # wells.csv file with the data we want to geocode.
    write.csv(to_geocode %>%
                rename(latitude_Decdeg = latitude_decdeg, 
                       longitude_Decdeg = longitude_decdeg
                )
              , "data/wells.csv")
    
    if(nrow(to_geocode)>0){
      message("Geocoding ", nrow(to_geocode)," rows. well_tag_number= ", paste(to_geocode$well_tag_number, collapse = " "))
    } else {message("no new wells to geocode")}
    
  
  
}