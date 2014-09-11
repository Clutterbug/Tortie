USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS addOfstedRatingProc;

delimiter //

CREATE PROCEDURE addOfstedRatingProc (urn INT(6))
BEGIN
 
DECLARE l_OfstedRating VARCHAR(86);
DECLARE l_OfstedDate VARCHAR(86);
DECLARE l_OfstedURL VARCHAR(86);
DECLARE l_sql VARCHAR(4000);

SELECT 	VALUE
INTO	l_OfstedRating
FROM	tempSchData
WHERE   VARIABLE like 'INSPOUTCOME%';

SELECT 	VALUE
INTO 	l_OfstedDate
FROM	tempSchData
WHERE   VARIABLE like 'INSPDATE%';

SELECT 	VALUE
INTO 	l_OfstedURL
FROM	tempSchData
WHERE   VARIABLE like 'REPORTURL%';

IF (l_OfstedRating) THEN
	SET l_sql = CONCAT('UPDATE EdSpineTb',
		' SET INSPOUTCOME =',l_OfstedRating,
		' ,INSPDATE = "', l_OfstedDate, '"',
		' ,REPORTURL = "', l_OfstedURL, '"',
		' where URN="', urn, '"');
	SET @sql=l_sql;
	PREPARE s1 from @sql;
	EXECUTE s1;
	DEALLOCATE PREPARE s1;
END IF;

 
END;
//
delimiter ;
