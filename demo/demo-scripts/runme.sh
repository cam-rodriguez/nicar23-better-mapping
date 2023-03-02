#!/usr/bin/env bash

# set password


# download/unpack shapefiles and upload into PostGIS
python3 demo/demo-scripts/setupDB.py

# load in geom file file
# ogr2ogr -f "PostgreSQL" PG:"dbname=mi_precincts" "precincts20.geojson" -nln precincts20 -overwrite

# ogr2ogr -f "PostgreSQL" PG:"dbname=demo" "demo/demo-files/tracts20.json" -nln tracts20 -overwrite
# ogr2ogr -f "PostgreSQL" PG:"dbname=demo" "demo/demo-files/districts22.json" -nln distrcts22 -overwrite

# create tract->district intersection tables
psql demo -f demo/demo-scripts/intersections.sql

# load census data
for import in demo/demo-scripts/import*.sql; do
  psql demo -f $import;
done

# generate district population tables in ./output
mkdir -p demo/output #creating output
for tables in demo/demo-scripts/*_pops.sql; do
  psql demo -f $tables;
done


