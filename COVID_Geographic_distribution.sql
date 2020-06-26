-- 1 create backup dataset

do $$ begin execute format('create table "tbl_ecdc_datasets_%s" AS   (select *  from tbl_ecdc_datasets)',now()); end; $$;

-- 2. delete existing date from base table in Postegres server
delete from tbl_ecdc_datasets;

-- 3. Migrate the updated dataset to Postgres Database
copy tbl_ecdc_datasets FROM  'C:\Databases\PostgreSQL\COVID19_DATA_ANALYSIS\ecdcCOVID19_20200626.csv' CSV HEADER   ENCODING 'UTF8' ;



-- 4. Run summary reports

REPLACE    view  carribean_covid_report as(
select "Countries and territories" , count("logid")as num_count , sum("Deaths") as tot_Deaths

from  

(select *  from  tbl_ecdc_datasets
where  "GeoId" in (select "geoid_caribn" from tbl_caribbean_countries)) as R

group by rollup(r."Countries and territories")
order by r."Countries and territories"  
);


select * from carribean_covid_report ;
 
 /*
sample output:
 
 (N.B. CMD - the Windows command line )
 
CMD> psql -U postgres -d COVID19_analysis -f C:\Databases\PostgreSQL\COVID19_DATA_ANALYSIS\DATA_ENTRY_TOOLS\COVID_Geographic_distribution.sql
Password for user postgres:
DO
DELETE 25935        -- the no. of records deleted from the ecdc table
COPY 25935          -- Records imported into Postgres Using the COPY command : copies thousands of records from an external csv file
 
CREATE VIEW         -- the VIEW object: 'carribean_covid_report' [see above]
 
-- Summary report of no. of Cocid cases in each Caribbean country, and related deaths
 
    Countries and territories     | num_count | tot_deaths
----------------------------------+-----------+------------
 Anguilla                         |        92 |          0
 Antigua_and_Barbuda              |        99 |          3
 Aruba                            |        96 |          3
 Bahamas                          |       101 |         11
 Barbados                         |       101 |          7
 British_Virgin_Islands           |        92 |          1
 Cayman_Islands                   |        99 |          1
 Colombia                         |       108 |       2654
 Cuba                             |       104 |         85
 Dominica                         |        96 |          0
 Dominican_Republic               |       170 |        698
 Grenada                          |        96 |          0
 Haiti                            |        99 |         96
 Honduras                         |       105 |        426
 Jamaica                          |       106 |         10
 Montserrat                       |        97 |          1
 Nicaragua                        |       100 |         74
 Puerto_Rico                      |        91 |        151
 Saint_Kitts_and_Nevis            |        93 |          0
 Saint_Lucia                      |       104 |          0
 Saint_Vincent_and_the_Grenadines |        95 |          0
 Trinidad_and_Tobago              |       106 |          8
 Turks_and_Caicos_islands         |        94 |          1
 United_States_Virgin_Islands     |        94 |          6
                                  |      2438 |       4236
(25 rows)
 
 */
