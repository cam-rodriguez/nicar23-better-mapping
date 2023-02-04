-- shamelessly ripped from illinois_pop_trends_22

-- ** FOR 2022 PRECINCT GEOGRAPHY!!! ** --

drop table if exists areas22 cascade;

create table areas22 as (
  select 
    blocks.geoid as blockgroup,
    precinctid as id,
    precincts22.name as name,
    precincts22.countyfips as county,
    precincts22.mcdfips as mcd,
    st_area(st_intersection(blocks.geom, precincts22.wkb_geometry)) / st_area(blocks.geom) as overlap
  from precincts22, bg20 as blocks
  where st_intersects(blocks.geom, precincts22.wkb_geometry)
);

alter table areas22 add column geoid_long TEXT;
update areas22 set geoid_long = concat('1500000US', blockgroup)


-- ** FOR 2020 PRECINCT AND BG GEOGRAPHY !! ** --
-- intersecting 2020 precincts with 2020 blocks and 2020 counties

-- drop table if exists areas20 cascade;

-- create table areas20 as (
--   select 
--     blocks.geoid as blockgroup,
--     precinctid as id,
--     precincts20.name as name,
--     precincts20.countyfips as county,
--     precincts20.mcdfips as mcd,
--     st_area(st_intersection(blocks.geom, precincts20.wkb_geometry)) / st_area(blocks.geom) as overlap
--   from precincts20, bg20 as blocks
--   where st_intersects(blocks.geom, precincts20.wkb_geometry)
-- );

-- alter table areas20 add column geoid_long TEXT;
-- update areas20 set geoid_long = concat('15000US', blockgroup)
