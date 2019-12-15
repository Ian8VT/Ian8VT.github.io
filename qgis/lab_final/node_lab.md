### Introduction

This lab page documents the continuation from a previous lab which can be viewed [here](../lab_final/lab.md). An overview of the lab and documentation of resources used can be found on the first page of the lab. In this workflow, I analyze to see if there are noticeable infrastructure differences between settlements constructed in wetlands and settlements outside of wetlands in Dar es Salaam, Tanzania. To represent this concept, I calculated the average distance of road there is for every intersection. I chose this calculation as it is representative of the interconnectedness of the road system. A lower value of average road length means that there is a higher proportion of intersections to road length, allowing for more pathfinding options when attempting to transit from one location to another. This infrastructure quality is particularly relevant in the flood prone wetlands as it enables alternative forms of movement if certain road segments experience flooding.

### Node Connectivity Steps

```sql
alter table nodes add column wetland integer;
update nodes set wetland = 1
from wetlands
where st_intersects(nodes.geom, wetlands.way);
update nodes set wetland =  0
where wetland is null
/*sets value of 1 for all nodes in wetland*/

create table roads_wetland as
select st_multi(st_intersection(a.geom,b.geom)) as geom, b.id
from wetland_school as a
inner join roads_school as b
on (st_intersects(a.geom,b.geom))
and not st_touches(a.geom,b.geom)
/*creates table of roads in wetland*/

alter table roads_wetland add column length float;
update roads_wetland set length = st_length(geom)

alter table roads_wetland add column wet integer;
update roads_wetland set wet =1;
create table roads_wetland_sum as
select wet, st_union(geom), sum(length)
from roads_wetland
group by wet
/* dissolves all wetland roads into one feature and sums the length*/

select count(*)
from nodes
where wetland = 1
/* 588 nodes in wetlands*/

alter table roads_wetland_sum add column intersection float;
update roads_wetland_sum set intersection = sum/588
/* output of x meters of road per intersection*/

alter table wetland_school add column wet integer;
update wetland_school set wet = 1;
create table wetland_school_union as
select st_union(geom) as geom, wet
from wetland_school
group by wet
/* dissolves wetlands into a single feature*/

create table school_dry as
select row_number() OVER () as id, st_difference(a.geom,b.geom) as geom
from school_buff a, wetland_school_union b
/*selects part of buffer that is not wetland as a feature*/

create table roads_dry as
select st_multi(st_intersection(a.geom,b.geom)) as geom, b.id
from school_dry as a
inner join roads_school as b
on (st_intersects(a.geom,b.geom))
and not st_touches(a.geom,b.geom)

alter table roads_dry add column length float;
update roads_dry set length = st_length(geom);
alter table roads_dry add column dry integer;
update roads_dry set dry =1;
create table roads_dry_sum as
select dry, st_union(geom) as geom, sum(length)
from roads_dry
group by dry;
select count(*)
from nodes
where wetland = 0
/*layer of all dry roads as one geometry with length summed. 792 nodes.*/

alter table roads_dry_sum add column intersection float;
update roads_dry_sum set intersection = sum/792
```
![roads_dry_wet](../lab_final/brown_dry_blue_wet.png)

In wetlands, an intersection for every 52.3 meters of road.
A total of 30,775 meters of wetland road and 588 intersections.
in dry, an intersection for every 59.6 meters of road.
A total of 47,236 meters of dry road and 792 intersections.
