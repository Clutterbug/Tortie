USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS modifyChangedEntriesProc;

delimiter //

CREATE PROCEDURE modifyChangedEntriesProc ()
BEGIN
        DECLARE l_TranId CHAR(36);
	DECLARE l_Price DECIMAL(10,2);
	DECLARE	l_Date DATE;
	DECLARE	l_Postcode1 CHAR(4);
	DECLARE	l_Postcode2 CHAR(3);
	DECLARE	l_PropertyType CHAR(1);
	DECLARE	l_OldOrNew CHAR(1);
	DECLARE	l_Duration CHAR(1);
	DECLARE	l_PAON VARCHAR(48);
	DECLARE l_SAON VARCHAR(48);
	DECLARE l_Street VARCHAR(48);
	DECLARE l_Locality VARCHAR(48);
	DECLARE l_District VARCHAR(48);
	DECLARE l_Town VARCHAR(48);
	DECLARE l_County VARCHAR(48);
		
	DECLARE done INT DEFAULT 0;

        DECLARE cur1 CURSOR FOR
        	SELECT  SUBSTRING(TranId FROM 2 FOR 36),
                	CAST(Price AS DECIMAL(10,2)),
                	STR_TO_DATE(Date, '%d/%m/%Y'),
                	SUBSTRING_INDEX(Postcode, ' ', 1),
                	LTRIM(RTRIM(SUBSTRING_INDEX(Postcode, ' ', -1))),
                	PropertyType,
                	OldOrNew,
                	Duration,
                	PAON,
                	SAON,
                	Street,
                	Locality,
                	District,
                	Town,
                	County
        	FROM landRegLoadTb 
        	WHERE RecordStatus = "C";  	

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

	OPEN cur1;
	del_loop:LOOP
		FETCH cur1 into l_TranId, l_Price, l_Date, l_Postcode1, l_Postcode2,
				l_PropertyType, l_OldOrNew, l_Duration, l_PAON, l_SAON,
				l_Street, l_Locality, l_District, l_Town, l_County;
		UPDATE landRegTb 
		SET 	Price = l_Price,
			Date = l_Date,
			Postcode1 = l_Postcode1,
			Postcode2 = l_Postcode2,
			PropertyType = l_PropertyType,
			OldOrNew = l_OldOrNew,
			Duration = l_Duration,
			PAON = l_PAON,
			SAON = l_SAON,
			Street = l_Street,
			Locality = l_Locality,
			District = l_District,
			Town = l_Town,
			County = l_County,
			RecordStatus = "M"	
		WHERE TranId = l_TranId;
		IF done=1 THEN
			LEAVE del_loop;
		END IF;
	END LOOP del_loop;
	CLOSE cur1; 

END;
//
delimiter ;
