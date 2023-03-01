-- intersecting census geography with irregular geography, aka creating crosswalks --
-------------------------------------------------------------------------------------
-- here, what we'll do is create a table with the values that we want outputted, then include an overlap value:
-- the overlap value is a percentage of the overlap of one shape with another. (don't believe me? you can output the overlap
-- and do a visual spot check for yourself in a program like qgis!) if we assume that things are distributed equally throughout
-- a geography, especially something like a block group, which is kind of tiny, then we can subdivide that accordingly
-- and adjust the variables to be weighted based on how the shapes intersect with each other.
-------------------------------------------------------------------------------------

drop table if exists areas22 cascade;

create table areas22 as (
  select 
    blocks.geoid as blockgroup,
    precinctid as id,
    precincts22.name as name,
    precincts22.countyfips as county,
    precincts22.mcdfips as mcd,
    -- this is the overlap!
    st_area(st_intersection(blocks.geom, precincts22.wkb_geometry)) / st_area(blocks.geom) as overlap
  from precincts22, bg20 as blocks
  -- and part of the overlap as well!
  where st_intersects(blocks.geom, precincts22.wkb_geometry)
);

alter table areas22 add column geoid_long TEXT;
update areas22 set geoid_long = concat('1500000US', blockgroup)

\copy (select * from areas22 as areas) to 'casestudy/output/overlap.csv' header csv;


