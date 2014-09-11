use tortie_co_uk_db;

CREATE TABLE ordLocationsTb (
	Seq 		INTEGER(6),
	Def_Nam 	VARCHAR(60),
	Lat_Deg 	INTEGER(2),
        Lat_Min 	FLOAT(3,1),
        Long_Deg 	INTEGER(2),
	Long_Min	FLOAT(3,1),
	GMT	 	CHAR(1),
	Co_Code		CHAR(2),
	Co_Name		VARCHAR(60),
	F_Code		CHAR(3)
);
