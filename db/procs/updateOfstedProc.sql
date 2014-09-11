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


UPDATE EdSpineTb e,new_schools s
SET 	e.INSPOUTCOME = s.OfstedRating,
	e.INSPDATE = s.OfstedDate,
	e.REPORTURL = s.OfstedURL
WHERE 	e.LAESTAB = s.laestab
AND 	e.INSPOUTCOME=0
AND 	e.NEWACFLAG=1;

DROP TEMPORARY TABLE new_schools;
 
END;
//
delimiter ;
