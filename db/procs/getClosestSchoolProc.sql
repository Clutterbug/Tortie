USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getClosestSchoolProc;

delimiter //

CREATE PROCEDURE getClosestSchoolProc (orig_lat DECIMAL(5,2),orig_lon DECIMAL(5,2),minor VARCHAR(30),nftype VARCHAR(30),rel VARCHAR(30),pnum INT,
					OUT l_schname VARCHAR(89),OUT l_postcode VARCHAR(8),OUT l_distance DECIMAL(5,1)) 
READS SQL DATA
BEGIN

DECLARE done INT DEFAULT 0;
DECLARE dist INT DEFAULT 5;
DECLARE ll_schname VARCHAR(89);
DECLARE ll_postcode VARCHAR(8);
DECLARE ll_distance DECIMAL(5,1);

DECLARE cur1 CURSOR FOR

	SELECT ed.SCHNAME, ed.POSTCODE, 
		( 6371 * acos(sin( radians(orig_lat) ) * sin( radians( pc.Latitude ) ) 
                 +cos( radians(orig_lat) ) * cos( radians( pc.Latitude ) ) * cos( radians( pc.Longitude ) 
                 - radians(orig_lon) ) ) ) as distance
	FROM 	EdSpineTb ed,
		UKPCodeLocationsTb pc
	WHERE	ed.POSTCODE = pc.Postcode
	AND ISPRIMARY = 1
	AND ICLOSE = 1
	AND ed.NFTYPE regexp nftype
	AND RELDENOM regexp rel
	AND MINORGROUP regexp minor
	having distance < dist
	ORDER BY distance limit pnum; 

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

DROP TEMPORARY TABLE IF EXISTS school_data;

CREATE TEMPORARY TABLE school_data
	(schname VARCHAR(89),postcode VARCHAR(8),distance DECIMAL(5,1));

OPEN cur1;
school_loop:LOOP
	FETCH cur1 INTO ll_schname,ll_postcode,ll_distance;

	IF done=1 THEN
		LEAVE school_loop;
	END IF;

	INSERT INTO school_data (schname,postcode,distance)
		VALUES (ll_schname,ll_postcode,ll_distance);

END LOOP school_loop;
CLOSE cur1;

SELECT schname,postcode,distance
INTO l_schname,l_postcode,l_distance
FROM school_data LIMIT 1;


DROP TEMPORARY TABLE school_data;

END;
//
delimiter ;
