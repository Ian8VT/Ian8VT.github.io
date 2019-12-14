### Outline

In this lab, I tried to learn some basic network analysis functions in PostGIS using the pgrouter extension. To learn the functions, I performed my analyses on data of Dar es Salaam, Tanzania, and attempted to create a network topology map around a school in the city. My objective was obtain the total walking time from each node in the topology and then find the average walking time for all nodes within wetlands and compare to all nodes outside of wetlands. However, during the process, I ran into a series of problems which proved severe enough to prevent me from completing this project goal. I will outline the difficulties that I encountered below.

### Data Sources and Platforms

I used three layers of OpenStreetMap data in Dar es Salaam for this lab: wetlands; roads; schools. I accessed all three of these layers from Resilience Academy through a WFS connection in QGIS. From the QGIS interphase, I uploaded the layers to my PostGIS database and performed the functions of this lab. Within the database, I used the pgrouting extension in addition to standard functions. One of the three layers, wetlands, I already had within my database from a previous [lab](../lab_5/). I originally created this layer by directly downloading OpenStreetMap polygon data and selecting terrain designated as wetlands. 

