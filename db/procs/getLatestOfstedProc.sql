USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getLatestOfstedProc;

delimiter //

CREATE PROCEDURE getLatestOfstedProc (estab INT(7),OUT l_ofsted TINYINT(4)) 

READS SQL DATA
BEGIN

DECLARE l_ofsted TINYINT(4);

	SELECT ed2.INSPOUTCOME
	FROM 	EdSpineTb ed1,EdSpineTb ed2
	WHERE	ed2.LAESTAB = estab
	AND	ed1.LAESTAB = estab
	AND     ed1.INSPOUTCOME = 0
	AND 	ed1.ICLOSE = 1
	AND 	ed2.ICLOSE = 2;

END;
//
delimiter ;
