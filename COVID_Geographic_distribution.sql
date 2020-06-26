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