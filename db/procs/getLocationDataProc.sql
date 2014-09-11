USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getLocationDataProc;

delimiter //

CREATE PROCEDURE getLocationDataProc (locName VARCHAR(256),locCounty VARCHAR(256),pminor VARCHAR(30),pnftype VARCHAR(30),prel VARCHAR(30),pnum INT,sminor VARCHAR(30),snftype VARCHAR(30),srel VARCHAR(30),snum INT)

READS SQL DATA
BEGIN

DECLARE l_Town_lr VARCHAR(48);
DECLARE l_Town_ukp VARCHAR(48);
DECLARE l_latitude DECIMAL(5,2);
DECLARE l_longitude DECIMAL(5,2);
DECLARE l_Station VARCHAR(25);
DECLARE l_TravelcardZone VARCHAR(19);
DECLARE l_Terminus VARCHAR(24);
DECLARE l_DurationTerm INT;
DECLARE l_Distance DECIMAL(5,1);
DECLARE l_warddist DECIMAL(5,1);
DECLARE l_Ward VARCHAR(60);
DECLARE l_District VARCHAR(60);
DECLARE l_AvPrice FLOAT;
DECLARE l_Northing INT(6);
DECLARE l_Easting INT(6);
DECLARE l_pschname VARCHAR(900);
DECLARE l_sschname VARCHAR(900);
DECLARE l_pschpostcode VARCHAR(90);
DECLARE l_sschpostcode VARCHAR(8);
DECLARE l_pschdist VARCHAR(90);
DECLARE l_sschdist VARCHAR(90);
DECLARE l_pschofsted VARCHAR(90);
DECLARE l_sschofsted VARCHAR(90);


SELECT DISTINCT Co_Name,Def_Nam,Latitude,Longitude
INTO l_Town_lr,l_Town_ukp,l_latitude,l_longitude
FROM ordDecLocationsTb 
WHERE Def_Nam = locName
AND Co_Name = locCounty;

DROP TEMPORARY TABLE IF EXISTS loc_data;

CREATE TEMPORARY TABLE loc_data
	(Town_lr VARCHAR(48),Town_ukp VARCHAR(48),latitude DECIMAL(5,2),longitude DECIMAL(5,2),Station VARCHAR(25),TravelcardZone VARCHAR(19),
		Terminus VARCHAR(24),DurationTerm INT,Distance DECIMAL(5,1),
		ClosestWard VARCHAR(60),AvPrice FLOAT,ClosestPSchool VARCHAR(900),ClosestSSchool VARCHAR(900),PDist VARCHAR(90),SDist VARCHAR(90),POfsted VARCHAR(90),SOfsted VARCHAR(90));

CALL getClosestStationProc(l_latitude,l_longitude,l_Station,l_TravelcardZone,l_Terminus,l_DurationTerm,l_Distance); /* get the closest station data */

CALL getClosestWardProc(l_latitude,l_longitude,l_warddist,l_Ward,l_District,l_AvPrice); /* get the closest ward data */

CALL getClosestPSchoolProc(l_latitude,l_longitude,pminor,pnftype,prel,pnum,l_pschname,l_pschpostcode,l_pschdist,l_pschofsted); /* get the closest primary school data */

CALL getClosestSSchoolProc(l_latitude,l_longitude,sminor,snftype,srel,snum,l_sschname,l_sschpostcode,l_sschdist,l_sschofsted); /* get the closest secondary school data */

INSERT INTO loc_data (Town_lr,Town_ukp,latitude, longitude,Station,TravelcardZone,Terminus,DurationTerm,Distance,ClosestWard,AvPrice,ClosestPSchool,ClosestSSchool,PDist,SDist,POfsted,SOfsted)
	VALUES (l_Town_lr,l_Town_ukp,l_latitude,l_longitude,l_Station,l_TravelcardZone,l_Terminus,l_DurationTerm,l_Distance,l_Ward,l_AvPrice,l_pschname,l_sschname,l_pschdist,l_sschdist,l_pschofsted,l_sschofsted);

SELECT Town_lr,Town_ukp,latitude,longitude,Station,TravelcardZone,Terminus,DurationTerm,Distance,ClosestWard,AvPrice,ClosestPSchool,ClosestSSchool,PDist,SDist,POfsted,SOfsted
FROM loc_data;

DROP TEMPORARY TABLE loc_data;

END;
//
delimiter ;
