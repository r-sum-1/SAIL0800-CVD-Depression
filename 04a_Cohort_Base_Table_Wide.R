#load packages
library(RODBC)
library(rstudioapi) # for relocating directory
library(readxl) # for loading excel file
library(stringr)
library(xlsx)
library(dplyr)
library(lubridate) #to select datetime cols
library(data.table)
library(tidyr)

#locate file and set wd
setwd(dirname(getActiveDocumentContext()$path))

#login
source("misc/login_box.r");
login = getLogin(''); 


# The line below acually connects to the data  using your userid 
# login [1] and password login[2] etc
sql = odbcConnect('PR_SAIL',login[1],login[2]);
login <- ""

# =========================================== 
#import LSOA Table
lsoa <- read.csv("Rural_Urban_Classification_2011_LSOA_ENG_WALES.csv", header=TRUE)

lsoa <- lsoa[,c("LSOA11CD", "RUC11")]

#import with a  query... minimum dates
base_table <- sqlQuery(sql, "SELECT * FROM SAILW0800V.COHORT_ENTRY" )

gc()

cohort_summary <- sqlQuery(sql, "SELECT ALF_PE, READ_TYPE, min(EVENT_DT) AS DATE FROM SAILW0800V.COHORT_BASE_TABLE 
                      GROUP BY ALF_PE, READ_TYPE" )


gc()

cohort_history <- sqlQuery(sql, "SELECT ALF_PE, READ_TYPE, max(EVENT_DT) AS DATE FROM SAILW0800V.COHORT_BASE_TABLE_HISTORY
                      GROUP BY ALF_PE, READ_TYPE" )

gc()

read_codes <- sqlQuery(sql, "SELECT * FROM SAILW0800V.ALL_IMPORTED_CODES" )

# =========================================== 
#calculate age on entry...
#layers are -- time_length(difftime(as.Date(XXX), as.Date(XXX)), "years")
# then as.numeric
# then round that to 0 d.p.

base_table$AGE_AT_ENTRY <- round(as.numeric(time_length(difftime(as.Date(base_table$ENTER_COHORT), as.Date(base_table$WOB)), "years")), digits=0)

# =========================================== 
#remove spaces from names

cohort_history$READ_TYPE <- gsub(" ", "_", cohort_history$READ_TYPE)
cohort_summary$READ_TYPE <- gsub(" ", "_", cohort_summary$READ_TYPE)
read_codes$CODE_TYPE <- gsub(" ", "_", read_codes$CODE_TYPE)

#convert all to lower case
cohort_history$READ_TYPE <- tolower(cohort_history$READ_TYPE)
cohort_summary$READ_TYPE <- tolower(cohort_summary$READ_TYPE)
read_codes$CODE_TYPE <- tolower(read_codes$CODE_TYPE)


gc()

# =========================================== 
#set DT and dcast from long to wide
cohort_summary <- setDT(cohort_summary)
cohort_history <- setDT(cohort_history)

cohort_history <- data.frame(dcast(cohort_history, ALF_PE ~ READ_TYPE, value.var = "DATE"))

gc()

cohort_summary <- data.frame(dcast(cohort_summary, ALF_PE ~ READ_TYPE, value.var = "DATE"))

gc()


# =========================================== 
# Add prefix to distinguish history...
  # generate col list not containing ALF_PE
  # create an index to map
  # change names according to map
col_list <- names(cohort_history[, !names(cohort_history) %in% c("ALF_PE")])

i <- colnames(cohort_history) %in% col_list

colnames(cohort_history)[i] <- paste("hist", colnames(cohort_history)[i], sep="_")

# =========================================== 
#change to char from Date and replace with a Y
#select specific columns where not null and replace with 1
cohort_history <- cohort_history %>% mutate_if(is.Date, as.integer)

col_list <- names(cohort_history[, !names(cohort_history) %in% c("ALF_PE")])

cohort_history[,col_list][!is.na(cohort_history[,col_list])] <- 1


gc()
# =========================================== 
# #duplicate columns for silly reasons... FIX THIS 
# base_table_cleansed <- base_table_cleansed %>% mutate(across(all_of(c(71:140)), ~ ., .names = "{col}_bin"))
# 
# col_list <- names(base_table_cleansed[, !names(base_table_cleansed) %in% c("_bin")])
# 
# base_table_cleansed[,col_list] <- as.factor(base_table_cleansed[,col_list])
# 
# base_table_cleansed[,col_list][!is.na(base_table_cleansed[,col_list])] <- 1


# =========================================== 

# merge merge merge

base_table$RUC11 <- lsoa$RUC11[match(base_table$LSOA2011_CD, lsoa$LSOA11CD)]
          
base_table <- merge(base_table, cohort_history, by="ALF_PE", all.x = TRUE)

rm(cohort_history) # free up some memory

base_table <- merge(base_table, cohort_summary, by="ALF_PE", all.x = TRUE)

rm(cohort_summary) # free up some memory
gc()

# =========================================== 

# calculate the days from entry into cohort...
#  First, create a list of which to calculate...we don't want history columns... 
col_list <- names(base_table[, !names(base_table) %in% c("ALF_PE", "PERS_ID_PE", "GNDR_CD", "WOB", "ENOUGH_HIST", "EXIT_COHORT", "DOD", "AGE_18", "ENTER_COHORT", "DAYS_IN_COHORT", "ROW_NUM", "LSOA2011_CD", "AGE_AT_ENTRY", "RUC11")])
list_hist_cols <- colnames(base_table)[grepl("hist_", colnames(base_table))]
non_hist_cols <- setdiff(col_list, list_hist_cols)



#loop through and take each columns away from the enter-cohort..
for (i in non_hist_cols){
  base_table[i] <- base_table[i] - base_table["ENTER_COHORT"]
  gc() # clear unused memory
}


base_table <- base_table %>% mutate_if(is.difftime, as.integer)
gc()

# =========================================== 


### Next, what are we going to be excluding people on?

Codes_CVD_Drugs_pre_2010 <- read_codes  %>% filter(CODE_CAT == "CVD_Drug")  %>% filter(PRE_2010 == -1) %>% distinct(CODE_TYPE) %>% pull(CODE_TYPE)

Codes_CVD_Ass_pre_2010 <- read_codes  %>% filter(CODE_CAT == "CVD_Assessment")  %>% filter(PRE_2010 == -1) %>% distinct(CODE_TYPE) %>% pull(CODE_TYPE)

Codes_CVD_Diag_pre2010 <- read_codes  %>% filter(CODE_CAT == "CVD_ICD")  %>% filter(PRE_2010 == -1)  %>% distinct(CODE_TYPE) %>% pull(CODE_TYPE)

Codes_CVD_Read_pre2010 <- read_codes  %>% filter(CODE_CAT == "CVD_Read")  %>% filter(PRE_2010 == -1)  %>% distinct(CODE_TYPE) %>% pull(CODE_TYPE)

Codes_CVD_Proc_pre2010 <- read_codes  %>% filter(CODE_CAT == "CVD_Procedure")  %>% filter(PRE_2010 == -1)  %>% distinct(CODE_TYPE) %>% pull(CODE_TYPE)

Codes_MH_pre2010 <- read_codes  %>% filter(CODE_CAT == "MH_Read")  %>% filter(PRE_2010 == -1)  %>% distinct(CODE_TYPE) %>% pull(CODE_TYPE)

Codes_ALL_MH_pre2010 <- read_codes  %>% filter(CODE_CAT == "MH_Read")  %>% filter(PRE_2010 == -1)  %>% distinct(CODE_TYPE) %>% pull(CODE_TYPE)
Codes_ALL_CVD_pre2010 <- read_codes  %>% filter(CODE_CAT %in% c("CVD_Drug", "CVD_Assessment", "CVD_Read", "CVD_ICD", "CVD_Procedure"))  %>% filter(PRE_2010 == -1)  %>% distinct(CODE_TYPE) %>% pull(CODE_TYPE)


#add the hist_ prefix to all of the strings
Codes_ALL_MH_pre2010 <- paste0("hist_", Codes_ALL_MH_pre2010)
Codes_ALL_CVD_pre2010 <- paste0("hist_", Codes_ALL_CVD_pre2010)

# =========================================== 

# duplicate base_table and filter out athero CVD and depression
# firstly group so we have all athero CVD and SMH
# count number of preexisting conditions...
#two parts to this... apply(base_table[, names(base_table) %in% Codes_ALL_CVD_pre2010], 1, function(x) sum(!is.na(x)))
# -- Subset based on columns...  df <- base_table[, names(base_table) %in% Codes_ALL_CVD_pre2010]
# -- apply(df, 1, function(x) sum(!is.na(x)))

base_table$HistAthero_CVD <- apply(base_table[, names(base_table) %in% Codes_ALL_CVD_pre2010], 1, function(x) sum(!is.na(x)))
base_table$HistMH <- apply(base_table[, names(base_table) %in% Codes_ALL_MH_pre2010], 1, function(x) sum(!is.na(x)))
gc()
# =========================================== 

#what codes are we excluding? - tables of counts

count_hist_1 <- data.frame(colSums(!is.na(base_table[, names(base_table) %in% Codes_ALL_CVD_pre2010])))
count_hist_2 <- data.frame(colSums(!is.na(base_table[, names(base_table) %in% Codes_ALL_MH_pre2010])))

#firstly, create the the cleansed table
base_table_cleansed <- base_table %>% filter(HistAthero_CVD == 0, HistMH == 0)

a <- base_table %>% filter(HistAthero_CVD == 0, HistMH == 0) %>% summarise(count = n())
b <- base_table %>% filter(HistAthero_CVD == 0, HistMH > 0) %>% summarise(count = n())
c <- base_table %>% filter(HistAthero_CVD > 0, HistMH == 0) %>% summarise(count = n())
d <- base_table %>% filter(HistAthero_CVD > 0, HistMH > 0) %>% summarise(count = n())
e <- base_table %>% filter(HistAthero_CVD > 0 | HistMH > 0) %>% summarise(count = n())



total_count <- base_table %>% summarise(count = n())

# =========================================== 
#let's output to text file
sink("output1.txt")
print(count_hist_1)
cat("\n")
print(count_hist_2)
cat("\n")
cat("Total Cohort Size =  ", total_count$count[1])
cat("\n")
cat("Number of those without athero-CVD and hist MH =  ", a$count[1])
cat("\n")
cat("Number of those with no hist athero-CVD but with hist MH =  ", b$count[1])
cat("\n")
cat("Number of those with hist athero-CVD but no hist MH =  ", c$count[1])
cat("\n")
cat("Number of those with both hist athero-CVD and hist MH =  ", d$count[1])
cat("\n")
cat("Number excluded =  ", e$count[1])

sink()

gc()
# =========================================== 

library(psych)
options(scipen=100)
options(digits=3)
describe <- psych::describe(base_table_cleansed)

# =========================================== 

# Generate New File name using sys time
# Rename the old file (with the date)...
# save df as the "new file name"...
# NB newest filename will always be '_final...'

base_table_filename <- "base_table.csv"
base_table_cleansed_filename <- "base_table_cleansed.csv"


# =============================================
###### save cleansed and full df just in case
path <- "04_data/"

# ---------- save base table
if (file.exists(paste0(path, base_table_filename))){
  print("exists")
  s_time <- format(Sys.time(), "%Y-%m-%d-%H%M")
  new_filename <- paste0(str_remove(base_table_filename, ".csv"), "_",  s_time,".csv")
  file.rename(base_table_filename, new_filename)
  write.csv(base_table, base_table_filename)
  } else {
    print("not")
    write.csv(base_table, base_table_filename)
  }

# ---------- save base table cleansed
if (file.exists(paste0(path, base_table_cleansed_filename))){
  print("exists")
  s_time <- format(Sys.time(), "%Y-%m-%d-%H%M")
  new_filename <- paste0(str_remove(base_table_cleansed_filename, ".csv"), "_",  s_time,".csv")
  file.rename(base_table_cleansed_filename, new_filename)
  write.csv(base_table, base_table_cleansed_filename)
} else {
  print("not")
  write.csv(base_table, base_table_cleansed_filename)
}

# =============================================

# >>>>>  OPEN "04a_explore_BPLipid_Readings.R"  <<<<<

# =============================================


