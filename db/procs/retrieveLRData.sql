USE tortie_co_uk_db;

DROP PROCEDURE IF EXISTS retrieveLRData;

delimiter //

CREATE PROCEDURE retrieveLRData ()
BEGIN
 
	select 	DATE_FORMAT(Date,'%d %b %Y') Date,
		SAON,
		PAON,
		Street,
		Locality,
		District,
		County,
		Postcode1,
		Postcode2,
		FORMAT(Price,0) Price
	from 	landRegTb
	where 	match(PostCode1, PostCode2,Street,Locality,District,Town,County)
			against('+TW11' IN BOOLEAN MODE)
	order by Date;

END;
//
delimiter ;
