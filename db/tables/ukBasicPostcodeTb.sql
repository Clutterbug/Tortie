use tortie_co_uk_db;

CREATE TABLE ukBasicPostcodeTb (
	PCode1 		CHAR(4),
	XCoord 		INTEGER,
	YCoord 		INTEGER,
        Latitude 	DECIMAL(5,2),
        Longitude 	DECIMAL(5,2),
	Town 		VARCHAR(48),
	County 		VARCHAR(48)
);
