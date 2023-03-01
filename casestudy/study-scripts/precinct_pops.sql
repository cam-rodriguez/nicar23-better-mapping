-- ripped, etc
-- This tackles both values for NHGIS as well as CVAP, and exports them to separate files
-- should be 4752 values for NHGIS; for CVAP, it'll be 61776 (there are 13 lines per CVAP precinct)

-----------
-- NHGIS --
-----------

drop view if exists precinct_pop20 cascade;

create view precinct_pop20 as (
  select
    '2020' as year,
    -- id --
    id as precinct,
    area.mcd as mcd,
    area.county as county,

    -- population by race/ethnicity --
    sum(black * overlap) as black,
    sum(white * overlap) as white,
    sum(asian * overlap) as asian,
    sum(nhpi * overlap) as nhpi,
    sum(aian * overlap) as aian,
    sum(two_more * overlap) as twomore,
    sum(not_hispanic * overlap) as nothispanic,
    sum(hispanic * overlap) as hispanic,

    -- total population -- 
    sum(total * overlap) as total
    
  from areas22 as area, pop20 as pop

  where pop.geoid_long = area.geoid_long 
    and hisp.geoid_long = area.geoid_long

  group by precinct, area.mcd, area.county
);

\copy (select * from precinct_pop20 as pops) to 'output/precinct_pops.csv' header csv;

