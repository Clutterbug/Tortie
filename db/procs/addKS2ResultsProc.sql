USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS addKS2ResultsProc;

delimiter //

CREATE PROCEDURE addKS2ResultsProc (urn INT(6))
BEGIN
 
DECLARE l_p4engmath VARCHAR(86);
DECLARE l_p5engmath VARCHAR(86);
DECLARE l_sql VARCHAR(4000);

SELECT 	VALUE
INTO 	l_p4engmath
FROM	tempSchData
WHERE   VARIABLE like 'PTENGMATX';

SELECT 	VALUE
INTO 	l_p5engmath
FROM	tempSchData
WHERE   VARIABLE like 'PTENGMATAX';

IF (l_p4engmath) THEN
	SET l_sql = CONCAT('UPDATE EdSpineTb',
		' SET PTENGMATX ="',l_p4engmath, '"',
		' ,PTENGMATAX = "', l_p5engmath, '"',
		' where URN="', urn, '"');
	SET @sql=l_sql;
	PREPARE s1 from @sql;
	EXECUTE s1;
	DEALLOCATE PREPARE s1;
END IF;

 
END;
//
delimiter ;
