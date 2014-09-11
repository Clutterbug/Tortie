USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getClosestPSchoolProc;

delimiter //

CREATE PROCEDURE getClosestPSchoolProc (orig_lat DECIMAL(5,2),orig_lon DECIMAL(5,2),minor VARCHAR(30),nftype VARCHAR(30),rel 					VARCHAR(30),pnum INT,OUT l_schname VARCHAR(900),
					OUT l_postcode VARCHAR(90),OUT l_distance VARCHAR(90),OUT l_ofsted VARCHAR(90)) 

READS SQL DATA
BEGIN

DECLARE done INT DEFAULT 0;
DECLARE dist INT DEFAULT 5;
DECLARE ll_schname VARCHAR(89);
DECLARE ll_postcode VARCHAR(8);
DECLARE ll_distance DECIMAL(5,1);
DECLARE ll_ofsted TINYINT(4);

DECLARE cur1 CURSOR FOR

	SELECT ed.SCHNAME, ed.POSTCODE, ed.INSPOUTCOME,
		( 6371 * acos(sin( radians(orig_lat) ) * sin( radians( pc.Latitude ) ) 
                 +cos( radians(orig_lat) ) * cos( radians( pc.Latitude ) ) * cos( radians( pc.Longitude ) 
                 - radians(orig_lon) ) ) ) as distance
	FROM 	EdSpineTb ed,
		PostCodeTb pc
		UKPCodeLocationsTb pc
	WHERE	ed.POSTCODE = pc.PostCode
	AND ISPRIMARY = 1
	AND ICLOSE = 1
	AND ed.NFTYPE regexp nftype
	AND RELDENOM regexp rel
	AND MINORGROUP regexp minor
	having distance < dist
	ORDER BY distance limit 9; 

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

DROP TEMPORARY TABLE IF EXISTS school_data;

CREATE TEMPORARY TABLE school_data
	(schname VARCHAR(900),postcode VARCHAR(90), ofsted VARCHAR(90), distance VARCHAR(90));

OPEN cur1;
school_loop:LOOP
	FETCH cur1 INTO ll_schname,ll_postcode,ll_ofsted,ll_distance;

	IF done=1 THEN
		LEAVE school_loop;
	END IF;

	INSERT INTO school_data (schname,postcode,ofsted,distance)
		VALUES (ll_schname,ll_postcode,ll_ofsted,ll_distance);

END LOOP school_loop;
CLOSE cur1;

SELECT group_concat(schname separator ';') ,group_concat(postcode separator ';'), group_concat(format(ofsted,0) separator ';'), group_concat(format(distance,1) separator ';')
INTO l_schname,l_postcode,l_ofsted,l_distance
FROM school_data;


DROP TEMPORARY TABLE school_data;

END;
//
delimiter ;
