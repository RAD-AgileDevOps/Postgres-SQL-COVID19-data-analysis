
/* 
COVID19_analysis=# \d tbl_ecdc_datasets;
                                              Table "public.tbl_ecdc_datasets"
          Column           |         Type          | Collation | Nullable |                     Default
---------------------------+-----------------------+-----------+----------+--------------------------------------------------
 logid                     | integer               |           | not null | nextval('tbl_ecdc_datasets_logid_seq'::regclass)
 DateRep                   | date                  |           |          |
 Day                       | integer               |           |          |
 Month                     | integer               |           |          |
 Year                      | integer               |           |          |
 Cases                     | integer               |           |          |
 Deaths                    | integer               |           |          |
 Countries and territories | text                  |           |          |
 GeoId                     | character varying(50) |           |          |
Indexes:
    "tbl_ecdc_datasets_pkey" PRIMARY KEY, btree (logid)
Tablespace: "rdf"
 */


select "Countries and territories" ,  count("logid") , sum("Cases") as "Cases - Total" , sum("Deaths") as "Death Total"
from tbl_ecdc_datasets

group by rollup("Countries and territories")
order by "Countries and territories" asc
 ;
 
 
 -- 2020-06-24
 -- This is for ascertain carribean countries via lookup table
 select * from  tbl_ecdc_datasets  where "Countries and territories" in (select "caribbean_country" from tbl_caribbean_countries);
 
 
 -- updating the lookup table to match against the COVID Dataset
 
 COVID19_analysis=# select * from tbl_caribbean_countries cc left join tbl_ecdc_datasets as ecdc on cc.caribbean_country = ecdc."Countries and territories"
COVID19_analysis-# where ecdc."Countries and territories" is  null;
 
 
 select distinct("t.GeoId") , Countries and territories
 
 from
 
 (select * from tbl_caribbean_countries cc left join tbl_ecdc_datasets as ecdc on cc.caribbean_country = ecdc."Countries and territories"
 where ecdc."Countries and territories" is not  null ) as t;
 
 
 
 
 select distinct("GeoId") , "Countries and territories"
 
 from
 
 (select * from tbl_caribbean_countries cc inner join tbl_ecdc_datasets as ecdc on cc.caribbean_country = ecdc."Countries and territories"
 where ecdc."Countries and territories" is null ) as t;
 
 
update tbl_caribbean_countries
set geoid_caribn = 'AW'
where caribbean_country like 'Aruba';


update tbl_caribbean_countries
set geoid_caribn = 'BB'
where caribbean_country like 'Barbados';
 
 
update tbl_caribbean_countries
set geoid_caribn = 'AI'
where caribbean_country like 'Anguilla';


update tbl_caribbean_countries
set geoid_caribn = 'CU'
where caribbean_country like 'Cuba';

update tbl_caribbean_countries
set geoid_caribn = 'HT'
where caribbean_country like 'Haiti';
 
 
 
update tbl_caribbean_countries
set geoid_caribn = 'GD'
where caribbean_country like 'Grenada';
 
 
  -- GeoId | Countries and territories
-- -------+---------------------------
 -- MS    | Montserrat          (done)
 -- CO    | Colombia			(done)
 -- NI    | Nicaragua			(done)
 -- JM    | Jamaica				(done)
 -- CW    | Cura├ºao     		(done)
 -- DM    | Dominica			(done)
 -- HN    | Honduras             (done)
 -- AW    | Aruba
 -- BB    | Barbados			(done)
 -- AI    | Anguilla			(done)
 -- CU    | Cuba				(done)
 -- HT    | Haiti				(done)
 -- GD    | Grenada				(done)
-- (13 rows)








 
 select   distinct("Countries and territories",  "GeoId")
 
 from
 
 (select * from tbl_caribbean_countries cc inner join tbl_ecdc_datasets as ecdc on cc.caribbean_country = ecdc."Countries and territories"
 ) 	as t;
		
 
-- COVID19_analysis-# \d tbl_caribbean_countries
                                           -- Table "public.tbl_caribbean_countries"
        -- Column        |         Type         | Collation | Nullable |                        Default
-- ----------------------+----------------------+-----------+----------+--------------------------------------------------------
 -- logid                | integer              |           | not null | nextval('tbl_caribbean_countries_logid_seq'::regclass)
 -- caribbean_country    | text                 |           |          |
 -- country_of_ownership | text                 |           |          |
 -- geoid_caribn         | character varying(5) |           |          |
-- Indexes:
    -- "tbl_caribbean_countries_pkey" PRIMARY KEY, btree (logid)


 select   distinct "Countries and territories",  "GeoId"
 
 from
 
 (select * from tbl_caribbean_countries cc inner join tbl_ecdc_datasets as ecdc on cc.caribbean_country = ecdc."Countries and territories"
 ) 	as t
 order by "GeoId" Asc
 ;
	
	-- ascertaining those values in th elookup table that are on the COVID19 dataset i.e. the GeoId
	 
	
 select   distinct "Countries and territories",  "GeoId"
 
 from
 
 (select * from tbl_caribbean_countries cc right join tbl_ecdc_datasets as ecdc on cc.caribbean_country = ecdc."Countries and territories"
 ) 	as t
 
 where "caribbean_country" is null	
 order by "GeoId" Asc
 ;
 
 
                  ^
COVID19_analysis=# select * from tbl_caribbean_countries;
 logid |        caribbean_country         | country_of_ownership | geoid_caribn
-------+----------------------------------+----------------------+--------------
     1 | Antigua and Barbuda              | Independent          |
     6 | Dominican Republic               | Independent          |
     7 | Guadeloupe                       | France               |
     8 | Martinique                       | France               |
     9 | Saint Barth├⌐lemy                | France               |
    10 | Saint Martin (France)            | France               |
    17 | Caribbean Netherlands            | Netherlands          |
    18 | Sint Maarten                     | Netherlands          |
    20 | Saint Kitts and Nevis            | Independent          |
    21 | Saint Lucia                      | Independent          |
    22 | Saint Vincent and the Grenadines | Independent          |
    23 | Trinidad and Tobago              | Independent          |
    25 | British Virgin Islands           | United Kingdom       |
    26 | Cayman Islands                   | United Kingdom       |
    28 | Puerto Rico                      | United States        |
    29 | United States Virgin Islands     | United States        |
    30 | The Bahamas                      | Lucayan Archipelago  |
    31 | Turks and Caicos Islands         | Lucayan Archipelago  |
    27 | Montserrat                       | United Kingdom       | MS
     3 | Colombia                         | Independent          | CO
    19 | Nicaragua                        | Independent          | NI
    14 | Jamaica                          | Independent          | JM
    16 | Cura├ºao                         | Netherlands          | JM
     5 | Dominica                         | Independent          | DM
    13 | Honduras                         | Independent          | HN
    15 | Aruba                            | Netherlands          | AW
     2 | Barbados                         | Independent          | BB
    24 | Anguilla                         | United Kingdom       | AI
     4 | Cuba                             | Independent          | CU
    12 | Haiti                            | Independent          | HT
    11 | Grenada                          | Independent          | GD
(31 rows)



select distinct "GeoId" from tbl_ecdc_datasets

where   "Countries and territories"   ilike ('Domin%') or "Countries and territories"   ilike ('Antigua%')
OR
"Countries and territories"   ilike ('Guadeloupe%')
OR
"Countries and territories"   ilike ('Martinique%')

OR
"Countries and territories"   ilike ('Saint Bart%')
OR
"Countries and territories"   ilike ('Saint Martin%')
OR
"Countries and territories"   ilike ('Caribbean Netherlands%')
OR

"Countries and territories"   ilike ('Sint Maarten%')
or
"Countries and territories"   ilike ('Saint Kitts%')
OR
"Countries and territories"   ilike ('Saint Lucia%')

OR
"Countries and territories"   ilike ('Saint Vincent%')
OR
"Countries and territories"   ilike ('Trinidad%')

OR
"Countries and territories"   ilike ('British Virgin%')
OR
"Countries and territories"   ilike ('Cayman%')
OR
"Countries and territories"   ilike ('Puerto Rico  %')
 

OR
"Countries and territories"   ilike ('United States Virgin Islands%')

OR
  

"Countries and territories"   ilike ('The Bahamas%')


OR
  

"Countries and territories"   ilike ('Turks%')


 ;
 
 
 GeoId
-------
 TT
 AG
 DO
 DM
 TC
 KY
 
 
 
  
update tbl_caribbean_countries
set geoid_caribn = 'TT'
where caribbean_country ilike 'Trinidad%';


update tbl_caribbean_countries
set geoid_caribn = 'DO'
where caribbean_country ilike 'Dominican%';

update tbl_caribbean_countries
set geoid_caribn = 'AG'
where caribbean_country ilike 'Antigua%';

update tbl_caribbean_countries
set geoid_caribn = 'DM'
where caribbean_country ilike 'Dominica';




update tbl_caribbean_countries
set geoid_caribn = 'KY'
where caribbean_country ilike 'Cayman%';

update tbl_caribbean_countries
set geoid_caribn = 'TC'
where caribbean_country ilike 'Turks%';

Turks
 
 
 
 
 
 