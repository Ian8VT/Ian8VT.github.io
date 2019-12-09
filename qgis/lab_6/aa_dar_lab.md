## Wetland Drains in Dar es Salaam, Tanzania

Return to [QGIS and PostGIS Index Page](../qgis.md).

Return to [Main Index Page](../../index.md).

### Introduction
Dar es Salaam, Tanzania, is a highly mapped city on OpenStreetMap as a result of a number of [urban resiliency](https://www.worldbank.org/en/news/feature/2018/02/14/next-generation-of-youth-in-tanzania-to-be-equipped-with-critical-skills-in-urban-resilience) projects. This provides a unique opportunity to conduct a number of different geospatial analyses related to the city. [Ramani Huria](http://ramanihuria.org/), a community-based mapping project in the city, accesses this vast array of geospatial data to draw attention to the presence of damaging seasonal floods in the city. As Ramani Huria notes, these flooding events are often compounded by a lack of necessary infrastructure and city planning. Further, there are a large number of structures and settlements in the city that are built on terrain designated as wetland - locations expected to be highly suscpetible to flood disturbances.

In this lab, I measured the density of drains within designated wetlands. The purpose of this is to acquire a measurement which is representative of how well equipped these wetland settlements are to remain resilient in the face of flooding disturbances. I represented  wetland drain density by comparing the length of drains to the footprint area of buildings. In other words, I chose to demonstrate the density of drains in wetland settlement areas by measuring how many meters of drain there is per square meter of building. As such, all of my measurements occur solely within terrain designated as wetland and does not consider drain density outside of this terrain designation. Further, I chose to bound all the wetlands by subward, a local political boundary unit in the city. At the end of the analysis, I presented the data in the form of a [Leaflet](https://leafletjs.com/) map.
#### Explaining Results Format
As a final result, each subward has a single decimal number. This number represents how many meters of drain there is per square meter of building within the wetlands of that subward. For example, a result of 1 would mean that for every 1 square meter of building in that subward's wetland, there is 1 meter of drain. A result of .05 would mean that for every 1 square meter of building, there is 1/20 meter of drain. The final results of subward drain density in wetlands range from a measurement of .00066 as the lowest drain density to .9 as the highest drain density. As such, the subward with the lowest density of wetland drains contains .66 milimeters of drain for every square meter of building. The subward with the highest density of wetland drains contains 9/10 meter for every square meter of building. The greater the drain density, the greater the coverage of drains there is to alleviate flooding pressures from its surrouning buildings. As a result of previously stated peramaters, only subwards which contain wetlands and intersect drain data are presented in the final data. All other subwards are omitted from the final data and map.

### Data Sources
For this lab, I relied upon three input layers: wetland and building multipolygons; subward multipolygons; drain multilines. For all of these data layers, I used data from OpenStreetMap. For my wetland and building data, I downloaded the world polygon layer directly from [OpenStreetMap](https://www.openstreetmap.org/#map=16/31.9715/35.8944&layers=D) with my desired geographic parameters. I accessed my OSM subward and drain layers via [Resilience Academy](https://resilienceacademy.ac.tz/). I uploaded these datasets onto a [PostGIS](https://postgis.net/) database and conducted my SQL analysis on this database via the [QGIS](https://qgis.org/en/site/) interphase. Prior to uploading the datasets onto PostGIS, I used the converter tool [osm2pgsql](https://wiki.openstreetmap.org/wiki/Osm2pgsql) to convert the OpenStreetMap data into the proper format necessary for the PostGIS database. I presented my final results as a map using [Leaflet](https://leafletjs.com/) software and prepared my data for this format with the QGIS conversion plugin of [QGIS2Web](https://www.qgistutorials.com/en/docs/web_mapping_with_qgis2web.html).

All of my data sources and software that I used in this lab are entirely open-source. As such, anyone with internet access and a computer with enough processing power to operate QGIS is not only able to perform this lab, but also pursue other research questions related to the urban resiliency of Dar es Salaam. Further, displaying the final map on Leaflet increases the accessibility of my results to include those who only have a mobile device and not a computer.

### Steps of Analysis
1) The first set of steps consisted of creating a layer of building polygons and a layer of wetlands. I selected 'wetlands' from the 'natural' column in the original OSM polyogn feature as well as all features that were not 'null' in the 'building' attribute column. I transformed their projection, I calculated the area of the features in the unit of the new projection, and then split them into their own layers. When I made buldings its own layer, I only selected buildings which intersected with the new wetlands layer. I displayed this map in the Annotated SQL Workflow under the series of SQL steps which created the map.

2) The second stage of steps established a layer of wetlands in which the feature is defined by subward. I first intersected the wetland layer with the second starting input of the analysis, the subwards polygon feature. This drew the subward boundary lines onto the wetland features and applied the unique ID of subwards onto the wetlands that intersect each respective subward. I then dissolved all wetland features which contain the same subward ID value as a single geoemtry so that all wetland terrain within the same subward, even if disjointed and not connected, will be considered the same polygon feature. I provided an example map of this output in the Annotated SQL Workflow below. I forgot to sum the areas of each wetland features when I unioned them together, but simply recalculated wetland area in a subsequent step.

3) In this phase of steps I created a new subward layer of only subwards that contain drain line data and intersect wetlands. I intersected the drain input data with the subwards and pulled a new layer out of subwards which fully intersect drains. I then intersected this new subward layer with the wetland layer and further pulled the subwards that intersect wetlands into a new layer. This output, which I provided a map of in the SQL Workflow, ony features subwards which contain drain data and intersect wetlands.

4) For this step I dissolved all building polygons that are within the same subward into a single geometry. I first intersected the subward layer onto the layer of buildings in wetlands. This applied the subward boundaries onto the building layer and provided each building polygon with the ID of the subward it is within. Similar to the processes of step 2, I then dissolved all buildings which contain the same subward ID into a single geometry. This map is provided in the SQL Workflow.

5) In this step, I prepared the drain data for the upcoming calculations. I intersected the drain multiline layer with the wetlands dissolved by subward layer. Only drain segments which fully intersected these wetlands, and not came to an end at the boundary of wetlands, was included in the new layer of wetland drains. This action also applied the subward IDs onto the drain segments which I then used to dissolve all drain segments with the same subward ID into a single geometry. I originally calculated the length of drains in step 3, which I merely summed in the recent dissolve action, but it would have required less computational energy if I calculated the drain length immediately prior to dissolving the drains by subward and after I made wetland drains its own layer.

6) In the final set of steps, I calculated the density of wetland drains and applied an internal quantile ranking system into the data. I also streamlined my final result table to only include necessary columns in preparation for the display of my results on Leaflet. Additionally, I turned my bounded wetlands into a single geometry in preparation for Leaflet. The link to the final map is provided in the Results section.

### Annotated SQL Analysis Workflow
#### With Maps of Selected Steps

```sql
SQL analysis developed by Ian8VT

CREATE TABLE dar_polygons AS
SELECT osm_id AS id, building, "natural", st_transform(way,32737) AS way, way_area
FROM planet_osm_polygon
WHERE building IS NOT NULL OR "natural" IS NOT NULL
/* Creates a new table from the input OSM polygon data. Five columns are selected from the input to the 
new table: polygon id; building type; natural feature type; way(in this feature, multipolygon); area of 
that way. The coordinate reference system is simultaneously transformed from the OSM default to the UTM 
projection for Dar es Salaam. */

UPDATE dar_polygons
SET way_area = st_area(way)
/* This ensures that the calculated area of the way_area column is in the correct unit of measurement for 
the new UTM projection, which is meters. */

CREATE TABLE wetlands AS
SELECT id, "natural" AS wetland, way, way_area
FROM dar_polygons
WHERE "natural" = 'wetland'
/* Creates a new table of just polygons that are recorded as wetland. The polygon id, way, and way_area 
of these wetland polygons are also selected for the new table. */

ALTER TABLE dar_polygons ADD COLUMN building_presence INTEGER
/* Adds a new column to the polygon table. This is in preparation for the next step, for which the 
results will be a whole number (either 0 or 1), so I designated that this table will contain data 
in the integer format.  */

UPDATE dar_polygons
SET building_presence = 1
WHERE building IS NOT NULL
/* Inserts a value of 1 in the new column created last step for every polygon mapped as a building 
irregardless of terrain. */

ALTER TABLE dar_polygons ADD COLUMN building_wetland INTEGER
/* Adds a new column to the polygon table in preparation for the next step. Again, the resulting data 
will be in the whole number-integer format. */

UPDATE dar_polygons
SET building_wetland = 1
FROM wetlands
WHERE st_intersects(dar_polygons.way, wetlands.way)
/* Sets a value of 1 in the previously created column for each polygon in the table that intersects 
a wetland irregardless of polygon type. */

CREATE TABLE building_wetlands AS
SELECT id, building, way, way_area
FROM dar_polygons
WHERE building_wetland = 1 AND building_presence = 1
/* Compares the integers from the two recently added columns to creates a new table of only building
polygons that are present in wetlands.  */

```

![building_wetlands](/qgis/lab_6/building_wetlands.png)

This is the map of the building_wetlands table created in the previous SQL step. As you can see, only the buildings that are present within wetlands are included in the output data. In this map, each individual building as its own unique ID.  

```sql

CREATE VIEW intersection AS
SELECT row_number() OVER () AS id, wetlands.way, subwards.fid, subwards.way AS sub_way,
(st_intersection(wetlands.way,subwards.way))
FROM wetlands 
INNER JOIN subwards ON st_intersects(wetlands.way, subwards.way)
/* This creates a new layer of wetlands bounded by subward boundaries. This is the first appearance 
of the subward polygon layer in the workflow. Each disjointed wetland within a single subward are 
considered indepedent polygons and previously continuous wetland polygons that cross a subward 
boundary are now considered indepdent polygons. Each new feature has a unique id, lists the wetland 
way, the subward id that the wetland is in, and the subward way. */

CREATE TABLE wetland_subward AS
SELECT fid, st_union(intersection.st_intersection) AS wetland_subward
FROM intersection
GROUP BY fid
/* This takes the previously created layer and dissolves all disjointed wetlands within the same 
subward as a single polygon. */

ALTER TABLE wetland_subward ADD COLUMN area FLOAT
/* Adds a new column in the table in preparation for the next step, the results of which will be 
a decimal number (float data point) */

UPDATE wetland_subward
SET area = st_area(wetland_subward)
/* Calculates the area of all the wetlands within each subward */

```

![wetland_subward](/qgis/lab_6/wetland_subward_1.png)

This map portrays the wetland_subward table created in the previous SQL step. In this map, all of the wetland polygons that are within the same subward contain the same unique ID. As an example, I shaded the wetlands of Subward ID 91 to be a a shade of teal. As you can see, even though the components to this wetland are disjointed, they are the same polygon.

```sql

ALTER TABLE drains ADD COLUMN length FLOAT
/* Adds a new column in the table in preparation for the next step, the results of which will be 
a float. This is the first appearance of the drain layer in the analysis */

UPDATE drains SET length = st_length(way)
/* Calculates the length of the drains */

ALTER TABLE subwards ADD COLUMN sub_drains INTEGER
/* Adds an integer column for the next step */

UPDATE subwards
SET sub_drains = 1
FROM drains
WHERE st_intersects(drains.way, subwards.way)
/* Sets a value of 1 in the newly created column for subward polygons that intersect with drain 
lines. */

CREATE TABLE subwards_drains AS
SELECT fid, way, sub_drains
FROM subwards
WHERE sub_drains = 1
/* Creates a new table of only subwards that contain mapped drains. */

ALTER TABLE subwards_drains ADD COLUMN wetland INTEGER
/* Adds a new integer column in preparation for the next step */

UPDATE subwards_drains
SET wetland = 1
FROM wetland_subward
WHERE (st_intersects(wetland_subward.wetland_subward, subwards_drains.way)
AND NOT st_touches(wetland_subward.wetland_subward, subwards_drains.way))
/* Sets a value of 1 for subwards that intersect wetlands and not just touch wetlands */

CREATE TABLE subwards_drains_wet AS
SELECT fid, way, wetland
FROM subwards_drains
WHERE wetland = 1
/* Creates a table of subwards that intersect with wetlands. Since the input table was subwards 
that contain drains, this new table is of subwards that contain both drains and wetlands, 
though does not require the drains to be in wetlands. */

```

![subwards_drains_wet](/qgis/lab_6/subwards_drains_wet.png)

This is a map of the subwards_drains_wet table created in the previous step. The step created a table in which the output only consists of subward polygons that intersect with drain data and contain wetlands. Subwards that do not meet this qualification are excluded from the output and will not be considered in further analysis.

```sql

:: ERROR Invalid Geometry, Geometry Intersects WITH Self
:: SELECT row_number() OVER () AS id,
:: (st_intersection(building_wetlands.way, wetland_subward.wetland_subward)),
:: building_wetlands.osm_id, building_wetlands.way, building_wetlands.way_area, 
:: wetland_subward.fid, wetland_subward.wetland_subward, wetland_subward.area
:: FROM building_wetlands
:: LEFT JOIN wetland_subward ON st_intersects(building_wetlands.way, 
:: wetland_subward.wetland_subward)

CREATE TABLE wetland_subwards_corrected AS
SELECT fid, area, st_makevalid(wetland_subward) AS way
FROM wetland_subward
/* Edits the layer to correct the simple errors in the geometry features */

CREATE TABLE building_wet_sub AS
SELECT row_number() OVER () AS id,
(st_intersection(building_wetlands.way, wetland_subwards_corrected.way)) AS way,
building_wetlands.osm_id, building_wetlands.way AS building_way, 
building_wetlands.way_area AS building_area, wetland_subwards_corrected.fid, 
wetland_subwards_corrected.way AS wetland_way, 
wetland_subwards_corrected.area AS wetland_area
FROM building_wetlands
LEFT JOIN wetland_subwards_corrected ON st_intersects(building_wetlands.way, 
wetland_subwards_corrected.way)
/* Creates a new table where the wetland buildings and bounded by subwards. Each 
building within each subward has its own unique id */

CREATE TABLE building_area_sub AS
SELECT fid, st_union(building_wet_sub.building_way) AS buildings, 
sum(building_wet_sub.building_area) AS building_area
FROM building_wet_sub
GROUP BY fid
/* Dissolves all wetland buildings by subward so that all wetland buildings within the 
same subward are a single polygon. This step is fine for further analysis, but must be 
redone for a final display deliverable as this output contains all wetland buildings 
within all the subwards of the initial input, not just those subwards with mapped wetland 
and drain data*/

```

![building_area_sub](/qgis/lab_6/building_area_sub.png)

This is a map of the building_area_sub table created in the previous step. Although this visually appears similar to the building_wetlands table in which I provided a map of previously, the internal data of this table is very different. In this table, all of the buildings which are present within the same subward are now a single multipolygon. As such, the number of building IDs is the same as the number of subwards which contain wetlands. To visualize this, I shaded the building multipolygon of Subward 91 bright green. As you can see, all buildings that are within this subward are the same multipolygon geometry.

```sql

CREATE TABLE drain_wet AS
SELECT st_multi(st_intersection(a.way,b.wetland_subward)) AS drain_wet, a.fid AS drain_fid, 
a.way AS drain_way, a.length AS drain_length, b.fid AS wet_fid, b.wetland_subward AS wet_way, 
b.area AS wet_area
FROM drains AS a
INNER JOIN wetland_subward AS b
ON (st_intersects(a.way, b.wetland_subward)
AND NOT st_touches (a.way, b.wetland_subward))
/* Creates a table of only the drain line segments that are within wetlands. The drain must 
fully intersect the wetland polygon and not just touch the boundary. */

CREATE TABLE drains_sub AS
SELECT wet_fid, st_union(drain_wet.drain_wet) AS drains_way, sum(drain_length) AS length
FROM drain_wet
GROUP BY wet_fid
/* Creates a new table that dissolves all wetland drains within each subward as a single 
geometry. The length of the dissolved drains within each subward are summed.  */

```

![drains_sub](/qgis/lab_6/drains_sub.png)

This map is the drains_sub table from the previous SQL step. Each of the drains within the output data are shaded as a bright red. Although there visually appears to be a large number of tiny, disjointed drains, each drain that belongs in the same subward is a single multiline geometry. As such, the number of unique IDs in the attribute table is equivalent to the IDs of subwards which contain wetland and drain data.

```sql

CREATE TABLE subwards_info AS
SELECT a.fid, a.way, b.length AS drain_length_wetland
FROM subwards_drains_wet AS a LEFT OUTER JOIN drains_sub AS b
ON a.fid=b.wet_fid
WHERE b.length IS NOT NULL
/* In preparation for a final deliverable layer, this step creates a subward layer in 
which the total length of wetland drains is listed for each subward */

CREATE TABLE subwards_info_wetland AS
SELECT a.fid, a.way, a.drain_length_wetland, b.building_area
FROM subwards_info AS a LEFT OUTER JOIN building_area_sub AS b
ON a.fid=b.fid
/* Creates a table that builds upon the previous step to also attach the total area of 
wetland buildings onto a subward layer */

ALTER TABLE subwards_info_wetland ADD COLUMN density_wetland FLOAT;
UPDATE subwards_info_wetland
SET density_wetland = drain_length_wetland/building_area
/* Calculates the length of wetland drain to each square meter of wetland building within 
each subward  */

ALTER TABLE building_wet_sub ADD COLUMN subward INTEGER;
UPDATE building_wet_sub
SET subward = 1 
FROM subwards_info_wetland_meters
WHERE (st_intersects(building_wet_sub.way, subwards_info_wetland_meters.way)
AND NOT st_touches(building_wet_sub.way, subwards_info_wetland_meters.way));
CREATE TABLE buildings AS
SELECT sub_id, st_union(building_way) AS buildings, sum(building_area) AS building_area
FROM building_wet_sub
WHERE subward IS NOT NULL
GROUP BY sub_id
/* Makes a table of buildngs dissolved by subward as a single polygon and only considers 
buildings within subwards that contain final drain density data for wetlands. This is the redo
of an analysis step in order to streamline the data for a final deliverable. However,
I ultimately chose not to include the building feature in the Leaflet map*/

CREATE TABLE final_data AS
SELECT id AS subward_id, drain_length_wetland AS wetland_drain_length, 
building_area AS wetland_building_area, drain_density, way
FROM subwards_info_wetland_meters
/* Streamlining final deliverable by only selecting essential columns */

CREATE TABLE final_data_ranked AS
SELECT*, ntile(4)over(ORDER BY drain_density) AS rank
FROM final_data
/* Creates a table with an internal quantile rank of subwards based upon the drain 
density data */

ALTER TABLE wetland_subward ADD COLUMN wetland INTEGER;
UPDATE wetland_subward
SET wetland = 1 
FROM final_data_ranked
WHERE (st_intersects(wetland_subward.way, final_data_ranked.way)
AND NOT st_touches(wetland_subward.way, final_data_ranked.way));
CREATE TABLE wetlands_focused AS
SELECT row_number() OVER () AS id, st_union(way) AS way
FROM wetland_subward
WHERE wetland = 1
GROUP BY wetland
/* In preparation for a final deliverable, creates a table in which all the wetlands that 
intersect and not just touch subwards with final drain data is a single polygon */

CREATE TABLE final_condensed AS
SELECT subward_id, drain_density, rank, way
FROM final_data_ranked
/* Further streamlining of essential columns for a final deliverable */

UPDATE final_condensed 
SET drain_density = round(drain_density::NUMERIC,6)
/* Rounds the drain density data to 6 numerals to further limit data footprint of the 
final deliverable */

```

Here is the [SQL file](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/sqlprocess.sql) for this workflow. 

### Results
To display the wetland drain density data, I developed a map using [Leaflet](https://leafletjs.com/) software. This map breaks the subwards into four quantile ranks ordered by the density of drain length to building area. Subwards are color-coded dependent on the density of their wetland drains. Only subwards which contain wetland drains are considered. You can select to overlay the wetland layer to see the locations within each subward which are considered wetland terrain.

Here is the [link](../../dsmmap/index.html) to the map. 

#### Results Discussion

As mentioned in the summary of the lab to provide examples of what to expect for the data, the density of wetland drains in subwards ranges from .0006 meters as the low to .9 meters as the high. As visible in the Leaflet map, there is a concentration of subwards with a low density of wetland drains in the center of the map. Further, the subwards with the highest density of wetland drains are typically in the perifial of the map. The unrepresented subwards within the center of the map also reveal information. Due to the analysis parameters, only subwards that contain drain information and intersect wetlands are displayed in the final product. Since no subwards in my analysis had a result of 0, that means that all subwards which have wetlands and contain drains elsewhere in the subward also have drains in the wetland portion of the subward, albeit very little for some subwards. When the wetland feature of the Leaflet map is activated, it is evident that subwards excluded from my analysis still intersect wetlands. Further, the footprints of buildings from the OpenStreetMap base layer are visible within these wetland features - buildings that are at an increased risk of flooding. As such, the exlcusion of these subwards from the analysis means that the entirety of these subwards do not contain drain data, whether that be in wetlands or outside of the wetlands. It cannot be known if this lack of drain data reflects a total lack of drains within these subwads or if it is representative of incomplete data. This inability to discern between the potential scenarios is the reason why I chose to exclude subwards without drain data in my analysis.

Return to [QGIS and PostGIS Index Page](../qgis.md).

Return to [Main Index Page](../../index.md).
