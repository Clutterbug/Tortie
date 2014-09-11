USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getClosestWardProc;

delimiter //

CREATE PROCEDURE getClosestWardProc (loc_lat DECIMAL(5,2),loc_long DECIMAL(5,2),
					OUT l_warddist DECIMAL(5,1), OUT l_Ward VARCHAR(60),
					OUT l_District VARCHAR(60), OUT l_AvPrice FLOAT)
READS SQL DATA
BEGIN

DECLARE done INT DEFAULT 0;
DECLARE dist INT DEFAULT 5;
DECLARE ll_warddist DECIMAL(5,1);
DECLARE ll_Ward VARCHAR(60);
DECLARE ll_District VARCHAR(60);
DECLARE ll_AvPrice FLOAT;

DECLARE cur1 CURSOR FOR

	SELECT  
		( 6371 * acos(sin( radians(loc_lat) ) * sin( radians( ward.Latitude ) ) 
                +cos( radians(loc_lat) ) * cos( radians( ward.Latitude ) ) * cos( radians( ward.Longitude ) 
                - radians(loc_long) ) ) ) as distance, Ward,District,AveragePrice
	FROM wardLocationsTb ward
	HAVING distance < 5
	ORDER BY distance limit 3;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

DROP TEMPORARY TABLE IF EXISTS ward_data;

CREATE TEMPORARY TABLE ward_data
        (Distance DECIMAL(5,1),Ward VARCHAR(60),District VARCHAR(60),AveragePrice FLOAT);

OPEN cur1;
ward_loop:LOOP
        FETCH cur1 INTO ll_warddist,ll_Ward,ll_District,ll_AvPrice;

        IF done=1 THEN
                LEAVE ward_loop;
        END IF;

        INSERT INTO ward_data (Distance,Ward,District,AveragePrice)
                VALUES (ll_warddist,ll_Ward,ll_District,ll_AvPrice);

END LOOP ward_loop;
CLOSE cur1;

SELECT Distance,Ward,District,AveragePrice
INTO l_warddist,l_Ward,l_District,l_AvPrice
FROM ward_data LIMIT 1;


DROP TEMPORARY TABLE ward_data;
END;
//
delimiter ;
