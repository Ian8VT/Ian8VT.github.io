### Outline

In this lab, I tried to learn some basic network analysis functions in PostGIS using the pgrouter extension. To learn the functions, I performed my analyses on data of Dar es Salaam, Tanzania, and attempted to create a network topology map around a school in the city. My objective was obtain the total walking time from each node in the topology and then find the average walking time for all nodes within wetlands and compare to all nodes outside of wetlands. However, during the process, I ran into a series of problems which proved severe enough to prevent me from completing this project goal. I will outline the difficulties that I encountered below.

### Data Sources and Platforms

I used three layers of OpenStreetMap data in Dar es Salaam for this lab: wetlands; roads; schools. I accessed all three of these layers from Resilience Academy through a WFS connection in QGIS. From the QGIS interphase, I uploaded the layers to my PostGIS database and performed the functions of this lab. Within the database, I used the pgrouting extension in addition to standard functions. One of the three layers, wetlands, I already had within my database from a previous [lab](../lab_5/). I originally created this layer by directly downloading OpenStreetMap polygon data and selecting terrain designated as wetlands. 

I chose to use the school polygon feature rather than the school point feature of Resilience Academy's data. Through a comparison of the two features in QGIS, I noticed that the layers do not always line up. When I viewed each layer in comparison to OpenStreetMap, I noticed that some school point locations overlay locations not designates as a school in the OSM baselayer. While, on the otherhand, the school polygon layer was more agreeable with the baselayer.

### Methods

I first uploaded my layers from QGIS into the PostGIS database while transforming into EPSG:32737, or UTM 37S. Then, I examined my layers in a map view and determined which school to select as the basis of my analysis. I chose a school which had a significant amount of road data in the area and contained a moderate amount of wetlands near the location. Further, since the attribute table of the schools was not complete enough to list school names and type of school, I opened a OSM baselayer to ensure that the school I selected was a primary school.

My first phase of steps involved limiting the scope of road and wetland data considered. I decided to establish a 1km buffer around the selected school and exclude all data not within this buffer zone. In order to define the center of the buffer zone, I decided to establish a point at the location of what most likely appeared as the school's entrance. I made this determination through the examination of imagery on GoogleMaps.

I first turned all the vertices of the school polygon into points
```sql
create table school_vertices as
select st_dumppoints(geom) as geom
from dar_schools
where id ='way/370703018'
```

The output was not in a well-known text format, so I converted the information into the proper format and turned it into a point on the map. This step was where I encountered my first difficulties. I wanted to convert all the vertices into a mappable point and then select by attribute my desired point, but was unable to determine the correct syntax of functions to do so. I attempted commands with a variety of different functions, such as st_collect, st_astext, st_pointfromtext, st_asewkt, st_geomfromewkt, st_makepoint. However, in the end, I chose to manually input the text of each vertice into the following format until I received my intended point. Since the polygon of the school only had six vertices, this was not a problem.
```sql
create table school_entry as
select row_number() OVER () AS id,
st_pointfromtext(
st_astext('0101000020E17F00001F4CF8AA271920419D22256AD5A26141'),32737) as geom
```
