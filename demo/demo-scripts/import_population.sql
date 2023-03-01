-- importing the different population and housing variables into the database!
-- should have 1701 values

drop table if exists pop20 cascade;

create table pop20 (
    GISJOIN TEXT,
    YEAR TEXT,
    STUSAB TEXT,
    STATE TEXT,
    STATEA TEXT,
    COUNTY TEXT,
    COUNTYA TEXT,
    TRACTA TEXT,
    GEOID TEXT,
    NAME TEXT,
    total NUMERIC, -- total population
    white NUMERIC, -- start of population by race
    black NUMERIC,
    aian NUMERIC,
    asian NUMERIC,
    nhpi NUMERIC,
    other NUMERIC,
    twomore NUMERIC,
    twomore_excl NUMERIC,
    threemore NUMERIC, -- end of population by race
    housing NUMERIC -- amount of housing units
);


\copy pop20 from 'demo/demo-files/nhgis_1620_race_housing_acs.csv' csv header;


alter table pop20 add column geoid_long TEXT;
update pop20 set geoid_long = replace(GEOID, '14000US', '1400000US');