use tortie_co_uk_db;

CREATE TABLE locationsTb (
	PCode1 		CHAR(4),
	XCoord 		INTEGER,
	YCoord 		INTEGER,
        Latitude 	DECIMAL(5,2),
        Longitude 	DECIMAL(5,2),
	Town_ukp	VARCHAR(48),
	County_ukp 	VARCHAR(48),
	Locality_lr	VARCHAR(48),
	District_lr	VARCHAR(48),
	Town_lr		VARCHAR(48),
	County_lr	VARCHAR(48)
);
