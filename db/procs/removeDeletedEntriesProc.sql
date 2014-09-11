USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS removeDeletedEntriesProc;

delimiter //

CREATE PROCEDURE removeDeletedEntriesProc ()
BEGIN
        DECLARE l_TranId CHAR(36);
	DECLARE done INT DEFAULT 0;

        DECLARE cur1 CURSOR FOR
        	SELECT SUBSTRING(TranId FROM 2 FOR 36)
        	FROM landRegLoadTb 
        	WHERE RecordStatus = "D";  	

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

	OPEN cur1;
	del_loop:LOOP
		FETCH cur1 into l_TranId;
		DELETE FROM landRegTb
		WHERE TranId = l_TranId;
		IF done=1 THEN
			LEAVE del_loop;
		END IF;
	END LOOP del_loop;
	CLOSE cur1; 

END;
//
delimiter ;
