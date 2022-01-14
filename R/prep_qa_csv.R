library(dplyr)
library(readr)
library(janitor)

update_csv <- TRUE   # do we update the data in the CSV in the repo?


source("R/col_types_wells.R")

if(update_csv){
  
  max_number_geocoded <- 1000 # this is the maximum number of wells we are willing to geocode today
  source("R/col_types_wells.R")
  
  
  wells_csv <-
    read_csv("https://raw.githubusercontent.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/main/data/wells.csv",
             col_types = col_types_wells_janitor
    )
  
  geocoded_csv <- read_csv("https://raw.githubusercontent.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/main/data/wells_geocoded.csv",
                                 col_types = col_types_geocoded_janitor
  )
  
  qa_csv <- read_csv("https://raw.githubusercontent.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/main/data/wells_qa.csv",
                     col_types = col_types_qa_janitor
  )
  
  # this is the list of wells that need to be QAed today  (in wells and geocoded, but not in QA)
  well_tag_number_that_need_QA <- (wells_csv %>% select(well_tag_number)) %>%
    inner_join( (geocoded_csv %>% select(well_tag_number))) %>%
    anti_join(qa_csv %>% select(well_tag_number) )  %>% 
    pull(well_tag_number)
  
  if(length(well_tag_number_that_need_QA)>0){
    message(length(well_tag_number_that_need_QA), " records need QA. ", paste(well_tag_number_that_need_QA, collapse = " "))
  } else {
    message("no record need QA")
  }
  
  # we need to create an empty wells.csv and wells_geocoded.csv for the next step that will call the python script anyway.
  wells_for_csv <- wells_csv %>% 
    filter(well_tag_number %in% well_tag_number_that_need_QA) %>%
    rename(latitude_Decdeg = latitude_decdeg, 
           longitude_Decdeg = longitude_decdeg
    )
  
  write.csv(
    wells_for_csv, "data/wells.csv") # overwrite wells_geocoded.csv and wells.csv to allow script to run..
  
  wells_geocoded_for_csv <- geocoded_csv %>% 
    filter(well_tag_number %in% well_tag_number_that_need_QA)     %>%
    rename(fullAddress = full_address,
           civicNumber = civic_number,
           civicNumberSuffix = civic_number_suffix,
           streetName = street_name,
           streetType = street_type, 
           isStreetTypePrefix = is_street_type_prefix,
           streetDirection = street_direction,
           isStreetDirectionPrefix = is_street_direction_prefix,
           streetQualifier = street_qualifier,
           localityName = locality_name
    )
  write.csv(wells_geocoded_for_csv, "data/wells_geocoded.csv")
}
