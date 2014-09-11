use tortie_co_uk_db;

CREATE TABLE ordDecLocationsTb (
	Seq 		INTEGER(6),
	Def_Nam 	VARCHAR(60),
	Latitude 	DECIMAL(5,3),
        Longitude 	DECIMAL(5,3),
	Co_Code		CHAR(2),
	Co_Name		VARCHAR(60),
	F_Code		CHAR(3)
);
