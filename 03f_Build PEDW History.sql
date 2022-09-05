DROP TABLE SAILW0800V.PEDWTABLE_history;
-----------------------------------
CREATE TABLE SAILW0800V.PEDWTABLE_history AS (
SELECT ch.ALF_PE, ch.PERS_ID_PE, ch.ENTER_COHORT, ch.EXIT_COHORT, pedw.PERSON_SPELL_NUM_PE, pedw.START_DATE, pedw.END_DATE, pedw.DIAG_NUM, pedw.DIAG_CD_1234, readcodes.ICD_TYPE, readcodes."pre2010", readcodes."StudyPeriod20102019" 
FROM SAILW0800V.COHORT_ENTRY ch
LEFT JOIN (
	SELECT *
	FROM SAIL0800V.PEDW_SINGLE_DIAG_20220801 psd ) AS pedw
	ON ch.ALF_PE = pedw.ALF_PE

	RIGHT JOIN (SELECT * FROM SAILW0800V.IMPORTED_CVD_ICDCODES) as readcodes
			ON pedw.DIAG_CD_1234  = readcodes.DIAG_CD_4
	WHERE pedw.START_DATE < ch.ENTER_COHORT) WITH NO DATA; 



-----INSERT CVD ICD CODES
INSERT INTO SAILW0800V.PEDWTABLE_history (SELECT ch.ALF_PE, ch.PERS_ID_PE, ch.ENTER_COHORT, ch.EXIT_COHORT, pedw.PERSON_SPELL_NUM_PE, pedw.START_DATE, pedw.END_DATE, pedw.DIAG_NUM, pedw.DIAG_CD_1234, readcodes.ICD_TYPE, readcodes."pre2010", readcodes."StudyPeriod20102019" 
FROM SAILW0800V.COHORT_ENTRY ch
LEFT JOIN (
	SELECT *
	FROM SAIL0800V.PEDW_SINGLE_DIAG_20220801 psd ) AS pedw
	ON ch.ALF_PE = pedw.ALF_PE

	RIGHT JOIN (SELECT * FROM SAILW0800V.IMPORTED_CVD_ICDCODES) as readcodes
			ON pedw.DIAG_CD_1234  = readcodes.DIAG_CD_4
	WHERE pedw.START_DATE < ch.ENTER_COHORT
		AND NOT readcodes."pre2010" = 0) ;



---- Insert OPCS

INSERT INTO SAILW0800V.PEDWTABLE (SELECT ch.ALF_PE, ch.PERS_ID_PE, ch.ENTER_COHORT, ch.EXIT_COHORT, pedw.PERSON_SPELL_NUM_PE, pedw.START_DATE, pedw.END_DATE, pedw.DIAG_NUM, pedw.DIAG_CD_1234, readcodes.OPCS_TYPE, readcodes."pre2010", readcodes."StudyPeriod20102019" 
FROM SAILW0800V.COHORT_ENTRY ch
LEFT JOIN (
SELECT * FROM SAIL0800V.PEDW_SINGLE_DIAG_20220801 pedw ) AS pedw
	ON ch.ALF_PE = pedw.ALF_PE

	RIGHT JOIN (SELECT * FROM SAILW0800V.IMPORTED_CVD_PROCEDURECODES) as readcodes
			ON pedw.DIAG_CD_1234  = readcodes.CODE_WITHOUT_DECIMAL
	WHERE pedw.START_DATE < ch.ENTER_COHORT
		AND NOT readcodes."pre2010" = 0) ;



			