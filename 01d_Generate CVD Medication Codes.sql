DROP TABLE SAILW0800V.CVD_DRUGS;
CREATE TABLE SAILW0800V.CVD_DRUGS AS (
select r.*, 'H2antag' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'a61%'
or read_code like 'a62%'
or read_code like 'a68%'
or read_code like 'a69%'
or read_code like 'a6d%'

union
-----------------------------------ppi-------------------------------------------------------------------------------
select r.*, 'ppi' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'a6b%'
or read_code like 'a6c%'
or read_code like 'a6e%'
or read_code like 'a6f%'
or read_code  like 'a6h%'

union
-----------------------------------------glycosides-----------------------------------------------------
select r.*, 'glucoside' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'b1%'
union
---------------------------thiazide diuretics--------------------------------------------------------------
select r.*, 'thiazide' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'b2%'
union
----------------------------loop diuretics--------------------------------------------------------------------------------------
select r.*, 'loop' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'b3%'
union
--------------------------------potsparing diuretics---------------------------------------------------------------------------
select r.*, 'potsparing' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'b41%'
or read_code like 'b42%'
or read_code like 'b44%'
UNION 
------------pot sparing compound diurtetics----------------
select r.*, 'potsparing compound' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'b5%'
union
---------------------------Aldosterone antag------------------------------------------------------
select r.*, 'aldo' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'b43%'
or read_code like 'b45%'
union
--------------------------------verapmail-& diltiazem------------------------
select r.*, 'svt' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bb3%'
OR read_code LIKE 'bl5%'
OR READ_CODE LIKE 'blj%'
union
----------------------BetaBlocker---------------------------------------------------------------
select r.*, 'beta' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
--where read_code like 'bd%'
WHERE read_code like 'bd1%' 
OR READ_CODE LIKE 'bd2%'
OR READ_CODE  LIKE 'bd3%'
OR READ_code LIKE 'bd5%'
OR read_code LIKE 'bd6%'
OR read_code LIKE 'bd7%' OR READ_CODE LIKE 'bd8%'
OR READ_CODE like'bda%'
OR READ_CODE LIKE 'bdc%'
OR READ_CODE LIKE 'bdd%'
OR read_code LIKE 'bdf%'
OR READ_CODE LIKE 'bdj%'
OR READ_CODE LIKE 'bdl%'
OR read_code LIKE 'bdm%'
OR READ_CODE LIKE 'bdn5'
union
------------------vasodilator antihypertensives------------------------------------------------------------------
select r.*, 'vasodilator' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'be%'
union
-------------------------------------central---antihypertensives-----------------------------------------
select r.*, 'central' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bf%'

union
----------------------------------------alfa blockers--------------------------------------------------
select r.*, 'alfa' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bh%'
union
----------------------------------------ACEi/ARB/entresto-----------------------------------------------------
select r.*, 'ace' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bi%'
OR read_code LIKE 'bk3%'
or read_code like 'bk4%'
or read_code like 'bk5%'
or read_code like 'bk7%'
or read_code like 'bk8%'
or read_code like 'bkB%'
or read_code like 'bkC%'
or read_code like 'bkD%'
or read_code like 'bkH%'
or read_code like 'bkI%'
OR read_code LIKE 'bkL%'
union
 ----------------------dihydropyridine calcium chanel -----------------------------------------------------------
select r.*, 'amlod' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bl7%'
OR READ_CODE LIKE 'bl8%'
OR read_code LIKE 'blb%'
OR read_code LIKE 'blc%'
OR read_code LIKE 'ble%'
OR read_code LIKE 'blh%'
union
------------------------------------------parenteralAnticoag---dont this you'll need this----------------------------------

select r.*, 'parenteral_anticoag' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'br%'

union
---------------vit K-anticoag----------------------------------------------------------------
select r.*, 'vitk' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bs1%'
OR READ_CODE LIKE 'bs2%'
OR READ_CODE LIKE 'bs3%'
union
--------------------------DOAC
select r.*, 'doac' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bs4%'
OR READ_CODE LIKE 'bs7%'
OR READ_CODE LIKE 'bs6%'
OR read_code LIKE 'bs8%'
union
------------------------aspirin--------------------------------------------------------------
select r.*, 'aspirin' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bu2%'
OR READ_code = 'j111.'
union
----------------------------p2y12-antiplatelet--------------------------------------------
select r.*, 'p2y12' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'buA%'
OR read_code LIKE 'buB%'
OR read_code LIKE 'bu5%'

union
------------------------------------fibrate-----------------------------------------------------------
select r.*, 'fibrate' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bx1%'
or read_code like 'bx3%'
or read_code like 'bx6%'
or read_code like 'bxc%'
or read_code like 'bxf%'
union
---------------------------low -statin--------------------------------------------------------------------

select r.*, 'low_statin' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bxd%'
or read_code like 'bxe%'
or read_code like 'bxg%'
or read_code IN ('bxi1.','bxi2.')
or read_code like 'bxj%'
or read_code IN ('bxkx.','bxkw.')
OR read_code IN ('bxk4.','bxk1.','bxi4.','bxi5.')
union
--------------high statin---------------------
select r.*, 'high_statin' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code IN ('bxi3.', 'bxiz.','bxky.','bxkz.','bxi6.','bxi7.','bxk2.','bxk3.')
UNION 
------------------------------fish-----------------------------------------------------------------
select r.*, 'fish' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bxa%'
union
------------------------------other lipid-----------------------
select r.*, 'other_lipid' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code like 'bx2%'
or read_code like 'bx4%'
or read_code like 'bx8%'
or read_code like 'bx9%'
--or read_code like 'bxa%'
or read_code like 'bxb%'
--or read_code like 'bxa%'
or read_code like 'bxb%'
or read_code like 'bxh%'
--or read_code like 'bxl%'
or read_code like 'bxm%'
or read_code like 'bxn%'
UNION 
---------------------------------------
select r.*, 'ezetimibe' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code LIKE 'bxl%'
union
--------------------------insulin-------------------------------
select r.*, 'insulin' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code LIKE 'f1%'
OR read_code LIKE 'f2%'
OR read_code LIKE 'fw%'
UNION
------------------------oral antidiabetics----------------------------
select r.*, 'antidiab' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code LIKE 'f3%'
OR read_code LIKE 'f4%'
OR read_code LIKE 'ft%'
UNION 
--------------------------
select r.*, 'nsaid' as read_type, 'drug' as read_cat from SAILUKHDV.read_cd_cv2_scd r
where read_code LIKE 'j2%'

) WITH DATA;

-- To match the other imported tables... add column

ALTER SAILW0800V.CVD_DRUGS
ADD pre2010 varchar(30)
ADD StudyPeriod20102019 varchar(30);


