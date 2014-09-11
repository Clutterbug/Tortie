USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS marAddLandRegProc;

delimiter //

CREATE PROCEDURE marAddLandRegProc ()
BEGIN


	INSERT INTO landRegTb (
		TranId,
		Price,
		Date,
		Postcode1,
		Postcode2,
		PropertyType,
		OldOrNew,
		Duration,
		PAON,
		SAON,
		Street,
		Locality,
		District,
		Town,
		County,
		RecordStatus
	)	 
	SELECT DISTINCT	SUBSTRING(l.TranId FROM 2 FOR 36),
		CAST(l.Price AS DECIMAL(10,2)),
		STR_TO_DATE(l.Date, '%Y-%m-%d'),
		SUBSTRING_INDEX(l.Postcode, ' ', 1),
		LTRIM(RTRIM(SUBSTRING_INDEX(l.Postcode, ' ', -1))), 
		l.PropertyType,
		l.OldOrNew,
		l.Duration,
		l.PAON,
		l.SAON,
		l.Street,
		l.Locality,
		l.District,
		l.Town,
		l.County,
		l.RecordStatus 
	FROM 	landRegLoadTb l
	WHERE 	l.RecordStatus="A";


END;
//
delimiter ;
