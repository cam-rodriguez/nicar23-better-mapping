#!/usr/bin/env bash

# download/unpack shapefiles and upload into PostGIS
python3 setupDB.py

# load in michigan precinct file
ogr2ogr -f "PostgreSQL" PG:"dbname=mi_precincts" "casestudy/study-files/precincts22.geojson" -nln precincts22 -overwrite

# create blockgroup->district intersection tables
psql mi_precincts -f casestudy/study-scripts/intersections.sql

# load census data
for import in casestudy/study-scripts/import*.sql; do
  psql mi_precincts -f $import;
done

# generate district population tables in ./output
mkdir -p output #creating output
for tables in casestudy/study-scripts/*_pops.sql; do
  psql mi_precincts -f $tables;
done


