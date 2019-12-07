# Twitter Activity during Hurricane Dorian
## Which created more activity during the storm: The hurricane or Sharpiegate?

### Introduction

Hurricane Dorian was an intense Category 5 hurricane that caused significant damage and loss of life throughout much of its course. When the storm directly hit the Bahamas, its winds were so strong that the storm became tied for the highest recorded hurricane winds in the Atlantic Ocean to ever make landfall. After the grave destruction the storm caused on the Bahamian Abaco Islands, Dorian slowly weakened though remained a powerful hurricane as it closely followed the US coast northward. As a result of the storm's extreme destruction in the Bahamas and how closely it hugged the entirety of the US east coast, this storm generated a significant amount of attention, particularly along the east coast locations predicted to be nearest to the storm. However, the media attention for this storm was even greater than that generated from the physical risks of Dorian because of the controversy that surrounded Sharpiegate, which you can read about on [this Wikipedia page](https://en.wikipedia.org/wiki/Hurricane_Dorian%E2%80%93Alabama_controversy). 

The scope of this lab is to determine how much of an effect Sharpiegate had on the Twitter activity related to Hurricane Dorian. Specifically, I will examine if the most significant pockets of storm tweets corresponded with the accepted storm prediction or if the storm clusters followed the storm prediction of Sharpiegate. Essentially, this lab will examine which scenario had a greater effect on the spatial distrubtion of storm tweets: the real storm prediction or an exubarently defended mistake. Through this, the lab addresses the concept of whether reality or gossip more strongly effects people's actions.

### Data Sources

The data for this lab was collected in [rStudio] through a [Twitter API]. Professor Joseph Holler of Middlebury College searched for storm data on September 11, 2019 and searched for the baseline data on November 19, 2019. Only tweets which contained the words 'dorian', 'hurricane', or 'sharpiegate' were collected as storm data. There were no lexicon parameters for the baseline data. For each set of data, tweets within one week prior to the search date were considered and the geographic range was set as 1,000 miles around the coordinates of 32, -78. For each set, 200,000 tweets that match these parameters were mined. An excel file which contains the status id for storm and baseline tweets can be downloaded [here].

In rStudio, I defined the geographic boundaries of each tweet and developed two graphics related to a lexicon content analysis of the tweets. I also used a [Census API] to pull a map of the United States with all counties filled with population data. I then connected directly to my [Postgres] database from rStudio and transfered the storm tweet data, baseline tweet data, and populated county data to my database. I conducted a series of SQL steps with my database using the [QGIS] interphase. Upon the completion of my analysis, I used [GeoDa] to develop four maps using Getis-Ord G* spatial statistics. 

### Analysis Overview

The main steps in this lab included twitter content analysis in rStudio, SQL analysis in PostGIS to calculate frequency of storm of tweets by county population and the rate of storm tweets normalized by baseline data, and the conversion of this spatial data into maps using GeoDa.

##### rStudio Steps

#### Annotated SQL Workflow in PostGIS

```

SELECT addgeometrycolumn('public', 'dorian', 'geom', 102004,
'POINT', 2);
UPDATE dorian
SET geom = st_transform(st_setsrid(st_makepoint(lng,lat),4326),102004);
SELECT addgeometrycolumn('public', 'november', 'geom', 102004,
'POINT', 2);
UPDATE november
SET geom = st_transform(st_setsrid(st_makepoint(lng,lat),4326),102004);
/*adds point geometry to each table */

SELECT addgeometrycolumn('public', 'novemberCounties', 'geom', 102004, 'MULTIPOLYGON', 2);
UPDATE "novemberCounties" 
SET geometry = populate_geometry_columns(geom)
/* can't work*/

UPDATE "novemberCounties"
SET geometry = st_transform(geometry,102004)

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

CREATE TABLE doriantweet_county AS
SELECT geom, geoid 
FROM dorian;
ALTER TABLE doriantweet_county ADD COLUMN count INTEGER;
UPDATE doriantweet_county
SET count = 1;
SELECT geoid, st_union(geom), sum(count)
FROM doriantweet_county
WHERE geoid is not null
GROUP BY geoid
/* creates new table of tweets aggregated by geoid - didnt work selecting one point doesnt select others in county. in database table looks correct but q is not*/

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

:: ERROR, not the desired results. Realized the from map was not the proper location to compile total tweet database
::ALTER TABLE doriantweets ADD COLUMN tweets INTEGER;
::UPDATE doriantweets SET tweets = doriantweets_counties.sum
::FROM doriantweets_counties
::WHERE doriantweets.geoid = doriantweets_counties.geoid
::/* map of counties with sum tweets of each county present in attribute table. for some reason there are multiple identical counties in the attribute table */


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

```

### Results and Discussion

![word_twitter_activity](/qgis/lab_8/dorian_words.png)

This graph displays the frequency of the 15 most commons words in tweets related to the storm. The two most frequently used unique terms are 'hurricane' and 'dorian', which does not come as a surprise since nearly every tweets which dicusses the storm must use these two general terms. Noticeably, the controversy-related terms of 'alabama' and 'sharpiegate' are the next two most commonly used unique terms in tweets about the storm. Further, the unique terms of 'donald' and 'realdonaldtrump', in reference to the President and his twitter account, are also frequently used and are likely in association with discussion about the Sharpiegate controversy. 

![twitter_word_association](/qgis/lab_8/word_network.png)

This graphic displays how words are clustered together in conversation. The closer the proximity of words are within this graphic, the more frequently they were used within the same tweet. Only words that occur at least 30 times are included within this graphic.

![hotspot_map_tweets_per_10000ppl](/qgis/lab_8/counties_hotcold_pp05.png)

This is a map of the hot spots and cold spots of twitter activity related to the storm. This graphic is a result of normalizing the count of storm tweet activity for each county by population and then performing a Getis-Ord G* statistical analysis on the normalized rate. Counties shaded red contain a rate of twitter activity about the storm which is high for its population. Conversely, the frequency of storm tweets in blue counties is low for its populations. This means that the rate of storm tweets was high for many of the counties along the coast and nearest to the storm's predictions and occurence. Interestingly, the counties of Geogia and Alabama which were referenced in the Sharpiegate controversy have a tweet rate about the storm that is low for their population. 

![pp_values_tweets_per_10000](/qgis/lab_8/counties_normalized_with_population.png)

This map contains the same data from the previous hot-cold map on the frequency of tweets related to the storm normalized by population. However, this map displays how significantly high or low the frequency of storm tweets were for the population of counties. Using the hot-cold map as your filter, you can see how significantly high or low the frequency of storm tweets were for counties. The darker the shade of green, the more statistically significant those counties' storm tweets were for its county population. 

![hotcold_normalized_tweet_difference](/qgis/lab_8/counties_ndti.png)

![pp_values_normalized_tweet_difference](/qgis/lab_8/counties_ndti_ppvalues.png)


### Conclusion


