select Date,PAON,Street,Town,PostCode1,PostCode2,Price,
match(PostCode1, PostCode2,Street,Locality,District,Town,County)
against('TW11 BROOM PARK') as relevance
from landRegTb
where match(PostCode1, PostCode2,Street,Locality,District,Town,County)
against('TW11 BROOM PARK')
