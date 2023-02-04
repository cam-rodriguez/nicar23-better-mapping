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
    sum((not_white + hisp_white) * overlap) as white,
    sum((not_black + hisp_black) * overlap) as black,
    sum((not_asian + hisp_asian) * overlap) as asian,
    sum((not_nhpi + not_aian + not_other + not_two_more 
        + hisp_nhpi + hisp_aian + hisp_other + hisp_two_more) 
        * overlap) as other,
    sum(hisp_lat * overlap) as hispanic,
    sum(not_hisp_lat * overlap) as nothispanic,

    -- total population -- 
    sum(pop.total * overlap) as total
    
  from areas22 as area, pop20 as pop, hisp20 as hisp

  where pop.geoid_long = area.geoid_long 
    and hisp.geoid_long = area.geoid_long

  group by precinct, area.mcd, area.county
);

\copy (select * from precinct_pop20 as pops) to 'output/precinct_pops20.csv' header csv;

----------
-- CVAP --
----------

drop view if exists precinct_cvap20 cascade;

create view precinct_cvap20 as (
  select 
    -- ids/geo --
    cvap.lntitle as title, -- has info about line item
    area.id as precinct, -- precinct ID in WP code
    area.county as county, -- COUNTYFIPS
    area.mcd as mcd, -- MCD (Minor Civil Divisions code) for muncipalities/townships

    -- population --
    sum(cvap.cit_est * overlap) as cit_est, -- estimated CIT[izens?]
    sum(cvap.cvap_est * overlap) as cvap_est -- estimated CVAP

  from cvap, areas22 as area

  where cvap.geoid = area.geoid_long

-- !!! group by will need to be different than NHGIS because of how the lntitle works !!!--
  group by precinct, cvap.lntitle, county, mcd

);

\copy (select * from precinct_cvap20 as cvaps) to 'output/precinct_cvaps22.csv' header csv;
\copy (select * from precinct_pop20 as pops) to 'output/precinct_pops22.csv' header csv;
