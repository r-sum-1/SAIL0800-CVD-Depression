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


# ======================login ================= 
source("login_box.r");
login = getLogin(''); 

# The line below acually connects to the data  using your userid 
# login [1] and password login[2] etc
sql = odbcConnect('PR_SAIL',login[1],login[2]);
login <- ""

# ====================== Wrangle ================= 

name_of_file <- "CVD_procedures_codes_final.xlsx"

my_excelSheets <- excel_sheets(name_of_file)

# Any sheets to remove?
#my_excelSheets <- my_excelSheets[my_excelSheets != "haem_stroke"]


df_out = data.frame()
for (sheet in my_excelSheets){
  print(sheet)
  df_subset <- read_excel(name_of_file, sheet=sheet, col_names=TRUE, col_types = "text" )
  df_subset <- as.data.frame(df_subset)
  df_subset <- df_subset[,c("pre-2010",	"Study Period (2010-2019)",	"CODE_WITH_DECIMAL",	
                            "CODE_WITHOUT_DECIMAL",	"TITLE",	"OPCS_VERSION",	"IMPORT_DATE",	
                            "CREATED_DATE",	"EFFECTIVE_FROM",	"EFFECTIVE_TO",	"AVAIL_FROM_DT",	"OPCS_TYPE")]
  
  
  df_out <- rbind(df_out, df_subset)
}


#drop this column if necessary
#df_out$...1 <- NULL


# Doesn't like the date columns... change to strings... Worry about it in SAIL if necessary
#df_out$IMPORT_DATE <- as.character(df_out$IMPORT_DATE)
#df_out$CREATED_DATE <- as.character(df_out$CREATED_DATE)
#df_out$AVAIL_FROM_DT <- as.character(df_out$AVAIL_FROM_DT)
#df_out$EFFECTIVE_TO <- as.character(df_out$EFFECTIVE_TO)

#remove blank rows
df_cleaned <- df_out[!apply(is.na(df_out) | df_out == "", 1, all),]


#replace some values
df_cleaned[df_cleaned =="EXCLUDE"] <- -1
df_cleaned[df_cleaned =="IGNORE"] <- 0
df_cleaned[df_cleaned =="INCLUDE"] <- 1
df_cleaned[df_cleaned == "INCLUDE AS COVARIATE"] <- 2

#replace NAs in the 
df_cleaned$`pre-2010`[is.na(df_cleaned$`pre-2010`)] <- 0
df_cleaned$`Study Period (2010-2019)`[is.na(df_cleaned$`Study Period (2010-2019)`)] <- 0


#change column types to save some space
df_cleaned$`pre-2010` <- as.numeric(df_cleaned$`pre-2010`)
df_cleaned$`Study Period (2010-2019)` <- as.numeric(df_cleaned$`Study Period (2010-2019)`)


# check unique values in each column... make sure no spelling mistakes etc slipped through.
unique(df_cleaned$`pre-2010`)
unique(df_cleaned$`Study Period (2010-2019)`)
# ====================== Save ================= 
# Save the output table to SAIL using SQL
# If the table is already there, delete the table and save the new one.

tryCatch(
  expr = {
    print("Saving")
    sqlSave(sql, df_cleaned, "SAILW0800V.IMPORTED_CVD_PROCEDURECODES", rownames=FALSE)
    print("Saved")
  },
  
  #in the event of an error (that the table is present already)
  error = function(e){
    #print(e)
    print("Table Exists...Trying to Drop Table")
    sqlDrop(sql, "SAILW0800V.IMPORTED_CVD_PROCEDURECODES")
    print("Table Dropped")
    print("Resaving")
    sqlSave(sql,df_cleaned, "SAILW0800V.IMPORTED_CVD_PROCEDURECODES", rownames=FALSE)
    print("Saved")
  }
)





