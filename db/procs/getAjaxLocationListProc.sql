USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS getAjaxLocationListProc;

delimiter //

CREATE PROCEDURE getAjaxLocationListProc (userloc VARCHAR(60))
READS SQL DATA
BEGIN

SELECT DISTINCT Def_Nam,Co_Name
FROM ordDecLocationsTb 
WHERE Def_Nam LIKE CONCAT(userloc,'%%') 
AND `F_Code` IN ('C','T','O')
LIMIT 10;


END;
//
delimiter ;
