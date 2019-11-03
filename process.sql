create table dar_polygons as
select osm_id as id, building, "natural", st_transform(way,32737) as way, way_area
from planet_osm_polygon
where building is not null or "natural" is not null
/* reprojects and only considers buildings and natural attributes */

update dar_polygons
set way_area = st_area(way)
/* update to new crs unit of meters */

create table wetlands as
select id, "natural" as wetland, way, way_area
from dar_polygons
where "natural" = 'wetland'
/* makes a layer of wetlands */

ALTER TABLE dar_polygons ADD COLUMN building_presence integer
/* preparing to make a 1 or 0 column representing a building */

UPDATE dar_polygons
SET building_presence = 1
WHERE building is not null
/* makes value of 1 in column where there is no null value in building column */

alter table dar_polygons add column building_wetland integer

UPDATE dar_polygons
SET building_wetland = 1
FROM wetlands
WHERE st_intersects(dar_polygons.way, wetlands.way)
/* sets value of 1 to buildings present within wetland feature - does for all features that intersect wetland, not just buildings */

CREATE TABLE building_wetlands AS
SELECT id, building, way, way_area
FROM dar_polygons
WHERE building_wetland = 1 and building_presence = 1
/* makes new table of only buildings present in wetlands */

:: CREATE TABLE buildings_wetlands AS
SELECT*, st_transform(way,32737)
FROM building_wetlands
/* however, the output remains as the default epsg:4326 when I upload onto Q to view or check the properties on postgis. */

create view intersection as
select row_number() OVER () AS id, wetland_untransformed.osm_id, wetland_untransformed.way, wetland_untransformed.way_area, subwards.fid, subwards.way AS sub_way,
(st_multi(st_intersection(wetland_untransformed.way,subwards.way)))
from wetland_untransformed 
inner join subwards on st_intersects(wetland_untransformed.way, subwards.way)
/* doesn't work - subwards fid in this layer is not consistent with original subward fid. should subdivide wetlands by subward boundaries. couldn't add layer to q simply by dragging the layer from the postgis browser, but had to go into the add postgis layer option in q and then manually select the primary id value */

create view intersection as
select row_number() OVER () AS id, wetland_untransformed.osm_id, wetland_untransformed.way, wetland_untransformed.way_area, subwards.fid, subwards.way AS sub_way,
(st_multi(st_intersection(wetland_untransformed.way,subwards.way)))
from wetland_untransformed 
left join subwards on st_intersects(wetland_untransformed.way, subwards.way)
/* also has same issue */

create view intersection as
select row_number() OVER () AS id, wetland_untransformed.way, subwards.fid, subwards.way AS sub_way,
(st_intersection(wetland_untransformed.way,subwards.way))
from wetland_untransformed 
inner join subwards on st_intersects(wetland_untransformed.way, subwards.way)
/* may be working - think it works*/

create table wetland_subward as
SELECT fid, st_union(intersection.st_intersection) as wetland_subward
from intersection
group by fid
/* dissolve wetlands by subward - turns all disjointed wetlands within the same subward into a single polygon */

alter table wetland_subward add column area float

update wetland_subward
set area = st_area(wetland_subward)

alter table drains add column length float

update drains set length = st_length(way)
/* is in unit of the reference system */

alter table subwards add column way_wetland integer

update subwards
set way_wetland = 1
from wetland_subward
where st_intersects(wetland_subward.wetland_subward, subwards.way)

create view subward_wetland as
select fid, way, way_wetland
from subwards
where way_wetland = 1
/* dont want this. i do want to intersect subward by drain because subwards without drains may be a result of incomplete data, not a reflection of reality. so cant let subwards without drains scew the data by lowering the density of drains in wetlands */

alter table subwards add column sub_drains integer

update subwards
set sub_drains = 1
from drains
where st_intersects(drains.way, subwards.way)

create table subwards_drains as
select fid, way, sub_drains
from subwards
where sub_drains = 1

alter table subwards_drains add column wetland integer

update subwards_drains
set wetland = 1
from wetland_subward
where (st_intersects(wetland_subward.wetland_subward, subwards_drains.way)
and not st_touches(wetland_subward.wetland_subward, subwards_drains.way))

create table subwards_drains_wet as
select fid, way, wetland
from subwards_drains
where wetland = 1
/* subwards that only intersect drains and wetland */

select row_number() OVER () AS id,
(st_intersection(building_wetlands.way, wetland_subward.wetland_subward)),
building_wetlands.osm_id, building_wetlands.way, building_wetlands.way_area, 
wetland_subward.fid, wetland_subward.wetland_subward, wetland_subward.area
from building_wetlands
left join wetland_subward on st_intersects(building_wetlands.way, wetland_subward.wetland_subward)
/* invalid geometry input 1, geometry intersects with self */

create table wetland_subwards_corrected as
select fid, area, st_makevalid(wetland_subward) as way
from wetland_subward

create table building_wet_sub as
select row_number() OVER () AS id,
(st_intersection(building_wetlands.way, wetland_subwards_corrected.way)) as way,
building_wetlands.osm_id, building_wetlands.way as building_way, building_wetlands.way_area as building_area, 
wetland_subwards_corrected.fid, wetland_subwards_corrected.way as wetland_way, wetland_subwards_corrected.area as wetland_area
from building_wetlands
left join wetland_subwards_corrected on st_intersects(building_wetlands.way, wetland_subwards_corrected.way)

create table building_area_sub as
SELECT fid, st_union(building_wet_sub.building_way) as buildings, sum(building_wet_sub.building_area) as building_area
from building_wet_sub
group by fid
/* made obsolete for final display of data in last step to exclude more buildings, but still used in the meantime in functions */

create table drain_wet as
SELECT st_multi(st_intersection(a.way,b.wetland_subward)) as drain_wet, a.fid as drain_fid, a.way as drain_way, a.length as drain_length, b.fid as wet_fid, b.wetland_subward as wet_way, b.area as wet_area
from drains as a
inner join wetland_subward as b
on (st_intersects(a.way, b.wetland_subward)
and not st_touches (a.way, b.wetland_subward))
/* feature of just drains in wetlands */

create table drains_sub as
select wet_fid, st_union(drain_wet.drain_wet) as drains_way, sum(drain_length) as length
from drain_wet
group by wet_fid
/* drains in each subward a single feature and their length is summed */

create table subwards_info as
select a.fid, a.way, b.length as drain_length_wetland
from subwards_drains_wet as a left outer join drains_sub as b
on a.fid=b.wet_fid
where b.length is not null
/* make subward feature with column of total length of drains in wetlands */

create table subwards_info_wetland as
select a.fid, a.way, a.drain_length_wetland, b.building_area
from subwards_info as a left outer join building_area_sub as b
on a.fid=b.fid
/* makes subward feature with columns of total drain length in wetlands and column of total building area in wetlands */

update subwards_info_wetland
set density_wetland = drain_length_wetland/building_area
/* density of drain length over building area */

alter table building_area_sub add column subward integer;
update building_area_sub
set subward = 1 
from subwards_info_wetland_meters
where (st_overlap(building_area_sub.buildings, subwards_info_wetland_meters.way)
and not st_touches(building_area_sub.buildings, subwards_info_wetland_meters.way))

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
/* makes feature of buildings dissolved by subward but only considers buildings in subwards that have final drain density data for wetlands */

create table final_data as
select id as subward_id, drain_length_wetland as wetland_drain_length, building_area as wetland_building_area, drain_density, way
from subwards_info_wetland_meters
/* streamlining data in final map */

create table final_data_ranked as
select*, ntile(4)over(order by drain_density) as rank
from final_data

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
/* creates feature of a single wetland only were there is final subward data */

create table final]_condensed as
select subward_id, drain_density, rank, way
from final_data_ranked