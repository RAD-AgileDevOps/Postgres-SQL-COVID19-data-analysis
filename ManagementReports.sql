
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

create    view  carribean_covid_report as(
select "Countries and territories" , count("logid")as num_count , sum("Deaths") as tot_Deaths

from 

(select *  from  tbl_ecdc_datasets
where  "GeoId" in (select "geoid_caribn" from tbl_caribbean_countries)) as R

group by rollup(r."Countries and territories")
order by r."Countries and territories"  
);