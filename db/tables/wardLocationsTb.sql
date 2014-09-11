use tortie_co_uk_db;

CREATE TABLE wardLocationsTb (
	District	VARCHAR(44),
	Ward		VARCHAR(42),
	Latitude 	DECIMAL(5,3),
        Longitude 	DECIMAL(5,3),
	AveragePrice	FLOAT,
	AvFPrice	FLOAT,
	AvDPrice	FLOAT,
	AvTPrice	FLOAT,
	AvSPrice	FLOAT
);

