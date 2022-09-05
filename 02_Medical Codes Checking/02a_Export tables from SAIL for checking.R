#load packages
library(RODBC)
library(rstudioapi) # for relocating directory
library(readxl) # for loading excel file
library(stringr)
library(xlsx)
library(dplyr)
library(lubridate) #to select datetime cols

#locate file and set wd
setwd(dirname(getActiveDocumentContext()$path))

#login
source("login_box.r");
login = getLogin(''); 



# The line below acually connects to the data  using your userid 
# login [1] and password login[2] etc
sql = odbcConnect('PR_SAIL',login[1],login[2]);
login <- ""


## RUN THE QUERY TO RETURN THE TABLE AND SAVE AS EXCEL FILE.
df <- sqlQuery(sql, "SELECT * FROM SAILW0800V.CVD_DRUGS")

write.xlsx2(df, "CVD_drug_codes.xlsx", row.names = FALSE)
