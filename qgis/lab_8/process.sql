Developed by Ian8VT

SELECT addgeometrycolumn('public', 'dorian', 'geom', 102004,
'POINT', 2);
UPDATE dorian
SET geom = st_transform(st_setsrid(st_makepoint(lng,lat),4326),102004);
SELECT addgeometrycolumn('public', 'november', 'geom', 102004,
'POINT', 2);
UPDATE november
SET geom = st_transform(st_setsrid(st_makepoint(lng,lat),4326),102004);
/*adds point geometry to each table */

UPDATE "novemberCounties"
SET geometry = st_transform(geometry,102004)
/* reprojects geometry */

DELETE FROM "novemberCounties"
WHERE statefp NOT IN ('54', '51', '50', '47', '45', '44', '42', '39', '37',
'36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17',
'13', '12', '11', '10', '09', '05', '01');

ALTER TABLE dorian ADD COLUMN geoid varchar(5);
ALTER TABLE november ADD COLUMN geoid varchar(5);

UPDATE dorian
SET geoid = "novemberCounties".geoid
FROM "novemberCounties"
WHERE st_intersects("novemberCounties".geometry, dorian.geom)
/*applying geoid of each county onto the tweets present in that county*/

UPDATE november
SET geoid = "novemberCounties".geoid
FROM "novemberCounties"
WHERE st_intersects("novemberCounties".geometry, november.geom)

ALTER TABLE dorian ADD COLUMN count INTEGER;
UPDATE dorian SET count = 1;
CREATE TABLE doriantweets AS 
SELECT a.statefp, a.countyfp, a.pop, a.geometry, b.status_id, b.count, b.geoid, b.geom
FROM "novemberCounties" AS a left join dorian as b
ON a.geoid = b.geoid;
/*created table of tweets and only of those that overlay with the previously selected county geoids. a count column is added to sum tweets per county in next step*/

CREATE TABLE doriantweets_counties AS
SELECT  geoid, st_union(geom), sum(count)
FROM doriantweets
GROUP BY geoid
/* dissolves all tweet points within same county geoid as a single geometry*/

ALTER TABLE "novemberCounties" ADD COLUMN tweets INTEGER;
UPDATE "novemberCounties" SET tweets = doriantweets_counties.sum
FROM doriantweets_counties
WHERE doriantweets_counties.geoid = "novemberCounties".geoid
/* map of counties with sum tweet data. each county is correctly represented without the error from the previous sql attempt */

CREATE TABLE counties AS
SELECT statefp, countyfp, geoid, geometry, pop, tweets as tweets_dorian
FROM "novemberCounties"
/* consolidating data table*/

ALTER TABLE november ADD COLUMN tweet INTEGER;
UPDATE november SET tweet = 1;
CREATE TABLE november_tweets AS
SELECT geoid, st_union(geom), sum(tweet) as tweets
FROM november
GROUP BY geoid;
ALTER TABLE counties ADD COLUMN tweets_november INTEGER;
UPDATE counties SET tweets_november = 0;
UPDATE counties SET tweets_november = november_tweets.tweets
FROM november_tweets
WHERE counties.geoid = november_tweets.geoid
/* all the steps to sum the total november tweets for each county. performed it in a more condensed manner after learning the process with the dorian tweets above. now total dorian and november tweets are their own column within the same county table*/

UPDATE counties SET tweets_dorian = 0;
UPDATE counties SET tweets_dorian = doriantweets_counties.sum
FROM doriantweets_counties
WHERE doriantweets_counties.geoid = counties.geoid
/* fixing dorian tweets column so the null values appear as 0 */

ALTER TABLE counties ADD COLUMN tweets_dorian_per10k REAL;
UPDATE counties SET tweets_dorian_per10k = ((tweets_dorian/pop)*10000)
/* normalizing storm tweet data by a population of 10000*/

ALTER TABLE counties ADD COLUMN ndti REAL;
UPDATE counties SET ndti = (tweets_dorian-tweets_november)/((tweets_dorian+tweets_november)*1.0)
WHERE tweets_dorian+tweets_november>0;
UPDATE counties SET ndti = 0 
WHERE ndti is null
/*normalizing the difference between storms about the storm and the basline twitter activity for the month of november. positive value means occurence of storm tweets greater than the tweet baseline, negative value means storm tweets lower than baseline*/

CREATE TABLE counties_centroid as
SELECT st_centroid(geometry), geoid, tweets_dorian_per10k
FROM counties
/*heatmap isnt working*/


