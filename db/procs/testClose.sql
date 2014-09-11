USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS updateOfstedProc;

delimiter //

CREATE PROCEDURE updateOfstedProc ()
BEGIN

DECLARE done INT DEFAULT 0;
DECLARE l_OfstedRating VARCHAR(86);
DECLARE l_OfstedDate VARCHAR(86);
DECLARE l_OfstedURL VARCHAR(86);
DECLARE l_laestab INT(7);
DECLARE l_sql VARCHAR(4000);


CREATE TEMPORARY TABLE new_schools
	(laestab INT(7),OfstedRating VARCHAR(86),OfstedDate VARCHAR(86),OfstedURL VARCHAR(86));

INSERT INTO new_schools(laestab,OfstedRating,OfstedDate,OfstedURL)
SELECT	e1.LAESTAB,e1.INSPOUTCOME,e1.INSPDATE,e1.REPORTURL
FROM EdSpineTb e1,EdSpineTb e2	 
WHERE e1.LAESTAB=e2.LAESTAB
AND e1.ICLOSE = 2
AND e2.ICLOSE = 1
AND e2.INSPOUTCOME = 0
AND e1.NEWACFLAG=2;


DECLARE cur1 CURSOR FOR

	SELECT laestab,OfstedRating,OfstedDate,OfstedURL
	from new_schools;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

OPEN cur1;
school_loop:LOOP
	FETCH cur1 INTO l_laestab,l_OfstedRating,l_OfstedDate,l_OfstedURL;

	IF done=1 THEN
		LEAVE school_loop;
	END IF;

IF (l_OfstedRating) THEN
	SET l_sql = CONCAT('UPDATE EdSpineTb',
		' SET INSPOUTCOME =',l_OfstedRating,
		' ,INSPDATE = "', l_OfstedDate, '"',
		' ,REPORTURL = "', l_OfstedURL, '"',
		' where LAESTAB="', l_laestab, '"');
	SET @sql=l_sql;
	PREPARE s1 from @sql;
	EXECUTE s1;
	DEALLOCATE PREPARE s1;
END IF;
END LOOP school_loop;
CLOSE cur1;

DROP TEMPORARY TABLE school_data;
 
END;
//
delimiter ;
