# Twitter Activity during Hurricane Dorian
## Which created more activity during the storm: The hurricane or Sharpiegate?

### Introduction

Hurricane Dorian was an intense Category 5 hurricane that caused significant damage and loss of life throughout much of its course. When the storm directly hit the Bahamas, its winds were so strong that the storm became tied for the highest recorded hurricane winds in the Atlantic Ocean to ever make landfall. After the grave destruction the storm caused on the Bahamian Abaco Islands, Dorian slowly weakened though remained a powerful hurricane as it closely followed the US coast northward. As a result of the storm's extreme destruction in the Bahamas and how closely it hugged the entirety of the US east coast, this storm generated a significant amount of attention, particularly along the east coast locations predicted to be nearest to the storm. However, the media attention for this storm was even greater than that generated from the physical risks of Dorian because of the controversy that surrounded Sharpiegate, which you can read about on [this Wikipedia page](https://en.wikipedia.org/wiki/Hurricane_Dorian%E2%80%93Alabama_controversy). 

The scope of this lab is to determine how much of an effect Sharpiegate had on the Twitter activity related to Hurricane Dorian. Specifically, I will examine if the most significant pockets of storm tweets corresponded with the accepted storm prediction or if the storm clusters followed the storm prediction of Sharpiegate. Essentially, this lab will examine which scenario had a greater effect on the spatial distrubtion of storm tweets: the real storm prediction or an exubarently defended mistake. Through this, the lab addresses the concept of whether reality or gossip more strongly effects people's actions.

### Data Sources

The data for this lab was collected in [rStudio] through a [Twitter API]. Professor Joseph Holler of Middlebury College searched for storm data on September 11, 2019 and searched for the baseline data on November 19, 2019. Only tweets which contained the words 'dorian', 'hurricane', or 'sharpiegate' were collected as storm data. There were no lexicon parameters for the baseline data. For each set of data, tweets within one week prior to the search date were considered and the geographic range was set as 1,000 miles around the coordinates of 32, -78. For each set, 200,000 tweets that match these parameters were mined. An excel file which contains the status id for storm and baseline tweets can be downloaded [here].

In rStudio, I defined the geographic boundaries of each tweet and developed two graphics related to a lexicon content analysis of the tweets. I also used a [Census API] to pull a map of the United States with all counties filled with population data. I then connected directly to my [Postgres] database from rStudio and transfered the storm tweet data, baseline tweet data, and populated county data to my database. I conducted a series of SQL steps with my database using the [QGIS] interphase. Upon the completion of my analysis, I used [GeoDa] to develop four maps using Getis-Ord G* spatial statistics. 


### Analysis Overview

#### Annotated SQL Workflow

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


