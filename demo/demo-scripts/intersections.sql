-- shamelessly ripped from illinois_pop_trends_22

-- ** FOR 2022 DISTRICT GEOGRAPHY!!! ** --

drop table if exists areas22 cascade;

create table areas22 as (
  select 
    tracts.geoid as tract,
    districts.unsdlea as lea,
    districts.name as distname,
    districts.geoid as districts,
    st_area(st_intersection(tracts.geom, districts.geom)) / st_area(tracts.geom) as overlap
  from districts22 as districts, tracts20 as tracts
  where st_intersects(tracts.geom, districts.geom)
);

alter table areas22 add column geoid_long TEXT;
update areas22 set geoid_long = concat('1400000US', tract);

-- \copy (select * from areas22 as areas) to 'demo/output/overlaps.csv' header csv;
