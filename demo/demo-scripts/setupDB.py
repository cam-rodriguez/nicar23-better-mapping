# shamelessly ripped from illinois_pop_trends_22 repo

import os
import http
from urllib.parse import urlparse

# set up database
os.system("dropdb demo; createdb demo")
os.system("psql demo -c \"create extension postgis;\"")

# Setup variables
CRS = "4326"
downloads = {
  "tracts20": "https://www2.census.gov/geo/tiger/TIGER2020/TRACT/tl_2020_47_tract.zip", # 2020 census tracts for tennessee
  "districts22": "https://www2.census.gov/geo/tiger/TIGER2022/UNSD/tl_2022_47_unsd.zip" # 2020 unified school districts for tennessee
}

os.system("mkdir -p demo/shapefiles/downloads")
for (table, url) in downloads.items():
  file = table + ".zip"
  # get shapefiles if they don't exist
  if not os.path.exists("demo/shapefiles/downloads/%s" % file):
    print("Downloading %s file..." % table);
    print("curl %s -o demo/shapefiles/downloads/%s" % (url, file))
    os.system("curl \"%s\" -o demo/shapefiles/downloads/%s" % (url, file))
    os.system("unzip demo/shapefiles/downloads/%s -d demo/shapefiles/%s" % (file, table))

  # load into the DB
  # -D uses dump format
  # -I creates an index
  shapefiles = [f for f in os.listdir("demo/shapefiles/%s" % table) if os.path.splitext(f)[1] == ".shp"]
  shapefile = shapefiles[0]
  os.system("shp2pgsql -DI -s %s demo/shapefiles/%s/%s %s | psql dbname=demo " % (CRS, table, shapefile, table))