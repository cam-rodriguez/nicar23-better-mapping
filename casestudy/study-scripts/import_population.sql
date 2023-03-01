-- 2020 population imports! --
-- lovingly crafted by the team at chalkbeat: thomas wilburn, cam rodriguez & kae petrin <3 --
----------------------------------------------------------------------------------------------
-- what we're doing here is importing the data of our choice: in this case, ACS 5-year population estimates for
-- block groups in michigan, **TKTKTKTKTKKTKT** 
----------------------------------------------------------------------------------------------

-- if the table already exists (ie, if we've run this already), then it'll drop the table!
drop table if exists pop20 cascade;

-- and here we make the table: it's named pop20 (2020 population) and we define the different field names below
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
    total NUMERIC,
    black NUMERIC,
    white NUMERIC,
    asian NUMERIC,
    nhpi NUMERIC,
    aian NUMERIC,
    two_more NUMERIC,
    not_hispanic NUMERIC,
    hispanic NUMERIC
);

-- this pulls the data from the file that we designate!
\copy pop20 from 'casestudy/study-files/mi_bg_hisp_2020.csv' csv header;

-- this is adjusting the data to accommodate any discrepancies with geoids, which are unique identifiers set by the census.
-- sometimes, geoids and gisjoins (used by nhgis) can be a little off, so this just corrects it.
alter table pop20 add column geoid_long TEXT;

update pop20 set geoid_long = replace(geoid, '15000US', '1500000US');