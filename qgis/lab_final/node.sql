:: Developed by Ian8VT

alter table nodes add column wetland integer;
update nodes set wetland = 1
from wetlands
where st_intersects(nodes.geom, wetlands.way);
update nodes set wetland =  0
where wetland is null;

create table roads_wetland as
select st_multi(st_intersection(a.geom,b.geom)) as geom, b.id
from wetland_school as a
inner join roads_school as b
on (st_intersects(a.geom,b.geom))
and not st_touches(a.geom,b.geom);

alter table roads_wetland add column length float;
update roads_wetland set length = st_length(geom);

alter table roads_wetland add column wet integer;
update roads_wetland set wet =1;
create table roads_wetland_sum as
select wet, st_union(geom), sum(length)
from roads_wetland
group by wet;

select count(*)
from nodes
where wetland = 1;

alter table roads_wetland_sum add column intersection float;
update roads_wetland_sum set intersection = sum/588;

alter table wetland_school add column wet integer;
update wetland_school set wet = 1;
create table wetland_school_union as
select st_union(geom) as geom, wet
from wetland_school
group by wet;

create table school_dry as
select row_number() OVER () as id, st_difference(a.geom,b.geom) as geom
from school_buff a, wetland_school_union b;

create table roads_dry as
select st_multi(st_intersection(a.geom,b.geom)) as geom, b.id
from school_dry as a
inner join roads_school as b
on (st_intersects(a.geom,b.geom))
and not st_touches(a.geom,b.geom);

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
where wetland = 0;

alter table roads_dry_sum add column intersection float;
update roads_dry_sum set intersection = sum/792;