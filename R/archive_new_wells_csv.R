library(dplyr)
library(readr)
library(janitor)
library(DBI)
library(RPostgres)
source("R/col_types_wells.R")

# this script has the type of all columns in the wells.csv
source("R/col_types_wells.R")

update_csv <- TRUE

# actually we arent going to use the python download script here because we need to read the other csvs in the zip file.
url <- "https://s3.ca-central-1.amazonaws.com/gwells-export/export/v2/gwells.zip"
temp_zip <- tempfile()
download.file(url, destfile = temp_zip)
temp_dir <- tempdir()
utils::unzip(temp_zip,exdir = temp_dir) #  files =  "well.csv", 

newest_wells_file <- read_csv(
  paste0(temp_dir, "/well.csv"), col_types = col_types_wells # from R/coltypes_we
) 

newest_drilling_method <-  read_csv(
  paste0(temp_dir, "/drilling_method.csv")  ,
  col_types = cols(well_tag_number = col_double(), drilling_method_code = col_character())
) 



if(update_csv){
  wells_csv <-
    read_csv("https://raw.githubusercontent.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/main/data/wells.csv",
             col_types = col_types_wells_janitor
    ) 
  new_wells <- newest_wells_file %>%
    anti_join(wells_csv %>% select(well_tag_number)) %>%
    mutate(date_added = as.Date(Sys.time() , tz = "America/Vancouver")) %>%
    janitor::clean_names()
  
  if(nrow(new_wells)> 0){
    message("writing new csv with :", nrow(new_wells), " new rowsrows.", paste(new_wells$well_tag_number, collapse = " "))
    updated_wells_csv <- bind_rows(wells_csv, new_wells)
    
    write_csv(updated_wells_csv, "data/wells.csv")
  } else{message("No new wells to append.")}
  
  
  drilling_method_csv <-
    read_csv("https://raw.githubusercontent.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/main/data/drilling_method.csv"
    ) 
  
  
  new_drilling_method <- newest_drilling_method %>%
    anti_join(drilling_method_csv %>% select(well_tag_number)) %>% 
    mutate(date_added = as.Date(Sys.time() , tz = "America/Vancouver")) %>%
    janitor::clean_names()
  
  if(nrow(new_drilling_method)> 0){
    message("Appending  new_drilling_method:", nrow(new_drilling_method), " rows.", paste(new_drilling_method$well_tag_number, collapse = " "))
    updated_drilling_method_csv <- bind_rows(drilling_method_csv, new_drilling_method)
    
    write_csv(updated_drilling_method_csv, "data/drilling_method.csv")
    
  } else{message("No new drilling method to append.")}
  
}


