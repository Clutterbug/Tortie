USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getLocListProc;

delimiter //

CREATE PROCEDURE getLocListProc (name VARCHAR(60),county VARCHAR(60))
READS SQL DATA
BEGIN

	SELECT DISTINCT Def_Nam,Co_Name
	FROM ordDecLocationsTb 
	WHERE Def_Nam LIKE CONCAT(name,'%%') 
	and Co_Name LIKE CONCAT(county,'%%') 
	AND F_Code IN ('C','T','O');

END;
//
delimiter ;
