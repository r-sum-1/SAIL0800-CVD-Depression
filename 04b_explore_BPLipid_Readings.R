
gc()

#Query only BP events... assign a measurement number
BP_events <- sqlQuery(sql, "SELECT DISTINCT *, ROW_NUMBER() OVER (PARTITION BY ALF_PE ORDER BY ALF_PE, EVENT_DT)  AS MEASUREMENT_NUMBER
                             FROM SAILW0800V.COHORT_BASE_TABLE
                            WHERE READ_TYPE = 'bp'
                            AND NOT EVENT_VAL IS NULL
                            ORDER BY ALF_PE, MEASUREMENT_NUMBER" )

gc()

# Take only first 3 measurements
BP_events <- BP_events %>% filter(MEASUREMENT_NUMBER < 4)


#sort out the BP values
BP_events$BP_sys <- as.integer(str_sub(BP_events$EVENT_VAL, 1,3))

BP_events$BP_dys <- as.integer(str_sub(BP_events$EVENT_VAL, -3, -1))

# filter only where systolic pressure > diastolic pressure and other silly values
BP_events <- BP_events %>% filter(BP_sys > BP_dys)

# now divide anything sys > 300 by 10
BP_events$BP_sys <- ifelse(BP_events$BP_sys > 300, BP_events$BP_sys/10, BP_events$BP_sys)

BP_events <- BP_events %>% filter(BP_sys > BP_dys)
BP_events <- BP_events %>% filter(BP_dys > 40)
BP_events <- BP_events %>% filter(BP_sys > 70)



# Add some classifications according to ESC
#BP_events$BP_read <- paste(BP_events$BP_sys, BP_events$BP_dys, sep="/")

BP_events <- BP_events %>% mutate(BP_class =  
                                 ifelse(BP_sys %in% 140:159 | BP_dys %in% 90:99, "Grade 1",
                                 ifelse(BP_sys %in% 150:179 | BP_dys %in% 95:119, "Grade 2",
                                 ifelse(BP_sys > 180 | BP_dys > 120, "Grade 3", "Normal"))))

gc()                       
# =============================================
#change to data table, cast long to wide

BP_events <- setDT(BP_events)
BP_events <- data.frame(dcast(BP_events, ALF_PE ~ MEASUREMENT_NUMBER, value.var = c("EVENT_DT", "BP_sys", "BP_dys", "BP_class")))



#rename columns
setnames(BP_events, old=c("EVENT_DT_1","EVENT_DT_2","EVENT_DT_3"), new=c("BP1_DT","BP2_DT","BP3_DT"))
 
# =============================================
#merge into base table

base_table_cleansed <- merge(base_table_cleansed, BP_events, by="ALF_PE", all.x = TRUE)


# =============================================
# loop through BP date columns and calculate date diff
colnames <- c("BP1_DT", "BP2_DT", "BP3_DT")

#loop through and take each columns away from the enter-cohort..
for (i in colnames){
  base_table_cleansed[i] <- base_table_cleansed[i] - base_table_cleansed["ENTER_COHORT"]
  gc() # clear unused memory
}


base_table_cleansed <- base_table_cleansed %>% mutate_if(is.difftime, as.integer)

gc()
# =============================================

# NOW FOR LIPIDS

lipid_events <- sqlQuery(sql, "SELECT *, ROW_NUMBER() OVER (PARTITION BY ALF_PE, READ_TYPE ORDER BY ALF_PE, EVENT_DT)  AS MEASUREMENT_NUMBER
                             FROM SAILW0800V.COHORT_BASE_TABLE
                            WHERE NOT EVENT_VAL IS NULL
                            AND (READ_TYPE = 'hdl' AND EVENT_VAL > 0.2)
                            OR (READ_TYPE = 'non_hdl')
                            OR (READ_TYPE = 'ldl' AND EVENT_VAL > 0.6)
                            OR (READ_TYPE = 'total_chol' AND EVENT_VAL >1)
                            OR (READ_TYPE = 'tc_hdl_ratio') 
                            ORDER BY ALF_PE, MEASUREMENT_NUMBER")


# =============================================
# Take only first 3 measurements
lipid_events <- lipid_events %>% filter(MEASUREMENT_NUMBER < 4)

#change to data table, cast long to wide
lipid_events <- setDT(lipid_events)

gc()

lipid_events <- data.frame(dcast(lipid_events, ALF_PE ~ READ_TYPE + MEASUREMENT_NUMBER, value.var = c("EVENT_VAL", "EVENT_DT")))

gc()

# =============================================
# merge

base_table_cleansed <- merge(base_table_cleansed, lipid_events, by="ALF_PE", all.x = TRUE)

# =============================================
# loop through and calculate #days from entry

colnames <- colnames(base_table_cleansed)[grepl("EVENT_DT", colnames(base_table_cleansed))]

#loop through and take each columns away from the enter-cohort..
for (i in colnames){
  base_table_cleansed[i] <- base_table_cleansed[i] - base_table_cleansed["ENTER_COHORT"]
  gc() # clear unused memory
}

base_table_cleansed <- base_table_cleansed %>% mutate_if(is.difftime, as.integer)


# =============================================

Qrisk_Events <- sqlQuery(sql, "SELECT DISTINCT *, ROW_NUMBER() OVER (PARTITION BY ALF_PE, READ_TYPE ORDER BY ALF_PE, EVENT_DT)  AS MEASUREMENT_NUMBER
                        FROM SAILW0800V.COHORT_BASE_TABLE     
                        WHERE (READ_TYPE = 'qrisk2_score' AND EVENT_VAL < 101)
                        OR (READ_TYPE = 'qrisk_score' AND EVENT_VAL < 101)")




# Take only first 3 measurements
Qrisk_Events <- Qrisk_Events %>% filter(MEASUREMENT_NUMBER < 4)


#change to data table, cast long to wide
Qrisk_Events <- setDT(Qrisk_Events)
Qrisk_Events <- data.frame(dcast(Qrisk_Events, ALF_PE ~ READ_TYPE + MEASUREMENT_NUMBER, value.var = c("EVENT_VAL", "EVENT_DT")))

# =============================================
# merge

base_table_cleansed <- merge(base_table_cleansed, Qrisk_Events, by="ALF_PE", all.x = TRUE)

# note the "q at the end of _DT_q"
colnames <- colnames(base_table_cleansed)[grepl("_DT_q", colnames(base_table_cleansed))]


#loop through and take each columns away from the enter-cohort..
for (i in colnames){
  base_table_cleansed[i] <- base_table_cleansed[i] - base_table_cleansed["ENTER_COHORT"]
  gc() # clear unused memory
}

base_table_cleansed <- base_table_cleansed %>% mutate_if(is.difftime, as.integer)


# =============================================

base_table_cleansed


#DT_FIRST_CVD
#DT_FIRST_DEPRESSION
#DT_FIRST_LIPID
#DT_FIRST_BP
#DT_FIRST_QRISK
#DT_FIRST_CVD_RISK_ASS





###### SAVE SAVE SAVE
path <- "04_data/"
base_table_filename <- "base_table_full.csv"
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




# =============================================


ethnicity_cds <- sqlQuery(sql, "SELECT ALF_PE, ETHN_EC_ONS_DATE_LATEST_DESC FROM SAILW0800V.ETHN_0800")


base_table_cleansed <- merge(base_table_cleansed, ethnicity_cds, by="ALF_PE", all.x = TRUE)


table(base_table_cleansed$ETHN_EC_ONS_DATE_LATEST_DESC)

# =============================================

library(haven)


write_sav(base_table_cleansed, "04_data/wide_table.sav")

# =============================================

# This is the point at which we can duplicate the table


base_table_cleansed_bin <- base_table_cleansed

gc()


col_list <- names(base_table_cleansed_bin[, !names(base_table_cleansed_bin) %in% c("ALF_PE", "PERS_ID_PE", "GNDR_CD", "WOB", "ENOUGH_HIST", "EXIT_COHORT", "DOD", "AGE_18", "ENTER_COHORT", "DAYS_IN_COHORT", "LSOA2011_CD", "AGE_AT_ENTRY", "RUC11", "ETHN_EC_ONS_DATE_LATEST_DESC")])

 

base_table_cleansed_bin[,col_list][!is.na(base_table_cleansed_bin[,col_list])] <- 1
base_table_cleansed_bin[,col_list][is.na(base_table_cleansed_bin[,col_list])] <- 0


names(base_table_cleansed_bin)


# =============================================
# =============================================
# =============================================
# BELOW IS OLD STUFF... IGNORE
# =============================================
# =============================================
# =============================================
# =============================================





































write.csv(lipid_events, file="04_data/Lipid_events.csv")




Qrisk_Events <- sqlQuery(sql, "SELECT DISTINCT *, ROW_NUMBER() OVER (PARTITION BY ALF_PE, READ_TYPE ORDER BY ALF_PE, EVENT_DT)  AS MEASUREMENT_NUMBER
                        FROM SAILW0800V.COHORT_BASE_TABLE     
                        WHERE (READ_TYPE = 'qrisk2score' AND EVENT_VAL < 101)
                        OR (READ_TYPE = 'qrisk_score' AND EVENT_VAL < 101)")



describe(Qrisk_Events)
unique(Qrisk_Events$READ_TYPE)

# Take only first 3 measurements
Qrisk_Events <- Qrisk_Events %>% filter(MEASUREMENT_NUMBER < 4)

Qrisk_Events1 <- Qrisk_Events

Qrisk_Events <- Qrisk_Events1

library(ggplot2)
ggplot(Qrisk_Events, aes(EVENT_VAL)) + geom_density() + xlim(0,100)

#change to data table, cast long to wide
Qrisk_Events <- setDT(Qrisk_Events)
Qrisk_Events <- dcast(Qrisk_Events, ALF_PE ~ READ_TYPE + MEASUREMENT_NUMBER, value.var = c("EVENT_VAL", "EVENT_DT"))

Qrisk_Events <- merge(cohort_entry, Qrisk_Events, by="ALF_PE", all.x = TRUE)


colnames <- colnames(Qrisk_Events)[grepl("_DT", colnames(Qrisk_Events))]

#loop through and take each columns away from the enter-cohort..
for (i in colnames){
  Qrisk_Events[i] <- Qrisk_Events[i] - Qrisk_Events["ENTER_COHORT"]
  gc() # clear unused memory
}

Qrisk_Events <- Qrisk_Events %>% mutate_if(is.difftime, as.integer)

































#Add this to the Cohort Wide Table...

load("04_data/04a_Cohort_Base_Table_Wide.RData")
load("04_data/04_data/BP_events.Rdata")

cohort_entry <- cohort_entry %>% mutate_if(is.difftime, as.integer)

#drop column
base_table_cleansed$BP <- NULL

base_table_cleansed <- merge(base_table_cleansed, cohort_entry, by="ALF_PE", all.x = TRUE)

#drop column
base_table_cleansed$ENTER_COHORT.y <- NULL

#save the changed file
save(base_table_cleansed, file="04_data/04a_Cohort_Base_Table_Wide.RData")


# =============================================






# =============================================



names(base_table_cleansed) <- gsub("[() -.]", "_", names(base_table_cleansed))

library(haven)

write_sav(BP_events, "04_data/BP_events.sav")



