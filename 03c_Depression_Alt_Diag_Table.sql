DROP TABLE SAILW0800V.MHTable_antidepressants;
DROP TABLE SAILW0800V.MHTable_despress_symptoms;

-- Query GP events for any relevant READ_TYPE (antidepressants and depression symptoms)
-- Create two separate tables... one for antidepressants (MHTable_antidepressants), one for depression symptoms (MHTable_despress_symptoms).
-- Create a catchment time frame (EVENT_ST/EVENT_END)

-- Once in two tables, an inner join can be used to locate those who have overlapping symptom and antidepressant date ranges.
-- This will leave those who have symptoms and medication within 6 months of eachother (MHTable_Alternative_Diagnosis)
-- For purposes of checking, columns from both MHTable_antidepressants and MHTable_despress_symptoms are included...



-----------------------------------------------------------------------
-- This query will:
-- seek any GP event that is relevant, provided that event date > 0001-01-01
-- the EVENT_ST and EVENT_END is creating a "catchment" time frame either side of the event date

SELECT ALF_PE, WOB, EVENT_CD, EVENT_VAL, EVENT_DT,
	(EVENT_DT - 90 DAY) AS EVENT_ST,
	(EVENT_DT + 90 DAY) AS EVENT_END,
	readcodes.READ_TYPE
	FROM SAIL0800V.WLGP_GP_EVENT_CLEANSED_20220101 gp
		INNER JOIN (
			SELECT * FROM SAILW0800V.IMPORTED_MH_READCODES) as readcodes
			ON readcodes.READ_CODE = gp.EVENT_CD
			WHERE EVENT_DT > '0001-01-01'
			AND readcodes.READ_TYPE = 'antidepressants'
			OR readcodes.READ_TYPE = 'depression_symptoms'
-----------------------------------------------------------------------
-----------------------------------------------------------------------	
------  Create a table based on the above query... 

CREATE TABLE SAILW0800V.MHTable_antidepressants AS (
SELECT ALF_PE, WOB, EVENT_CD, EVENT_VAL, EVENT_DT,
	(EVENT_DT - 90 DAY) AS EVENT_ST,
	(EVENT_DT + 90 DAY) AS EVENT_END,
	readcodes.READ_TYPE
	FROM SAIL0800V.WLGP_GP_EVENT_CLEANSED_20220101 gp
		INNER JOIN (
			SELECT * FROM SAILW0800V.IMPORTED_MH_READCODES) as readcodes
			ON readcodes.READ_CODE = gp.EVENT_CD
			WHERE EVENT_DT > '0001-01-01'
			AND readcodes.READ_TYPE = 'antidepressants'
			OR readcodes.READ_TYPE = 'depression_symptoms') WITH NO DATA;
-----------------------------------------------------------------------
-----------------------------------------------------------------------
		
---   Duplicate Table Structure for antidepressant...
CREATE TABLE SAILW0800V.MHTable_despress_symptoms LIKE SAILW0800V.MHTable_antidepressants;
		
--------------------  Insert query results into both tables	
INSERT INTO SAILW0800V.MHTable_antidepressants (
SELECT ALF_PE, WOB, EVENT_CD, EVENT_VAL, EVENT_DT,
	(EVENT_DT - 90 DAY) AS EVENT_ST,
	(EVENT_DT + 90 DAY) AS EVENT_END,
	readcodes.READ_TYPE
	FROM SAIL0800V.WLGP_GP_EVENT_CLEANSED_20220101 gp
	
		INNER JOIN (
			SELECT * FROM SAILW0800V.IMPORTED_MH_READCODES) as readcodes
			ON readcodes.READ_CODE = gp.EVENT_CD
			WHERE gp.EVENT_DT > '0001-01-01'
			AND readcodes.READ_TYPE = 'antidepressants'
			AND INTEGER(FLOOR(gp.EVENT_DT-gp.WOB)/10000) >= 18)
			
		
INSERT INTO SAILW0800V.MHTable_despress_symptoms (
SELECT ALF_PE, WOB, EVENT_CD, EVENT_VAL, EVENT_DT,
	(EVENT_DT - 90 DAY) AS EVENT_ST,
	(EVENT_DT + 90 DAY) AS EVENT_END,
	readcodes.READ_TYPE
	FROM SAIL0800V.WLGP_GP_EVENT_CLEANSED_20220101 gp
	
		INNER JOIN (
			SELECT * FROM SAILW0800V.IMPORTED_MH_READCODES) as readcodes
			ON readcodes.READ_CODE = gp.EVENT_CD
			WHERE gp.EVENT_DT > '0001-01-01'
			AND readcodes.READ_TYPE = 'depression_symptoms'
			AND INTEGER(FLOOR(gp.EVENT_DT-gp.WOB)/10000) >= 18)
			
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- Create 	MHTable_Alternative_Diagnosis table from above tables with an inner join
-- Drop table if exists
DROP TABLE SAILW0800V.MHTable_Alternative_Diagnosis;

--------------------  Create table based on query and insert into the results thereof.

CREATE TABLE SAILW0800V.MHTable_Alternative_Diagnosis AS (
SELECT DR1.ALF_PE, 
	DR1.WOB, 
	DR1.EVENT_CD AS ANTIDEPRESSANT_CD, 
	DR1.EVENT_DT AS ANTIDEPRESSANT_DT, 
	DR1.EVENT_ST AS ANTIDEPRESSANT_SD,
	DR1.EVENT_END AS ANTIDEPRESSANT_ED,
	DR1.READ_TYPE AS ANTIDEPRESSANT_READ_TYPE,
	DR2.EVENT_CD AS DIAG_CD, 
	DR2.EVENT_DT AS DIAG_DT, 
	DR2.EVENT_ST AS DIAG_SD,
	DR2.EVENT_END AS DIAG_ED,
	DR2.READ_TYPE AS DIAG_READ_TYPE,
	MIN(DR1.EVENT_DT, DR2.EVENT_DT)	AS EARLIEST_DATE
	FROM SAILW0800V.MHTable_antidepressants DR1 
		INNER JOIN (SELECT * FROM SAILW0800V.MHTable_despress_symptoms) AS DR2
		ON DR1.ALF_PE = DR2.ALF_PE
		WHERE (DR1.EVENT_ST, DR1.EVENT_END) OVERLAPS (DR2.EVENT_ST, DR2.EVENT_END)
		OR (DR2.EVENT_ST, DR2.EVENT_END) OVERLAPS (DR1.EVENT_ST, DR1.EVENT_END)
		ORDER BY DR1.ALF_PE) WITH NO DATA; 

INSERT INTO SAILW0800V.MHTable_Alternative_Diagnosis (
SELECT DR1.ALF_PE, 
	DR1.WOB, 
	DR1.EVENT_CD AS ANTIDEPRESSANT_CD, 
	DR1.EVENT_DT AS ANTIDEPRESSANT_DT, 
	DR1.EVENT_ST AS ANTIDEPRESSANT_SD,
	DR1.EVENT_END AS ANTIDEPRESSANT_ED,
	DR1.READ_TYPE AS ANTIDEPRESSANT_READ_TYPE,
	DR2.EVENT_CD AS DIAG_CD, 
	DR2.EVENT_DT AS DIAG_DT, 
	DR2.EVENT_ST AS DIAG_SD,
	DR2.EVENT_END AS DIAG_ED,
	DR2.READ_TYPE AS DIAG_READ_TYPE,
	MIN(DR1.EVENT_DT, DR2.EVENT_DT)	AS EARLIEST_DATE
	FROM SAILW0800V.MHTable_antidepressants DR1 
		INNER JOIN (SELECT * FROM SAILW0800V.MHTable_despress_symptoms) AS DR2
		ON DR1.ALF_PE = DR2.ALF_PE
		WHERE (DR1.EVENT_ST, DR1.EVENT_END) OVERLAPS (DR2.EVENT_ST, DR2.EVENT_END)
		OR (DR2.EVENT_ST, DR2.EVENT_END) OVERLAPS (DR1.EVENT_ST, DR1.EVENT_END)
		ORDER BY DR1.ALF_PE)
	

		
-- 
SELECT COUNT(*) -- Note, that because it's a full outer join, we want all rows to be counted whether they an ALF in the PEDW. GP or both... So not COUNT(DISTINCT(ALF_PE)
	FROM (SELECT DISTINCT SAILW0800V.PEDWTABLE.ALF_PE AS PEDW_ALF, SAILW0800V.GPTABLE.ALF_PE AS GP_ALF
	FROM SAILW0800V.PEDWTABLE
	FULL OUTER JOIN SAILW0800V.GPTABLE ON SAILW0800V.PEDWTABLE.ALF_PE = SAILW0800V.GPTABLE.ALF_PE)
	
	
	


	
	
