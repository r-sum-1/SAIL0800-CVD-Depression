-- This script will generate a large table with all of the codes

DROP TABLE SAILW0800V.ALL_IMPORTED_CODES;

CREATE TABLE SAILW0800V.ALL_IMPORTED_CODES (
	READ_CODE				VARCHAR(10),
	DESCRIPTION				VARCHAR(255),
	CODE_TYPE				VARCHAR(30),
	CODE_CAT				VARCHAR(30),
	PRE_2010				INT,
	STUDY_PERIOD			INT);



INSERT INTO SAILW0800V.ALL_IMPORTED_CODES (
SELECT READ_CODE, PREF_TERM_30, READ_TYPE, 'CVD_Drug' AS CODE_CAT,  PRE2010, STUDYPERIOD20102019 FROM SAILW0800V.CVD_DRUGS);


INSERT INTO SAILW0800V.ALL_IMPORTED_CODES (
SELECT READ_CODE, PREF_TERM_30, READ_TYPE, 'CVD_Assessment' AS CODE_CAT,  PRE_2010, STUDY_PERIOD FROM SAILW0800V.CVD_RISK_ASSESS_CODES );


INSERT INTO SAILW0800V.ALL_IMPORTED_CODES (
SELECT DIAG_CD_123, DIAG_DESC_123, ICD_TYPE, 'CVD_ICD' AS CODE_CAT,  "pre2010", "StudyPeriod20102019" FROM SAILW0800V.IMPORTED_CVD_ICDCODES );


INSERT INTO SAILW0800V.ALL_IMPORTED_CODES (
SELECT CODE_WITHOUT_DECIMAL, TITLE, OPCS_TYPE, 'CVD_Procedure' AS CODE_CAT,  "pre2010", "StudyPeriod20102019" FROM SAILW0800V.IMPORTED_CVD_PROCEDURECODES );


INSERT INTO SAILW0800V.ALL_IMPORTED_CODES (
SELECT READ_CODE, PREF_TERM_30, READ_TYPE, 'CVD_Read' AS CODE_CAT,  "pre2010", "StudyPeriod20102019" FROM SAILW0800V.IMPORTED_CVD_READCODES );


INSERT INTO SAILW0800V.ALL_IMPORTED_CODES (
SELECT READ_CODE, DESCRIPTION, READ_TYPE, 'MH_Read' AS CODE_CAT,  "pre2010", "StudyPeriod20102019" FROM SAILW0800V.IMPORTED_MH_READCODES);

INSERT INTO SAILW0800V.ALL_IMPORTED_CODES (
SELECT 'alt_anx' AS READ_CODE, NULL AS DESCRIPTION, 'anxiety_alt_diag' AS READ_TYPE, 'MH_Read' AS CODE_CAT,  -1 AS PRE2010, 1 AS STUDYPERIOD20102019 FROM SAILW0800V.CVD_DRUGS);

INSERT INTO SAILW0800V.ALL_IMPORTED_CODES (
SELECT 'alt_dep' AS READ_CODE, NULL AS DESCRIPTION, 'depression_alt_diag' AS READ_TYPE, 'MH_Read' AS CODE_CAT,  -1 AS PRE2010, 1 AS STUDYPERIOD20102019 FROM SAILW0800V.CVD_DRUGS);