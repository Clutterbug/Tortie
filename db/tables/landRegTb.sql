use tortie_co_uk_db;

CREATE TABLE landRegTb (
	TranId CHAR(36),
	Price DECIMAL(10,2),
	Date DATE,
	Postcode1 CHAR(4),
	Postcode2 CHAR(3),
	PropertyType CHAR(1),
	OldOrNew CHAR(1),
	Duration CHAR(1),
	PAON VARCHAR(48),
	SAON VARCHAR(48),
	Street VARCHAR(48),
	Locality VARCHAR(48),
	District VARCHAR(48),
	Town VARCHAR(48),
	County VARCHAR(48),
	RecordStatus CHAR(1)
) ENGINE MyISAM;
