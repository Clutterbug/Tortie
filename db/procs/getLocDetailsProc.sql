USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getLocDetailsProc;

delimiter //

CREATE PROCEDURE getLocDetailsProc (locName VARCHAR(256),locCounty VARCHAR(256))

READS SQL DATA
BEGIN

DECLARE l_latitude DECIMAL(5,2);
DECLARE l_longitude DECIMAL(5,2);
DECLARE l_Northing INT(6);
DECLARE l_Easting INT(6);
DECLARE l_warddist DECIMAL(5,1);
DECLARE l_Ward VARCHAR(60);
DECLARE l_District VARCHAR(60);
DECLARE l_AvPrice FLOAT;

SELECT DISTINCT Latitude,Longitude,Northing,Easting
INTO l_latitude,l_longitude,l_Northing,l_Easting
FROM ordDecLocationsTb 
WHERE Def_Nam = locName
AND Co_Name = locCounty;

DROP TEMPORARY TABLE IF EXISTS loc_data;

CREATE TEMPORARY TABLE loc_data
	(latitude DECIMAL(5,2),longitude DECIMAL(5,2),Northing INT(6),Easting INT(6),ClosestWard VARCHAR(60));

CALL getClosestWardProc(l_latitude,l_longitude,l_warddist,l_Ward,l_District,l_AvPrice); /* get the closest ward data */

INSERT INTO loc_data (latitude,longitude,Northing,Easting,ClosestWard)
VALUES	(l_latitude,l_longitude,l_Northing,l_Easting,l_Ward);

SELECT l_latitude,l_longitude,Northing,Easting,ClosestWard
FROM loc_data;

DROP TEMPORARY TABLE loc_data; 

END;
//
delimiter ;
