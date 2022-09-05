DROP TABLE sailw0800v.icdjoined;
DROP TABLE sailw0800v.ICDcodes;


CREATE TABLE sailw0800v.icdjoined as(
SELECT three.*, four.diag_cd_4, four.diag_desc_4 FROM SAILREFRV.ICD10_DIAG_CD_123 three
	inner join SAILREFRV.ICD10_DIAG_CD_4 four
	on three.diag_cd_123 = substr(four.diag_cd_4,1,3)
) WITH DATA;

CREATE TABLE sailw0800v.ICDcodes as(
SELECT * FROM sailw0800v.icdjoined
) WITH NO DATA 

-- Add a column to allow us to include icd_type column
ALTER TABLE sailw0800v.ICDcodes
ADD icd_type varchar(255)

INSERT INTO SAILW0800V.ICDcodes(
 --------stroke ICD------------------------------------------
SELECT DISTINCT *, 'stroke' as icd_type FROM sailw0800v.icdjoined
WHERE DIAG_CD_4 in ('I630', 'I631', 'I632','I633', 'I634', 'I635','I636', 'I693', 'I694','G459','G458') --------------added in TIA codes 30062017
	or DIAG_CD_123 LIKE 'I63%'
	or DIAG_CD_123 like 'I64%'
	or DIAG_CD_123 like 'I65%'
	or DIAG_CD_123 like 'I66%'
	
UNION

----------IHD-------------------------------------------------

SELECT DISTINCT *, 'IHD' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_4 in ('I201','I208','I209','I240','I248','I250','I251','I258')
WHERE DIAG_CD_4 like 'I5%'

UNION
------------------Unstable angina---------------------
SELECT distinct *, 'UA' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_4 in ('I200','I249')
or DIAG_CD_123 like 'I23%'
or DIAG_CD_123 like 'I22%'
UNION
 -----------MI------------------------------------------------
 
SELECT distinct *, 'MI' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_123 like 'I21%'
or DIAG_CD_123 like 'I22%'

UNION
---------------Heart failure-------------
SELECT distinct *, 'heartfailure' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_123 like 'I50%'

UNION
-----------Valvular----------------------


SELECT distinct *, 'valvular' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_123 like 'I34%'
or DIAG_CD_123 like 'I35%'
or DIAG_CD_123 like 'I36%'
or DIAG_CD_123 like 'I37%'
or DIAG_CD_123 like 'I39%'
or DIAG_CD_123 like 'I01%'
or DIAG_CD_123 like 'I05%'
or DIAG_CD_123 like 'I06%'
or DIAG_CD_123 like 'I07%'
or DIAG_CD_123 like 'I08%'
or DIAG_CD_123 like 'I09%'
or DIAG_CD_4 in ('Z9254','Z953','Z952','Q230')
UNION
---------------hypertension---------------------------------------

SELECT distinct *, 'hypertension' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_123 like 'I10%'
or DIAG_CD_123 like 'I11%'
or DIAG_CD_123 like 'I12%'
or DIAG_CD_123 like 'I13%'
or DIAG_CD_123 like 'I15%'
UNION
---------Haem stroke----------------------------

SELECT distinct *, 'haemstroke' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_123 like 'I60%'
or DIAG_CD_123 like 'I61%'
or DIAG_CD_123 like 'I62%'

or DIAG_CD_4  in ('I690','I691','I692','I629')
UNION
---------------------------other haemorrhage---------------------
 SELECT distinct *, 'other_haemorrhage' as icd_type FROM sailw0800v.icdjoined R
 WHERE  DIAG_CD_4  in ('I620','I621','S064','S065','S066')


UNION
--------thrombo_embolism-----------------------------------------------------

SELECT distinct *, 'thrombo_embolism' as icd_type FROM sailw0800v.icdjoined R
WHERE  DIAG_CD_123 like 'I74%'
           
UNION
-----------------AF-----------
 SELECT distinct *, 'AF' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_123 like 'I48'
UNION
-------------diabetes----------------
SELECT distinct *, 'DM' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_123 like 'E10'
or DIAG_CD_123 like 'E11'
or DIAG_CD_123 like 'E12'
or DIAG_CD_123 like 'E13'
or DIAG_CD_123 like 'E14'
UNION
--------------liver------------------------------------------------
SELECT distinct *, 'liver' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_123 like 'K70'
or DIAG_CD_123 like 'K71'
or DIAG_CD_123 like  'K72'
or DIAG_CD_123 like 'K73'
or DIAG_CD_123 like 'K74'
or DIAG_CD_123 like 'K75'
or DIAG_CD_123 like 'K76'
or DIAG_CD_123 like 'K77'
or DIAG_CD_123 like 'R16'
or DIAG_CD_123 like 'R17'

UNION
----------renal------------------------------------------------------

SELECT distinct *, 'renal' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_123 like 'N17'
or DIAG_CD_123 like 'N18'
or DIAG_CD_123 like 'N19'
or DIAG_CD_123 like 'R34'
UNION
------------malignant------------------------------

SELECT distinct *, 'malignant' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_123 between 'C00' and 'C97'

UNION
----------------lipid--------------------


SELECT distinct *, 'lipid' as icd_type FROM  sailw0800v.icdjoined R
WHERE DIAG_CD_123 like 'E78'
UNION
-------------------bleeding Danish-------------------------------		

SELECT distinct *, 'bleeding' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_4 in ('K250','K254','K260','K264','K270','K280','K920','K921','K922',
'R31X','N028','N029','R042','R048','J942','R31x', 'R049', 'R040','R041') 
OR  DIAG_CD_123 IN 'R04'

         
UNION
---------------------------------------------------------------------------------------------------------------


SELECT distinct *, 'Add_bleed' as icd_type FROM sailw0800v.icdjoined R
WHERE DIAG_CD_4 IN ('K226','I850') 
UNION
-------------------------------------------------------------------------------------

SELECT distinct *, 'PAD' as icd_type FROM sailw0800v.icdjoined R            --------------contain PAD, 
--WHERE DIAG_CD_123 like
WHERE DIAG_CD_4 in ('I739','I738')     
UNION
------------------------------------aortic plaque----------------------------------------------         
SELECT distinct *, 'aortic_paque' as icd_type FROM sailw0800v.icdjoined R 
WHERE DIAG_CD_4 like 'I7%' 
-- WHERE DIAG_CD_4 in ('I700','I702')
UNION
------------------------------------Arrythmia disorders--------------------------------------------         
SELECT distinct *, 'Arrythmia' as icd_type FROM sailw0800v.icdjoined R 
WHERE DIAG_CD_4 like 'I4%'  
)


-- ========================================================================================================================================
------ ADDITIONS TO THE EXCEL FILE

SELECT distinct *, 'PAD Misc' as icd_type FROM sailw0800v.icdjoined R 
WHERE DIAG_CD_4 LIKE 'I7%' 
AND DIAG_CD_4 NOT IN ('I739','I738') -- These two are in PAD



SELECT distinct *, 'IHD (Cardiac Diag Misc)' as icd_type FROM sailw0800v.icdjoined R 
WHERE DIAG_CD_4 like 'I2%' 
WHERE DIAG_CD_4 like 'I5%' 



-- Cardiac Arrythmia disorders
SELECT distinct *, 'Cardiac Arrythmia disorders' as icd_type FROM sailw0800v.icdjoined R 
WHERE DIAG_CD_4 like 'I4%' 


