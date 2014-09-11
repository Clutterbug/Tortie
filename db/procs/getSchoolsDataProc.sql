USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getSchoolsDataProc;

delimiter //

CREATE PROCEDURE getSchoolsDataProc (locName VARCHAR(256),locCounty VARCHAR(256),pminor VARCHAR(30),pnftype VARCHAR(30),prel VARCHAR(30),pnum INT,sminor VARCHAR(30),snftype VARCHAR(30),srel VARCHAR(30),snum INT)
		
READS SQL DATA
BEGIN

DECLARE l_Town_lr VARCHAR(48);
DECLARE l_Town_ukp VARCHAR(48);
DECLARE l_Latitude DECIMAL(5,2);
DECLARE l_Longitude DECIMAL(5,2);

DECLARE dist INT DEFAULT 5;

DECLARE l_schname VARCHAR(900);
DECLARE l_postcode VARCHAR(90);
DECLARE l_distance VARCHAR(90);
DECLARE l_ofsted VARCHAR(90);
DECLARE l_pors CHAR(1);

SELECT DISTINCT Co_Name,Def_Nam,Latitude,Longitude
INTO l_town_lr,l_town_ukp,l_latitude,l_longitude
FROM ordDecLocationsTb
WHERE Def_Nam = locName
AND Co_Name = locCounty;

DROP TEMPORARY TABLE IF EXISTS schools_data;

CREATE TEMPORARY TABLE schools_data
	(schname VARCHAR(900),postcode VARCHAR(90),distance VARCHAR(90),ofsted VARCHAR(90),pors CHAR(1));

CALL getClosestPSchoolProc(l_latitude,l_longitude,pminor,pnftype,prel,pnum,l_schname,l_postcode,l_distance,l_ofsted); /* get the closest primary school data */
	
INSERT INTO schools_data (schname,postcode,distance,ofsted,pors)
	VALUES (l_schname,l_postcode,l_distance,l_ofsted,'P');

CALL getClosestSSchoolProc(l_latitude,l_longitude,sminor,snftype,srel,snum,l_schname,l_postcode,l_distance,l_ofsted);  /* get the closest secondary school data */

INSERT INTO schools_data (schname,postcode,distance,ofsted,pors)
	VALUES (l_schname,l_postcode,l_distance,l_ofsted,'S');


SELECT schname,postcode,distance,ofsted,pors
FROM schools_data;


DROP TEMPORARY TABLE schools_data;

END;
//
delimiter ;
