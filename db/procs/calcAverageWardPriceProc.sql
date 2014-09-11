USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS calcAverageWardPriceProc;

delimiter //

CREATE PROCEDURE calcAverageWardPriceProc (ward VARCHAR(60),LATable VARCHAR(60),PropType CHAR(1))
BEGIN

	DECLARE l_sql VARCHAR(4000);

	SET l_sql = CONCAT(
		'SELECT AVG(Price) FROM ',LATable,
		' LA,landRegTb LR',
		' WHERE LA.Postcode = concat(LR.Postcode1," ",LR.Postcode2)',
		' AND LR.PropertyType like "',PropType,'"',
		' AND LA.Ward="',ward,'"');
	SET @sql=l_sql;
	PREPARE s1 FROM @sql;
	EXECUTE s1;
	DEALLOCATE PREPARE s1;

END;
//
delimiter ;
