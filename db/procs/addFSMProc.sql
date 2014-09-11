USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS addFSMProc;

delimiter //

CREATE PROCEDURE addFSMProc (urn INT(6))
BEGIN
 
DECLARE l_pfsm VARCHAR(86);
DECLARE l_sql VARCHAR(4000);

SELECT 	VALUE
INTO	l_pfsm
FROM	tempSchData
WHERE   VARIABLE like 'PNUMFSM'
AND     NAMESPACE like 'CENSUS_12';

IF (l_pfsm) THEN
	SET l_sql = CONCAT('UPDATE EdSpineTb',
		' SET PNUMFSM ="',l_pfsm, '"',
		' where URN="', urn, '"');
	SET @sql=l_sql;
	PREPARE s1 from @sql;
	EXECUTE s1;
	DEALLOCATE PREPARE s1;
END IF;

 
END;
//
delimiter ;
