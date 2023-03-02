# shamelessly ripped from illinois_pop_trends_22 repo

import os
import http
from urllib.parse import urlparse

# set up database
# os.system("dropdb mi_precincts; createdb mi_precincts")
os.system("psql mi_precincts -c \"create extension postgis;\"") #tk

# Setup variables
CRS = "4326"
downloads = {
#   "bg10": "https://www2.census.gov/geo/tiger/TIGER2010/BG/2010/tl_2010_26_bg10.zip",
  "bg20": "https://www2.census.gov/geo/tiger/TIGER2020/BG/tl_2020_26_bg.zip",
  # "counties20": "https://www2.census.gov/geo/tiger/TIGER2022/COUNTY/tl_2022_us_county.zip"
}

os.system("mkdir -p casestudy/study-files/shapefiles/downloads")
for (table, url) in downloads.items():
  file = table + ".zip"
  # get shapefiles if they don't exist
  if not os.path.exists("casestudy/study-files/shapefiles/downloads/%s" % file):
    print("Downloading %s file..." % table);
    print("curl %s -o casestudy/study-files/shapefiles/downloads/%s" % (url, file))
    os.system("curl \"%s\" -o casestudy/study-files/shapefiles/downloads/%s" % (url, file))
    os.system("unzip casestudy/study-files/shapefiles/downloads/%s -d casestudy/study-files/shapefiles/%s" % (file, table))

  # load into the DB
  # -D uses dump format
  # -I creates an index
  shapefiles = [f for f in os.listdir("casestudy/study-files/shapefiles/%s" % table) if os.path.splitext(f)[1] == ".shp"]
  shapefile = shapefiles[0]
  os.system("shp2pgsql -DI -s %s casestudy/study-files/shapefiles/%s/%s %s | psql dbname=mi_precincts " % (CRS, table, shapefile, table))