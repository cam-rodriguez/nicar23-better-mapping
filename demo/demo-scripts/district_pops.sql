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
    area.tract as tract,
    area.distname as distname,
    area.lea as lea,
    area.districts as district,

-- population --
    sum(total * overlap) as total,

-- pop by race --
    sum(white * overlap) as white,
    sum(black * overlap) as black,
    sum(aian * overlap) as aian,
    sum(asian * overlap) as asian,
    sum(nhpi * overlap) as nhpi,
    sum(other * overlap) as other,
    sum((twomore + twomore_excl + threemore) * overlap) as multi,

-- housing --
    sum(housing * overlap) as units
    
  from areas22 as area, pop20 as pop

  where pop.geoid_long = area.geoid_long 

  group by distname, lea, district, tract
);

\copy (select * from precinct_pop20 as pops) to 'demo/output/precinct_pops-demo.csv' header csv;
