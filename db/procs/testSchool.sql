USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getSchoolsDataProc;

delimiter //

CREATE PROCEDURE getSchoolsDataProc (locName VARCHAR(256),locCounty VARCHAR(256))
		
READS SQL DATA
BEGIN

DECLARE l_Town_lr VARCHAR(48);
DECLARE l_Town_ukp VARCHAR(48);
DECLARE l_Latitude DECIMAL(5,2);
DECLARE l_Longitude DECIMAL(5,2);

DECLARE done INT DEFAULT 0;
DECLARE dist INT DEFAULT 5;

DECLARE l_schname VARCHAR(89);
DECLARE l_postcode VARCHAR(8);
DECLARE l_distance DECIMAL(5,1);
DECLARE l_pors CHAR(1);

DECLARE cur1 CURSOR FOR
        SELECT DISTINCT Co_Name,Def_Nam,Latitude,Longitude
        FROM ordDecLocationsTb
        WHERE Def_Nam = locName
        AND Co_Name = locCounty;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

DROP TEMPORARY TABLE IF EXISTS schools_data;

CREATE TEMPORARY TABLE schools_data
	(schname VARCHAR(89),postcode VARCHAR(8),distance DECIMAL(5,1),pors CHAR(1));

OPEN cur1;
school_loop:LOOP
	FETCH cur1 INTO l_town_lr,l_town_ukp,l_latitude,l_longitude;

	IF done=1 THEN
		LEAVE school_loop;
	END IF;

	CALL getClosestSchoolProc(l_latitude,l_longitude,'Maintained%','Voluntary%','%',1,l_schname,l_postcode,l_distance); /* get the closest primary school data */

	INSERT INTO schools_data (schname,postcode,distance,pors)
		VALUES (l_schname,l_postcode,l_distance,'P');

END LOOP school_loop;
CLOSE cur1;

SELECT schname,postcode,distance,pors
FROM schools_data LIMIT 1;


DROP TEMPORARY TABLE schools_data;

END;
//
delimiter ;
