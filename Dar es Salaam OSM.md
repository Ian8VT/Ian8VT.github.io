## Wetland Drains in Dar es Salaam, Tanzania with OpenStreetMap

### Project Outline
Dar es Salaam, Tanzania, is a highly mapped city on OpenStreetMap. This provides a unique opportunity to conduct a number of different geospatial analyses related to the city. [Ramani Huria](http://ramanihuria.org/), a community-based mapping project in the city that accesses this vast array of geospatial data, draws attention to the presence of damaging seasonal floods in the city which are often compounded by a lack of necessary infrastructure and city planning. Further, there are a large number of structures and settlements in the city that are built on terrain designated as wetland - locations expected to be highly suscpetible to flood disturbances. In this lab, I measured the total length of drains in these wetlands per square meter of building in the wetlands. I bounded my analysis by the subward boundaries in the city, the most local political boundary in the city, so that my final product is a number for each subward which represents how much length of drain there is per square meter of building in the wetlands of that subward. 

[Script for an interactive map via Leaflet](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/dsmmap/dsmmap/index.html)


```

create table dar_polygons as
select osm_id as id, building, "natural", st_transform(way,32737) as way, way_area
from planet_osm_polygon
where building is not null or "natural" is not null
/* Creates a new table from the input OSM polygon data. Five columns are selected from the input to the 
new table: polygon id; building type; natural feature type; way(in this feature, multipolygon); area of 
that way. The coordinate reference system is simultaneously transformed from the OSM default to the UTM 
projection for Dar es Salaam. */

update dar_polygons
set way_area = st_area(way)
/* This ensures that the calculated area of the way_area column is in the correct unit of measurement for 
the new UTM projection, which is meters. */

create table wetlands as
select id, "natural" as wetland, way, way_area
from dar_polygons
where "natural" = 'wetland'
/* Creates a new table of just polygons that are recorded as wetland. The polygon id, way, and way_area 
of these wetland polygons are also selected for the new table. */

ALTER TABLE dar_polygons ADD COLUMN building_presence integer
/* Adds a new column to the polygon table. This is in preparation for the next step, for which the 
results will be a whole number (either 0 or 1), so I designated that this table will contain data 
in the integer format.  */

UPDATE dar_polygons
SET building_presence = 1
WHERE building is not null
/* Inserts a value of 1 in the new column created last step for every polygon mapped as a building 
irregardless of terrain. */

alter table dar_polygons add column building_wetland integer
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
WHERE building_wetland = 1 and building_presence = 1
/* Compares the integers from the two recently added columns to creates a new table of only building
polygons that are present in wetlands.  */

create view intersection as
select row_number() OVER () AS id, wetlands.way, subwards.fid, subwards.way AS sub_way,
(st_intersection(wetlands.way,subwards.way))
from wetlands 
inner join subwards on st_intersects(wetlands.way, subwards.way)
/* This creates a new layer of wetlands bounded by subward boundaries. This is the first appearance 
of the subward polygon layer in the workflow. Each disjointed wetland within a single subward are 
considered indepedent polygons and previously continuous wetland polygons that cross a subward 
boundary are now considered indepdent polygons. Each new feature has a unique id, lists the wetland 
way, the subward id that the wetland is in, and the subward way. */

create table wetland_subward as
SELECT fid, st_union(intersection.st_intersection) as wetland_subward
from intersection
group by fid
/* This takes the previously created layer and dissolves all disjointed wetlands within the same 
subward as a single polygon. */

alter table wetland_subward add column area float
/* Adds a new column in the table in preparation for the next step, the results of which will be 
a decimal number (float data point) */

update wetland_subward
set area = st_area(wetland_subward)
/* Calculates the area of all the wetlands within each subward */

alter table drains add column length float
/* Adds a new column in the table in preparation for the next step, the results of which will be 
a float. This is the first appearance of the drain layer in the analysis */

update drains set length = st_length(way)
/* Calculates the length of the drains */

alter table subwards add column sub_drains integer
/* Adds an integer column for the next step */

update subwards
set sub_drains = 1
from drains
where st_intersects(drains.way, subwards.way)
/* Sets a value of 1 in the newly created column for subward polygons that intersect with drain 
lines. */

create table subwards_drains as
select fid, way, sub_drains
from subwards
where sub_drains = 1
/* Creates a new table of only subwards that contain mapped drains. */

alter table subwards_drains add column wetland integer
/* Adds a new integer column in preparation for the next step */

update subwards_drains
set wetland = 1
from wetland_subward
where (st_intersects(wetland_subward.wetland_subward, subwards_drains.way)
and not st_touches(wetland_subward.wetland_subward, subwards_drains.way))
/* Sets a value of 1 for subwards that intersect wetlands and not just touch wetlands */

create table subwards_drains_wet as
select fid, way, wetland
from subwards_drains
where wetland = 1
/* Creates a table of subwards that intersect with wetlands. Since the input table was subwards 
that contain drains, this new table is of subwards that contain both drains and wetlands, 
though does not require the drains to be in wetlands. */

:: ERROR Invalid Geometry, Geometry Intersects With Self
:: select row_number() OVER () AS id,
:: (st_intersection(building_wetlands.way, wetland_subward.wetland_subward)),
:: building_wetlands.osm_id, building_wetlands.way, building_wetlands.way_area, 
:: wetland_subward.fid, wetland_subward.wetland_subward, wetland_subward.area
:: from building_wetlands
:: left join wetland_subward on st_intersects(building_wetlands.way, 
:: wetland_subward.wetland_subward)

create table wetland_subwards_corrected as
select fid, area, st_makevalid(wetland_subward) as way
from wetland_subward
/* Edits the layer to correct the simple errors in the geometry features */

create table building_wet_sub as
select row_number() OVER () AS id,
(st_intersection(building_wetlands.way, wetland_subwards_corrected.way)) as way,
building_wetlands.osm_id, building_wetlands.way as building_way, 
building_wetlands.way_area as building_area, wetland_subwards_corrected.fid, 
wetland_subwards_corrected.way as wetland_way, 
wetland_subwards_corrected.area as wetland_area
from building_wetlands
left join wetland_subwards_corrected on st_intersects(building_wetlands.way, 
wetland_subwards_corrected.way)
/* Creates a new table where the wetland buildings and bounded by subwards. Each 
building within each subward has its own unique id */

create table building_area_sub as
SELECT fid, st_union(building_wet_sub.building_way) as buildings, 
sum(building_wet_sub.building_area) as building_area
from building_wet_sub
group by fid
/* Dissolves all wetland buildings by subward so that all wetland buildings within the 
same subward are a single polygon. This step is fine for further analysis, but must be 
redone for a final display deliverable as this output contains all wetland buildings 
within all the subwards of the initial input, not just those subwards with mapped wetland 
and drain data*/

create table drain_wet as
SELECT st_multi(st_intersection(a.way,b.wetland_subward)) as drain_wet, a.fid as drain_fid, 
a.way as drain_way, a.length as drain_length, b.fid as wet_fid, b.wetland_subward as wet_way, 
b.area as wet_area
from drains as a
inner join wetland_subward as b
on (st_intersects(a.way, b.wetland_subward)
and not st_touches (a.way, b.wetland_subward))
/* Creates a table of only the drain line segments that are within wetlands. The drain must 
fully intersect the wetland polygon and not just touch the boundary. */

create table drains_sub as
select wet_fid, st_union(drain_wet.drain_wet) as drains_way, sum(drain_length) as length
from drain_wet
group by wet_fid
/* Creates a new table that dissolves all wetland drains within each subward as a single 
geometry. The length of the dissolved drains within each subward are summed.  */

create table subwards_info as
select a.fid, a.way, b.length as drain_length_wetland
from subwards_drains_wet as a left outer join drains_sub as b
on a.fid=b.wet_fid
where b.length is not null
/* In preparation for a final deliverable layer, this step creates a subward layer in 
which the total length of wetland drains is listed for each subward */

create table subwards_info_wetland as
select a.fid, a.way, a.drain_length_wetland, b.building_area
from subwards_info as a left outer join building_area_sub as b
on a.fid=b.fid
/* Creates a table that builds upon the previous step to also attach the total area of 
wetland buildings onto a subward layer */

alter table subwards_info_wetland add column density_wetland float;
update subwards_info_wetland
set density_wetland = drain_length_wetland/building_area
/* Calculates the length of wetland drain to each square meter of wetland building within 
each subward  */

alter table building_wet_sub add column subward integer;
update building_wet_sub
set subward = 1 
from subwards_info_wetland_meters
where (st_intersects(building_wet_sub.way, subwards_info_wetland_meters.way)
and not st_touches(building_wet_sub.way, subwards_info_wetland_meters.way));
create table buildings as
SELECT sub_id, st_union(building_way) as buildings, sum(building_area) as building_area
from building_wet_sub
where subward is not null
group by sub_id
/* Makes a table of buildngs dissolved by subward as a single polygon and only considers 
buildings within subwards that contain final drain density data for wetlands */

create table final_data as
select id as subward_id, drain_length_wetland as wetland_drain_length, 
building_area as wetland_building_area, drain_density, way
from subwards_info_wetland_meters
/* Streamlining final deliverable by only selecting essential columns */

create table final_data_ranked as
select*, ntile(4)over(order by drain_density) as rank
from final_data
/* Creates a table with an internal quantile rank of subwards based upon the drain 
density data */

alter table wetland_subward add column wetland integer;
update wetland_subward
set wetland = 1 
from final_data_ranked
where (st_intersects(wetland_subward.way, final_data_ranked.way)
and not st_touches(wetland_subward.way, final_data_ranked.way));
create table wetlands_focused as
SELECT row_number() OVER () AS id, st_union(way) as way
from wetland_subward
where wetland = 1
group by wetland
/* In preparation for a final deliverable, creates a table in which all the wetlands that 
intersect and not just touch subwards with final drain data is a single polygon */

create table final_condensed as
select subward_id, drain_density, rank, way
from final_data_ranked
/* Further streamlining of essential columns for a final deliverable */

update final_condensed 
set drain_density = round(drain_density::numeric,6)
/* Rounds the drain density data to 6 numerals to further limit data footprint of the 
final deliverable */  

```
