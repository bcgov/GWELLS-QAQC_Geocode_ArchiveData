library(dplyr)
library(readr)
library(janitor)

source("R/col_types_wells.R")



old_qa <- read_csv("https://raw.githubusercontent.com/bcgov/GWELLS-QAQC_Geocode_ArchiveData/main/data/wells_qa.csv",
                   col_types = col_types_qa_janitor
)
message("printing out QA")
glimpse(old_qa)


if(file.exists("gwells_locationqa.csv")){
  
  newly_qa <- read_csv("gwells_locationqa.csv", col_types = col_types_qa) %>%
    select(-one_of(c("Unnamed: 0", "date_added"))) %>% 
    mutate(date_qa = as.Date(Sys.time() , tz = "America/Vancouver")) %>%
    janitor::clean_names() 
  
  if(nrow(newly_qa)> 0){
    
    message("printing new qa")
    glimpse(newly_qa)
    message("Appending newly qa  wells:", nrow(newly_qa), " rows. well_tag_number=", paste(newly_qa$well_tag_number, collase = " "))
    updated_qa <- bind_rows(old_qa, newly_qa)
    write_csv(updated_qa,"data/wells_qa.csv")
  }
  else{
    message("new qa file exists, but is empty. This shouldnt happen.")
    write_csv(old_qa,"data/wells_qa.csv")
  }
} else { 
  message("new qa file does not exist. This typically happens when there are no new wells.")
  write_csv(old_qa,"data/wells_qa.csv")
  
  }




