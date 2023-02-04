#!/usr/bin/env bash

# download/unpack shapefiles and upload into PostGIS
python3 setupDB.py

# load in michigan precinct file
# ogr2ogr -f "PostgreSQL" PG:"dbname=mi_precincts" "precincts20.geojson" -nln precincts20 -overwrite
ogr2ogr -f "PostgreSQL" PG:"dbname=mi_precincts" "precincts22.geojson" -nln precincts22 -overwrite

#...and CVAP zip file...
mkdir -p cvap_csv/downloads/
curl "https://www2.census.gov/programs-surveys/decennial/rdo/datasets/2020/2020-cvap/CVAP_2016-2020_ACS_csv_files.zip" -o "cvap_csv/downloads/CVAP.zip"
unzip cvap_csv/downloads/CVAP.zip -d cvap_csv/
iconv -f WINDOWS-1252 -t UTF8 cvap_csv/BlockGr.csv > cvap_csv/BlockGroup.csv

# create blockgroup->district intersection tables
psql mi_precincts -f intersections.sql

# load census data
for import in import*.sql; do
  psql mi_precincts -f $import;
done

# generate district population tables in ./output
mkdir -p output #creating output
for tables in *_pops.sql; do
  psql mi_precincts -f $tables;
done


