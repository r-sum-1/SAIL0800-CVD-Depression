DROP TABLE sailw0800v.aw_OPCS_CODES;

create table sailw0800v.aw_opcsjoined as(
 SELECT three.*, four.oper_cd as oper_cd_4, four.oper_desc_4 FROM SAILREFRV.OPCS4_OPER_CD_123 three
 inner join SAILREFRV.OPCS4_OPER_CD_42 four
 on three.oper_cd_123 = substr(four.oper_cd,1,3)
 )
 with no data;
 
 insert into sailw0800v.aw_opcsjoined
 SELECT three.*, four.oper_cd as oper_cd_4, four.oper_desc_4 FROM SAILREFRV.OPCS4_OPER_CD_123 three
 inner join SAILREFRV.OPCS4_OPER_CD_42 four
 on three.oper_cd_123 = substr(four.oper_cd,1,3);


Create table sailw0800v.aw_OPCS_CODES as (
SELECT distinct R.*, 'Balloon_STENTxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' as OPCS_TYPE FROM sailukhdv.opcs4_codes_and_titles R
where CODE_WITHOUT_DECIMAL like 'K75%') WITH NO DATA


Insert into sailw0800v.aw_OPCS_CODES(


 --------OPCS translum Balloon angioplasty and stenting-----------------------------------------------------
SELECT distinct R.*, 'Balloon_STENT' as OPCS_TYPE FROM sailukhdv.opcs4_codes_and_titles R
where CODE_WITHOUT_DECIMAL like 'K75%'

union
-----------------------angiography----------------------------------------------------------------------
SELECT distinct R.*, 'angio' as OPCS_TYPE FROM sailukhdv.opcs4_codes_and_titles R
where CODE_WITHOUT_DECIMAL like 'K63%'
or CODE_WITHOUT_DECIMAL in ('K508','K518')

union
---------------------------angio_injection----------------------------------------
SELECT distinct R.*, 'angio_injection' as OPCS_TYPE FROM sailukhdv.opcs4_codes_and_titles R
where CODE_WITHOUT_DECIMAL = 'K503'


union
-------------------------------angio_atherectomy-----------------------
SELECT distinct R.*, 'angio_atherectomy' as OPCS_TYPE FROM sailukhdv.opcs4_codes_and_titles R
where CODE_WITHOUT_DECIMAL = 'K504'
                 
 union                                                                                                                                       
----------------------FFR------------------------------------------------------------------------------


SELECT distinct R.*, 'FFR' as OPCS_TYPE FROM sailukhdv.opcs4_codes_and_titles R
where CODE_WITHOUT_DECIMAL like 'K51%'
union

---------------Balloon-Angioplasty------------------------------------------------------------------------

SELECT distinct R.*, 'Balloon' as OPCS_TYPE FROM sailukhdv.opcs4_codes_and_titles R
where CODE_WITHOUT_DECIMAL like 'K49%'
union
--------------------cabg------------------------------------------------------------------------------------------

SELECT distinct R.*, 'CABG' as OPCS_TYPE FROM sailukhdv.opcs4_codes_and_titles R
where CODE_WITHOUT_DECIMAL like 'Y731%'
or CODE_WITHOUT_DECIMAL in ('K402','K403','K401','K404','K408','K409','K431','K442','K451','K453','K454','K471',
'K411','K412','K413','K414','K418','K419',
'K421','K422','K423','K424','K428'
)

)



