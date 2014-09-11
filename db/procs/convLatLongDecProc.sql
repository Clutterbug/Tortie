USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS convLatLongDecProc;

delimiter //

/*script just to load in data, it needs to tweaking and rerunning to load in Easterly longitudes!*/
CREATE PROCEDURE convLatLongDecProc ()
READS SQL DATA
BEGIN

DECLARE done INT DEFAULT 0;
DECLARE l_Seq INTEGER(6);
DECLARE l_Def_Nam VARCHAR(60);
DECLARE l_Latitude DECIMAL(5,3);
DECLARE l_Longitude DECIMAL(5,3);
DECLARE l_North INT(7);
DECLARE l_East INT(7);
DECLARE l_GMT CHAR(1);
DECLARE l_Co_Code CHAR(2);
DECLARE l_Co_Name VARCHAR(60);
DECLARE l_F_Code CHAR(3);

/*Bit of a fudge here, run the script once for GMT='W', then remove the "-1*" for for !='W' and rerun script*/
DECLARE cur1 CURSOR FOR

	SELECT SEQ,DEF_NAM,(LAT_DEG + (LAT_MIN)/60) as declat,
               (-1*(LONG_DEG + (LONG_MIN)/60)) as declong, CO_CODE,FULL_COUNTY,F_CODE,NORTH,EAST
	FROM OSGaz
 	WHERE GMT='W';

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

OPEN cur1;
conv_loop:LOOP
	FETCH cur1 INTO l_Seq,l_Def_Nam,l_Latitude,l_Longitude,l_Co_Code,l_Co_Name,l_F_Code,l_North,l_East;

	IF done=1 THEN
		LEAVE conv_loop;
	END IF;

	INSERT INTO ordDecLocationsTb ()
		VALUES (l_Seq,l_Def_Nam,l_Latitude,l_Longitude,l_North,l_East,l_Co_Code,l_Co_Name,l_F_Code);

END LOOP conv_loop;
CLOSE cur1;

END;
//
delimiter ;
