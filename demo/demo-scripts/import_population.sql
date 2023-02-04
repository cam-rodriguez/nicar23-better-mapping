-- ripped
-- 2020 population total

drop table if exists pop20 cascade;

create table pop20 (
    gisjoin TEXT,
    year TEXT,
    stusab TEXT,
    state TEXT,
    statea TEXT,
    county TEXT,
    countya TEXT,
    tracta TEXT,
    blkgrpa TEXT,
    geoid TEXT,
    name TEXT,
    bttra TEXT,
    btbga TEXT,
    total NUMERIC
);


\copy pop20 from 'census_csv/2020_nhgis_mi_bg_pop.csv' csv header;


alter table pop20 add column geoid_long TEXT;

update pop20 set geoid_long = replace(geoid, '15000US', '1500000US');