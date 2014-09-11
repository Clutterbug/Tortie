USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getClosestStationProc;

delimiter //

CREATE PROCEDURE getClosestStationProc (orig_lat DECIMAL(5,2),orig_lon DECIMAL(5,2))
READS SQL DATA
BEGIN

DECLARE done INT DEFAULT 0;
DECLARE dist INT DEFAULT 5;
DECLARE l_Station VARCHAR(25);
DECLARE l_TravelcardZone VARCHAR(19);
DECLARE l_Terminus VARCHAR(24);
DECLARE l_DurationTerm INT;
DECLARE l_Distance DECIMAL(5,1);


DECLARE cur1 CURSOR FOR

	SELECT Station, TravelcardZone, Terminus, DurationTerm, 
		( 6371 * acos(sin( radians(orig_lat) ) * sin( radians( train.Latitude ) ) 
                 +cos( radians(orig_lat) ) * cos( radians( train.Latitude ) ) * cos( radians( train.Longitude ) 
                 - radians(orig_lon) ) ) ) as distance
	FROM londonTrainStationTb train
	having distance < dist
	ORDER BY distance limit 3; 

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

DROP TEMPORARY TABLE IF EXISTS train_data;

CREATE TEMPORARY TABLE train_data
	(Station VARCHAR(25),TravelcardZone VARCHAR(19),Terminus VARCHAR(24),DurationTerm INT,Distance DECIMAL(5,1));

OPEN cur1;
train_loop:LOOP
	FETCH cur1 INTO l_Station,l_TravelcardZone,l_Terminus,l_DurationTerm,l_Distance;

	IF done=1 THEN
		LEAVE train_loop;
	END IF;

	INSERT INTO train_data (Station,TravelcardZone,Terminus,DurationTerm,Distance)
		VALUES (l_Station,l_TravelcardZone,l_Terminus,l_DurationTerm,l_Distance);

END LOOP train_loop;
CLOSE cur1;

SELECT Station,TravelcardZone,Terminus,DurationTerm,Distance
FROM train_data;

DROP TEMPORARY TABLE train_data;

END;
//
delimiter ;
