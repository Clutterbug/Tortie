select Date,PAON,Street,Town,PostCode1,PostCode2,Price
from landRegTb
where match(PostCode1, PostCode2,Street,Locality,District,Town,County)
against('+TW11' IN BOOLEAN MODE)
order by Date
