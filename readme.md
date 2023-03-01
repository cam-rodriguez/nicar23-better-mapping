# Let's make mapping better!
### _a NICAR23 class on troubleshooting, tips and tricks with geospatial projects_

<!-- (structures for the repo:
* sort by case study and demo?
* sort by data and scripts?) -->

## case study
* study-files
    * 2020 census blocks (michigan only, downloaded from census ftp!)
    * 2022 voting precincts (michigan only, geojson)
    * 2020 nhgis data (truncated population acs table, csv)
* study-scripts
    * runme.sh (runs the whole dang thing)
    * setupdb.py (sets the whole dang thing up)
    * import query (imports the nhgis population data)
    * intersections query (imports and intersects the spatial data to generate an overlap)
    * precinct pops query (weighting the data against the overlap value to apportion it properly!)
* output
    * precinct_pops.csv (after running script — it's your file with weighted values)
    * overlaps (for QA purposes — you can see what the degree of overlap there is for each value!)


## demo
* demo-files
    * 2020 census tracts (tennessee)
    * 2022 school districts (unified, tennessee)
    * 2020 population and housing data (2016-2020 ACS 5-year estimate)
* demo-scripts
    * runme.sh (to run it all in the CLI!)
    * setupdb.py (to set up the demo db!)
    * import query (to import the population data)
    * intersections query (to get the overlap between tracts and districts)
    * district pops (weighting + outputting)

## sandbox
* data
    * sample data (TRI, beer permits, etc)
