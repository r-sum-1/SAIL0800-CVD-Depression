library(readxl) # for loading excel file
library(xlsx)

library(rstudioapi) # for relocating directory
library(dplyr)
library(stringr)

#locate file and set wd
setwd(dirname(getActiveDocumentContext()$path))

name_of_file <- "read_codes_final.xlsx"


my_excelSheets <- excel_sheets(name_of_file)

#Are there any sheets that you want removed?
#my_excelSheets <- my_excelSheets[my_excelSheets != "haem_stroke"]

df_out <- data.frame()

#loop through and append to one dataframe
#specifically want these columns to prevent some breakage when stacking
for (sheet in my_excelSheets){
  print(sheet)
  df_subset <- read_excel(name_of_file, sheet=sheet, col_names=TRUE, col_types = "text" )
  df_subset <- as.data.frame(df_subset)
  df_subset <- df_subset[,c("pre-2010", "Study Period (2010-2019)","READ_CODE", "PREF_TERM_30", "PREF_TERM_60", "PREF_TERM_198",	"ICD9_CODE",	
                            "ICD9_CODE_DEF",	"ICD9_CM_CODE",	"ICD9_CM_CODE_DEF",	"OPCS_4_2_CODE",	
                            "OPCS_4_2_CODE_DEF",	"SPECIALTY_FLAG",	"STATUS_FLAG",	"LANGUAGE_CODE",
                            "SOURCE_FILE_NAME",	"IN_SOURCE_DATA",	"IMPORT_DATE",	"CREATED_DATE",	"IS_LATEST",
                            "EFFECTIVE_FROM",	"EFFECTIVE_TO",	"AVAIL_FROM_DT",	"READ_TYPE")]
  

  df_out <- rbind(df_out, df_subset)
}

#do some tidying before saving... remove blank rows or rows with NA

df_cleaned <- df_out[!apply(is.na(df_out) | df_out == "", 1, all),]


# ======================== Create Workbook ========================

#Look at stacked df... Genearte a list of unique READ_TYPE...
# Loop through READ_TYPES and use it to subset the df and assign to an excel file.

wb = createWorkbook()

code_types <- unique(df_cleaned$READ_TYPE)

#remove NA Read Types
code_types <- code_types[!is.na(code_types)]

#loop through each of the READ TYPES
for (code in code_types){
  df_subset <- df_cleaned[df_cleaned$READ_TYPE == code,]
  print(code)
  sheet = createSheet(wb, code)
  addDataFrame(df_subset, sheet=sheet, row.names = FALSE)
}

# ======================== SAVING  ========================
# Generate New File name using sys time
# Rename the old file (with the date)...
# save df as the "new file name"...
# NB newest filename will always be '_final...'

s_time <- format(Sys.time(), "%Y-%m-%d-%H%M")
new_filename <- paste0(str_remove(name_of_file, ".xlsx"), "_",  s_time,".xlsx")
file.rename(name_of_file, new_filename)

saveWorkbook(wb, "read_codes_final.xlsx")
