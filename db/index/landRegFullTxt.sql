ALTER TABLE tortie_co_uk_db.landRegTb
ADD FULLTEXT text_idx (PostCode1,PostCode2,Street,District,PAON,Town,Locality,County,SAON);
