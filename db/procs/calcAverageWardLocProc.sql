USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS calcAverageWardLocProc;

delimiter //

CREATE PROCEDURE calcAverageWardLocProc (LATable VARCHAR(60))
BEGIN
	DECLARE l_sql VARCHAR(4000);
	
	SET l_sql = CONCAT(
		'INSERT wardLocationsTb ',
		'SELECT ?',
		',Ward,AVG(Latitude),AVG(Longitude),0,0,0,0,0 ',
		'FROM ',LATable,  
		' GROUP BY Ward');
	SET @sql=l_sql;
        PREPARE s1 FROM @sql;
	SET @lacode := LATable;
        EXECUTE s1 USING @lacode;
        DEALLOCATE PREPARE s1;

END;
//
delimiter ;
