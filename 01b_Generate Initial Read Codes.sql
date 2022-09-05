DROP TABLE SAILW0800V.readcodes;



CREATE TABLE SAILW0800V.readcodes as (
   SELECT r.* from SAILUKHDV.read_cd_cv2_scd r
   WHERE read_code = '1B12.'
) WITH NO DATA

-- Add a column to allow us to include read_type column
ALTER TABLE sailw0800v.readcodes
ADD read_type varchar(255);

INSERT INTO SAILW0800V.readcodes(

SELECT r.*, 'AF' as read_type from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code in ('3272.','3273.','14AN.','14AR.','8CMW2')
or read_code like 'G573%'

UNION

-------------------weight--------------------------------------------------------------------------
SELECT r.*, 'weight' as read_type from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code like '22k%'
or read_code like  '22A%'
or read_code like '22K%'

UNION


--------------stage4+renal-------------------------------------------------------------------------
SELECT r.*, 'CRF' as read_type from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code in ('K054.','K055.','1Z13.','1Z14.'
,'1Z1H.','1Z1J.','1Z1K.','1Z1L.')          ------'K053.' and '1Z12.' '1Z15.''1Z1C.''1Z1D.''1Z1E.','1Z1F.','1Z1G.'= ckd stage 3
UNION

------hypertension-------------------------------------------------------------

SELECT r.*, 'hypertension' as read_type from SAILUKHDV.read_cd_cv2_scd r
Where read_code in ('14A2.')
or read_code like 'G2%'

UNION

-----stroke-----------------------------------------------
SELECT r.*, 'stroke' as read_type from SAILUKHDV.read_cd_cv2_scd r
Where read_code in ('14A7.','ZV125','G66..','G660,','G661.','G662.','G663.','G664.','G665.','G666.','G667.','G668.',
'G65..','G65z','G65z1','G65zz','G66..')
or read_code like 'G64%'


UNION

----haemorrhagic stroke------
SELECT r.*, 'haem_stroke' as read_type from SAILUKHDV.read_cd_cv2_scd r
Where read_code like 'G61%'
or read_code like 'G60%'

UNION

-----------------------
SELECT r.*, 'other_haemorrhage' as read_type from SAILUKHDV.read_cd_cv2_scd r
Where read_code in ('G620.','G621.','G622.','G623.')

UNION
----liver disease----

SELECT r.*, 'liver_disease' as read_type from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code in ('J6152','C3104','Jyu71','G8522','G8523','J6356')
or read_code like 'J615%'
or read_code like 'J612%'
or read_code like 'J61%'

UNION 
----------------dementia------------------------
SELECT r.*, 'dementia' as read_type from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code like'E00%'
or read_code like 'Eu0%'
UNION
------diabetes---------
SELECT r.*, 'diabetes' as read_type from SAILUKHDV.read_cd_cv2_scd r
Where read_code in ('C314.','1434.','C10D.','C10C.')
or read_code like 'C100%'
or read_code like 'C101%'
or read_code like 'C103%'
or read_code like 'C104%'
or read_code like 'C105%'
or read_code like 'C016%'
or read_code like 'C107%'
or read_code like 'C108%'
or read_code like 'C109%'
or read_code like 'C10A%'
or read_code like 'C10B%'
or read_code like 'C10E%'
or read_code like 'C10E%'
or read_code like 'C10F%'
or read_code like 'C10G%'
or read_code like 'C10H%'
or read_code like 'C10J%'
or read_code like 'C10K%'
or read_code like 'C10L%'
or read_code like 'C10M%'
or read_code like 'C10N%'
or read_code like 'C10P%'
or read_code like 'C10y%'
or read_code like 'C10z%'
or read_code like 'C10E%'
or read_code like 'C10F%'
or read_code like 'F372%'
or read_code like 'C10B%'
or read_code like 'C10A%'
or read_code like '66AJ%'
or read_code like 'F372%'


UNION
-----Heart failure-------

SELECT r.*, 'heart_failure' as read_type from SAILUKHDV.read_cd_cv2_scd r
Where read_code like 'G58%'

UNION
------IHD,MI-----

SELECT r.*, 'IHD' as read_type from SAILUKHDV.read_cd_cv2_scd r 
--WHERE read_code like 'G3%'
WHERE read_code  in ('G3..','G30..','G300.','G301.','G3010','G3011','G301z','G302.','G303.',
'G304.','G305.','G306.','G307.','G3070''G3071','G308.','G30B.','G30x.','G30X0','G30y.','G30y0','G30y1',
'G30y2','G30yz','G30z.','G31..','G310.','G311.','G3111','G3112','G3113','G3114','G3115','G311z','G312.','G31y.',
'G31y0','G31y1','G31y2','G31y3','G31yz','G32..','G33..','G330.','G3300','G330z','G331.','G332.','G33z.','G33z0',
'G33z1','G33z2','G33z3','G33z4','G33z5','G33z7','G33zz','G34..','G3400', 
'G3401', 'G342.','G343.','G344.','G34y0','G34y.','G34y0','G34y1','G34yz','G34z.','G34z0','G35..','G351.','G353.',
'G35X.','G36..','G360.','G361.','G362.','G363.','G364.','G365.',
'G362.','G363.','G364.','G365.','G38..','G381.','G382.','G383.','G384.','G38z.','G3y..','G3z..')


UNION
------Valvular disease-------

 SELECT r.*, 'valvular_disease' as read_type from SAILUKHDV.read_cd_cv2_scd r
 WHERE read_code in ('G54z5','I4S4.','P6yy7','79144','14T3.','ZV422','ZV433',
'P6z0.','7919.','ZV45H','G5440','G5441','G5804','SP002','G5442','SP004')
or read_code like '791%'
or read_code like '7N40%'
or read_code like 'A932%'
or read_code like 'p60%'
or read_code like 'G140%'
or read_code like 'G11%'
or read_code like 'G12%'
or read_code like 'G141%'
or read_code like 'G13%'
or read_code like 'G54%'
or read_code like '791%'
or read_code like 'P6%'
UNION

---------malignant without bengign-------

SELECT * from
(SELECT r.*, 'malignant' as read_type from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code in ('142..','F4021','M1444','14250','4E33.','H51y7','BBe9.')
or read_code like 'BB%'
or read_code like 'B6%'
or read_code like 'B03%'
or read_code like 'B32%'
or read_code like 'ZV10%'
or read_code like 'B4%'
or read_code like 'B5%'
or read_code like 'BBgM'
or read_code like 'B0%'
or read_code like 'B1%'
or read_code like 'B3%'
or read_code like 'B6%'
or read_code like 'B2%')
WHERE pref_term_60  not like '%benign%'

UNION

------dyslipidaemia------------------
SELECT r.*, 'dyslipid' as read_type from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code in ('C324.','C328.','C329.')
or read_code like 'C320%'
or read_code like 'C321%'
or read_code like 'C322%'

UNION
----------emboli-------------------------
SELECT r.*, 'emboli' as read_type  from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code in ('14A8.','14A81','G82z0','G801B',
'G801C','G801D','G801E','G801F','G801G','14AC.')
or read_code like 'G401%'
UNION
---------------copd------------------------------
SELECT r.*, 'copd' as read_type  from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code in ('H3...','H36..','H37..','H38..','H39..','H3A..','H3121','H3122','H3z..','H300.')
or read_code like 'H32%'
or read_code like 'H3y%'
or read_code like 'H3B%'


UNION

-----------------asthma-------------------------------
SELECT r.*, 'asthma' as read_type  from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code like 'H33%'
UNION
----------PAD-------------------------
SELECT r.*, 'PAD' as read_type  from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code in ('G734.','G73..','G73z.','G73z0','G73zz','G73y.','Gyu74')

UNION
--------------aortic_plaque--------------------------------------

SELECT r.*, 'aortic_plaque' as read_type  from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code in ('G700.')
						
						);

-- ========================================================================================================================================
------ ADDITIONS TO THE EXCEL FILE
SELECT r.*, 'PAD' as read_type  from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code LIKE 'G7%'



SELECT r.*, 'Stroke' as read_type  from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code LIKE 'G6%'


SELECT r.*, 'Stroke' as read_type  from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code LIKE 'G7%'



SELECT r.*, 'Stroke' as read_type  from SAILUKHDV.read_cd_cv2_scd r
WHERE read_code LIKE 'G5%'


-----stroke-----------------------------------------------
SELECT r.*, 'stroke' as read_type from SAILUKHDV.read_cd_cv2_scd r
Where read_code in ('14A7.','ZV125','G66..','G660,','G661.','G662.','G663.','G664.','G665.','G666.','G667.','G668.',
'G65..','G65z','G65z1','G65zz','G66..')
or read_code like 'G64%'






