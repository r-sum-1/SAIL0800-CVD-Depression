-- This script will 
-- Generate a Table based on the CVD risk assessment codes
-- Insert codes into this from SAILUKHDV.read_cd_cv2_scd



DROP TABLE sailw0800v.CVD_RISK_ASSESS_CODES	;
	
CREATE TABLE sailw0800v.CVD_RISK_ASSESS_CODES AS (
	SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'hdl' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '44P5.'	
	UNION 
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'non_hdl' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '44PL1'	
	UNION 
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'ldl' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '44P6.'	
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'total_chol' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '44P..'
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'tc_hdl_ratio' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '44P..'
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'bp' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '246..' 
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'qrisk2_heart_age' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '22W..' 
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'qrisk_score' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '38DF.'
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'qrisk2_score' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '38DP.'	
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'qrisk_declined' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '8IEL.'
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'qrisk2_declined' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '8IEV.') WITH NO DATA;


INSERT INTO sailw0800v.CVD_RISK_ASSESS_CODES (	SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'hdl' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '44P5.'	
	UNION 
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'non_hdl' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '44PL1'	
	UNION 
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'ldl' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '44P6.'	
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'total_chol' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '44P..'
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'tc_hdl_ratio' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '44PF.'
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'bp' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '246..' 
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'qrisk2_heart_age' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '22W..' 
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'qrisk_score' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '38DF.'
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'qrisk2_score' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '38DP.'	
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'qrisk_declined' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '8IEL.'
	UNION
		SELECT READ_CODE, PREF_TERM_30, PREF_TERM_60, 'qrisk2_declined' as READ_TYPE from SAILUKHDV.read_cd_cv2_scd r
		WHERE read_code like '8IEV.');


	
-- Add columns		
ALTER TABLE sailw0800v.CVD_RISK_ASSESS_CODES	
ADD PRE_2010		INT 
ADD STUDY_PERIOD	INT;

UPDATE sailw0800v.CVD_RISK_ASSESS_CODES
SET PRE_2010 = 0,
STUDY_PERIOD = 1;



