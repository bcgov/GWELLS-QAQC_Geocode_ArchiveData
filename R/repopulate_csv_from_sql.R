library(dplyr)
library(readr)
library(janitor)
library(DBI)
library(RPostgres)
source("R/col_types_wells.R")

con1 <- DBI::dbConnect(
  #RPostgreSQL::PostgreSQL(),
  RPostgres::Postgres(),
  dbname = Sys.getenv("BCGOV_DB"),
  host = Sys.getenv("BCGOV_HOST"),
  user = Sys.getenv("BCGOV_USR"),
  password=Sys.getenv("BCGOV_PWD")
)

wells <- dbGetQuery(con1, "select * from wells") 
wells_geocoded <- dbGetQuery(con1, "select * from wells_geocoded") 
wells_qa <- dbGetQuery(con1, "select * from wells_qa") 
drilling_method <- dbGetQuery(con1, "select * from drilling_method") 

DBI::dbDisconnect(con1)


wells2 <- wells %>% head(-10)
wells_geocoded2 <- wells_geocoded %>% inner_join(wells %>% select(well_tag_number))
wells_qa2 <- wells_qa %>% inner_join(wells %>% select(well_tag_number))
drilling_method2 <- drilling_method  %>% inner_join(wells %>% select(well_tag_number))
 
write_csv(wells2, "data/wells.csv")
write_csv(wells_geocoded2, "data/wells_geocoded.csv")
write_csv(wells_qa2, "data/wells_qa.csv")
write_csv(drilling_method2, "data/drilling_method.csv")
