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

write_csv(wells %>% head(-10), "data/wells.csv")g
write_csv(wells_geocoded %>% head(-10), "data/wells_geocoded.csv")
write_csv(wells_qa %>% head(-10), "data/wells_qa.csv")
write_csv(drilling_method %>% head(-10), "data/drilling_method.csv")
