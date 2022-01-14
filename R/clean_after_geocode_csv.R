library(dplyr)
library(readr)
library(janitor)
source("R/col_types_wells.R")

update_csv <- TRUE

if(update_csv){
  # this is the list of geocoded csv on the repo 
  geocoded_csv <-       read_csv("https://raw.githubusercontent.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/main/data/wells_geocoded.csv",
                                 col_types = col_types_geocoded_janitor
  )
  
  # this is the list of well we geocoded today
  newly_geocoded <- read_csv("data/wells_geocoded.csv", col_types = col_types_geocoded) %>% 
    mutate(date_geocoded = as.Date(Sys.time() , tz = "America/Vancouver")) %>%
    janitor::clean_names()
  
  if(nrow(newly_geocoded)> 0){
    message("printing newly geocoded")
    glimpse(newly_geocoded)
    message("Appending newly geocoded  wells:", nrow(newly_geocoded), " rows. well_tag_number=", paste(newly_geocoded$well_tag_number, collase = " "))
    updated_wells_geocoded <- bind_rows(geocoded_csv, newly_geocoded)
    write_csv(updated_wells_geocoded, "data/wells_geocoded.csv")
    
  } else{
    message("No new geocodedwells to append.")
    write_csv(geocoded_csv, "data/wells_geocoded.csv")
  }
  
  
  
  
  
  
}